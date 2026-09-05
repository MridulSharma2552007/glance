# Facial Recognition Attendance System — Software Architecture Design Document

**Version:** 1.0
**Stack:** Flutter (client) · Node.js/Express (auth + core API, hosted on Vercel) · FastAPI + InsightFace "Buffalo" model (local face-vector service, exposed via ngrok) · Supabase (Postgres + pgvector, Storage, Realtime)

---

## 1. System Overview

Four cooperating services:

| Component | Responsibility | Hosting |
|---|---|---|
| Flutter App | UI for student/teacher, camera capture, session UI | Mobile (iOS/Android) |
| Node.js API | Auth, token issuance/validation, class & session management, attendance orchestration, notifications | Vercel (serverless functions) |
| FastAPI + Buffalo | Face detection + 512-d embedding extraction, cosine-similarity matching | Local machine (GPU/CPU), tunneled via ngrok |
| Supabase | Postgres (with `pgvector`), Auth-independent custom token store, Realtime channel for "class started" push, Storage for optional face thumbnails | Supabase Cloud |

**Why split Node.js and FastAPI:** Buffalo (ArcFace/InsightFace) needs Python + ONNX/torch runtime and ideally a GPU — that's impractical on Vercel serverless. Node.js stays the stateless, horizontally-scalable API brain; FastAPI is a dumb, fast "vector extractor + matcher" microservice that Node calls over HTTPS via the ngrok tunnel URL (stored as an env var / DB config row so it can be rotated when ngrok restarts).

---

## 2. High-Level Flow

1. **Signup/Login** → Flutter calls Node `/auth/login` → Node validates credentials against Supabase `users` table → Node generates a custom opaque token (`crypto.randomBytes`), hashes it, stores hash in `auth_tokens`, returns raw token to client.
2. **Face Enrollment (first login only, student)** → Flutter captures face → sends image (base64/multipart) to Node `/face/register` → Node proxies to FastAPI `/extract-embedding` → FastAPI (Buffalo) returns 512-d float vector → Node stores it in `student_face_vectors.embedding` (pgvector column) tied to `student_id`.
3. **Teacher Starts Class** → Flutter calls Node `/sessions/start` → Node creates a `class_sessions` row, publishes an event on Supabase Realtime channel `class:{class_id}` → enrolled students' apps receive push and open the scan screen.
4. **Student Marks Attendance** → Flutter captures face → Node `/attendance/mark` → Node proxies to FastAPI `/extract-embedding` → FastAPI returns fresh vector → Node runs a pgvector cosine-distance query against that student's stored embedding (`1 - (a <=> b)` similarity) → if similarity ≥ 0.75 → insert into `attendance_records` with status `present`.

---

## 3. Database Schema (Supabase / Postgres)

Enable extensions first:

```sql
create extension if not exists pgvector;
create extension if not exists pgcrypto;
```

Using `pgvector` is the key efficiency decision: instead of pulling all 512-d vectors into Node/FastAPI and computing cosine similarity in application code, similarity search runs **inside Postgres** with an ANN index (`ivfflat` or `hnsw`), so lookups stay fast even at scale and there's no need to ship large vector blobs over the network for every scan.

### 3.1 `users` (base identity table — shared by student & teacher)

| Column | Type | Constraints | Notes |
|---|---|---|---|
| id | uuid | PK, default `gen_random_uuid()` | |
| full_name | text | not null | |
| email | text | unique, not null | login identifier |
| password_hash | text | not null | bcrypt/argon2 hash, never plaintext |
| role | text | not null, check in (`student`,`teacher`) | drives routing after login |
| status | text | default `active` | active / disabled |
| created_at | timestamptz | default now() | |
| updated_at | timestamptz | default now() | |

Index: `unique(email)` (already implied), `index on role` if you frequently filter by role.

### 3.2 `students` (1:1 extension of `users`)

| Column | Type | Constraints |
|---|---|---|
| user_id | uuid | PK, FK → users.id ON DELETE CASCADE |
| enrollment_no | text | unique, not null |
| department | text | |
| year | smallint | |
| face_registered | boolean | default false |

### 3.3 `teachers` (1:1 extension of `users`)

| Column | Type | Constraints |
|---|---|---|
| user_id | uuid | PK, FK → users.id ON DELETE CASCADE |
| employee_id | text | unique |
| department | text | |

### 3.4 `student_face_vectors` (embedding store — separate table, not on `students`, for write-isolation and to allow re-enrollment history)

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK default gen_random_uuid() |
| student_id | uuid | FK → students.user_id, not null |
| embedding | vector(512) | not null |
| model_version | text | e.g. `buffalo_l` — track which model produced it |
| is_active | boolean | default true — only one active vector per student |
| created_at | timestamptz | default now() |

```sql
create unique index idx_one_active_vector
  on student_face_vectors(student_id) where is_active;

create index idx_face_embedding_ann
  on student_face_vectors using ivfflat (embedding vector_cosine_ops)
  with (lists = 100);
```

Keeping `model_version` matters — if you ever upgrade the Buffalo model, old vectors aren't comparable to new ones; you can filter or force re-enrollment.

### 3.5 `classes`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK default gen_random_uuid() |
| teacher_id | uuid | FK → teachers.user_id |
| name | text | not null |
| subject_code | text | |
| schedule_days | text[] | e.g. `{Mon,Wed,Fri}` |
| start_time | time | |
| end_time | time | |
| created_at | timestamptz | default now() |

### 3.6 `class_enrollments` (mapping table — students ↔ classes, many-to-many)

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| class_id | uuid | FK → classes.id ON DELETE CASCADE |
| student_id | uuid | FK → students.user_id ON DELETE CASCADE |
| enrolled_at | timestamptz | default now() |

```sql
create unique index idx_class_student_unique on class_enrollments(class_id, student_id);
create index idx_enrollments_by_student on class_enrollments(student_id);
```

This composite unique index is what makes "get all classes for a student" and "get all students for a class" both cheap — it's a covering index for either direction depending on query, and it also enforces you can't double-enroll.

### 3.7 `class_sessions` (one row per "teacher pressed Start Class")

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| class_id | uuid | FK → classes.id |
| session_token | text | unique — short-lived token embedded in the notification, used to scope attendance marks to this exact session |
| status | text | check in (`active`,`ended`) default `active` |
| started_at | timestamptz | default now() |
| ended_at | timestamptz | nullable |

Index: `index on (class_id, status)` — fast lookup of "is there an active session for this class right now."

### 3.8 `attendance_records`

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| session_id | uuid | FK → class_sessions.id ON DELETE CASCADE |
| student_id | uuid | FK → students.user_id |
| similarity_score | numeric(5,4) | e.g. 0.8123 |
| status | text | check in (`present`,`rejected`) |
| marked_at | timestamptz | default now() |

```sql
create unique index idx_one_mark_per_session
  on attendance_records(session_id, student_id) where status = 'present';
```

This unique partial index is your efficiency/integrity guard — a student can't be marked present twice in the same session, but a rejected attempt (below 0.75 similarity) doesn't block a retry.

### 3.9 `auth_tokens` (custom crypto-generated session tokens)

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| user_id | uuid | FK → users.id ON DELETE CASCADE |
| token_hash | text | not null — SHA-256 of the raw token; **never store raw token** |
| device_info | text | optional, from client headers |
| expires_at | timestamptz | not null |
| revoked | boolean | default false |
| created_at | timestamptz | default now() |

```sql
create index idx_token_hash on auth_tokens(token_hash);
create index idx_token_user_active on auth_tokens(user_id) where not revoked;
```

Lookup on every authenticated request is a hash equality match on an indexed column — O(log n), fast even with millions of sessions.

### 3.10 `notifications` (class-started push log, optional but useful for audit)

| Column | Type | Constraints |
|---|---|---|
| id | uuid | PK |
| session_id | uuid | FK → class_sessions.id |
| student_id | uuid | FK → students.user_id |
| delivered | boolean | default false |
| sent_at | timestamptz | default now() |

---

## 4. Entity-Relationship Summary

```
users 1───1 students 1───* student_face_vectors
users 1───1 teachers 1───* classes
classes *───* students   (via class_enrollments)
classes 1───* class_sessions 1───* attendance_records
classes 1───* class_sessions 1───* notifications
users 1───* auth_tokens
```

---

## 5. Auth Design (Custom Token, not Supabase Auth)

Since you're rolling your own token instead of Supabase Auth:

```js
const crypto = require('crypto');

function generateToken() {
  const raw = crypto.randomBytes(32).toString('hex');       // sent to client
  const hash = crypto.createHash('sha256').update(raw).digest('hex'); // stored in DB
  return { raw, hash };
}
```

- Store only `hash` in `auth_tokens.token_hash`.
- Client sends `raw` token in `Authorization: Bearer <token>` header on every request.
- Node middleware hashes the incoming token and does an indexed lookup against `auth_tokens.token_hash`, checks `expires_at` and `revoked`.
- Recommended TTL: 7 days for students/teachers, with a `/auth/refresh` endpoint that extends expiry if token is still valid.

---

## 6. API Specification

All Node endpoints are prefixed `/api/v1`. All responses follow a consistent envelope:

```json
{
  "success": true,
  "data": { },
  "error": null
}
```

Error responses:

```json
{
  "success": false,
  "data": null,
  "error": { "code": "INVALID_TOKEN", "message": "Session expired, please log in again." }
}
```

### 6.1 Auth Service

**POST `/api/v1/auth/signup`**
```json
// Request
{
  "role": "student",
  "full_name": "Aarav Sharma",
  "email": "aarav@college.edu",
  "password": "•••••••",
  "enrollment_no": "CS21B045"
}
// Response 201
{ "success": true, "data": { "user_id": "uuid", "role": "student" } }
```

**POST `/api/v1/auth/login`**
```json
// Request
{ "email": "aarav@college.edu", "password": "•••••••", "role": "student" }
// Response 200
{
  "success": true,
  "data": {
    "token": "9f3a...raw-hex-token",
    "expires_at": "2026-09-11T10:00:00Z",
    "user": { "id": "uuid", "full_name": "Aarav Sharma", "role": "student", "face_registered": false }
  }
}
```

**POST `/api/v1/auth/logout`** — header `Authorization: Bearer <token>` → revokes token row.

**POST `/api/v1/auth/refresh`** — extends `expires_at` for a still-valid token.

### 6.2 Face Enrollment

**POST `/api/v1/face/register`** (student only, one-time or re-enroll)
```json
// Request (multipart/form-data)
// field "image": <jpeg/png binary>
```
Node flow: receives image → forwards to FastAPI `POST {NGROK_URL}/extract-embedding` → gets vector → deactivates old vector (`is_active = false`) → inserts new row in `student_face_vectors` → sets `students.face_registered = true`.

```json
// Response 200
{ "success": true, "data": { "registered": true, "model_version": "buffalo_l" } }
```

### 6.3 Class & Session Management (teacher)

**POST `/api/v1/classes`**
```json
{ "name": "Data Structures", "subject_code": "CS201", "schedule_days": ["Mon","Wed"], "start_time": "10:00", "end_time": "11:00" }
```

**POST `/api/v1/classes/:classId/enroll`**
```json
{ "student_ids": ["uuid1", "uuid2", "uuid3"] }
```

**POST `/api/v1/classes/:classId/sessions/start`**
```json
// Response 200
{
  "success": true,
  "data": { "session_id": "uuid", "session_token": "sess_ab12cd", "started_at": "2026-09-04T10:00:03Z" }
}
```
Side effect: Node publishes to Supabase Realtime channel `class:{classId}` with payload `{ event: "session_started", session_id, session_token }`; every enrolled student's app (subscribed on login) receives it and auto-navigates to the scan screen.

**POST `/api/v1/classes/:classId/sessions/:sessionId/end`** → sets `status='ended'`, `ended_at=now()`.

### 6.4 Attendance Marking (student)

**POST `/api/v1/attendance/mark`**
```json
// Request (multipart/form-data)
// fields: session_token=sess_ab12cd, image=<binary>
```
Node flow:
1. Resolve `session_token` → `class_sessions` row → confirm `status='active'`.
2. Forward image to FastAPI `/extract-embedding` → get 512-d vector `v_new`.
3. Query Postgres:
```sql
select 1 - (embedding <=> $1::vector) as similarity
from student_face_vectors
where student_id = $2 and is_active = true;
```
4. If `similarity >= 0.75` → insert `attendance_records(status='present')`.
5. Else → insert `status='rejected'` (for audit) and return failure to client.

```json
// Response 200 (match)
{
  "success": true,
  "data": { "status": "present", "similarity_score": 0.8421, "marked_at": "2026-09-04T10:02:11Z" }
}
// Response 200 (no match)
{
  "success": true,
  "data": { "status": "rejected", "similarity_score": 0.612 },
  "error": { "code": "FACE_NOT_MATCHED", "message": "Face did not match enrolled profile. Try again." }
}
```

**GET `/api/v1/attendance/session/:sessionId`** (teacher) — list of present students for that session.

**GET `/api/v1/attendance/student/:studentId/history?class_id=`** — attendance history for a student.

### 6.5 FastAPI (Buffalo) Service — internal only, called by Node, not by Flutter directly

**POST `/extract-embedding`**
```json
// Request (multipart/form-data): image=<binary>
// Response 200
{ "success": true, "embedding": [0.0123, -0.0456, "...512 floats..."], "model_version": "buffalo_l", "face_detected": true }
```
- If no face / multiple faces detected → `{ "success": false, "error": "NO_FACE_DETECTED" }`, Node surfaces this to the client instead of attempting a match.
- Keep this endpoint stateless — it never touches the DB directly; Node owns all persistence so there's a single source of truth and the ngrok tunnel can restart without any data-consistency risk.

---

## 7. Notification / Realtime Design

Use **Supabase Realtime** (Postgres logical replication over websockets) rather than a custom push server:
- On session start, Node inserts the `class_sessions` row — Flutter apps for enrolled students subscribe to `postgres_changes` on `class_sessions` filtered by `class_id in (their enrolled classes)`, or simpler: subscribe to a broadcast channel `class:{classId}` that Node explicitly triggers via Supabase's broadcast API after computing which students are enrolled (avoids leaking session data via RLS edge cases).
- This avoids building/maintaining a separate WebSocket server on Vercel (which doesn't support persistent long-lived connections well in serverless functions anyway).

---

## 8. Deployment Notes

| Service | Host | Notes |
|---|---|---|
| Node.js API | Vercel (serverless functions) | Stateless; DB pooling via Supabase's pooler (PgBouncer) — use `pg` with connection pooling mode `transaction`, not persistent connections, since serverless functions cold-start frequently |
| FastAPI + Buffalo | Local machine + ngrok | Store the current ngrok URL in a `system_config` table (key/value) so Node reads it dynamically instead of hardcoding — ngrok free tier URLs rotate on restart |
| Supabase | Cloud | Enable `pgvector`; use Row Level Security (RLS) policies scoping students to their own rows and teachers to their own classes |
| Flutter | App stores / TestFlight | Talks only to Node API, never directly to FastAPI or Supabase, keeping the service topology simple and the DB credentials off the client |

Suggested `system_config` table:

| Column | Type |
|---|---|
| key | text PK |
| value | text |
| updated_at | timestamptz |

e.g. row `('face_service_url', 'https://abcd1234.ngrok-free.app')` — Node fetches this at request time (with short in-memory cache) so a teacher restarting their laptop's ngrok tunnel doesn't require a redeploy.

---

## 9. Security Checklist

- Passwords: bcrypt/argon2, never plaintext.
- Tokens: only hashes stored, raw token shown once at login.
- FastAPI endpoint should require a shared-secret header (`X-Internal-Key`) from Node, since ngrok URLs are semi-public — never let Flutter call it directly.
- Rate-limit `/auth/login` and `/attendance/mark` per user/IP to prevent brute-force or spam-scanning.
- Store face vectors only — never store raw face images long-term (avoids biometric-data-retention compliance issues); if you want thumbnails for teacher review, store them in Supabase Storage with strict RLS, separate from the vector table.

---

## 10. Why These Tables Are Efficient

- **Separation of `users` from role tables** avoids a wide sparse table and keeps role-specific columns indexed independently.
- **`student_face_vectors` as its own table** (not a column on `students`) lets you keep enrollment history, support model upgrades, and index the vector column with `ivfflat` without bloating the frequently-joined `students` row.
- **Composite unique index on `class_enrollments(class_id, student_id)`** serves both "students in a class" and "classes for a student" lookups and enforces integrity in one structure.
- **Partial unique index on `attendance_records`** (`where status='present'`) prevents duplicate present-marks without needing an extra existence-check query before insert.
- **Session-scoped `session_token`** decouples attendance marking from long-lived auth tokens, so a session token can be short-TTL and rotated per class without touching user login state.
