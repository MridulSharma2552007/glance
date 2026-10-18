from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from ultralytics import YOLO
import cv2
import numpy as np
from insightface.app import FaceAnalysis
from pydantic import BaseModel

app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

model = None
face_app = None

@app.on_event("startup")
async def load_models():
    global model, face_app
    model = YOLO("yolov8n.pt")
    face_app = FaceAnalysis(name="buffalo_l")
    face_app.prepare(ctx_id=-1, det_size=(640, 640))


@app.post("/detect")
async def detect(file: UploadFile = File(...)):
    try:
        img_bytes = await file.read()
        nparr = np.frombuffer(img_bytes, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        
        if img is None:
            return {"error": "Invalid image"}
        
        h, w, _ = img.shape
        results = model(img)
        detections = []
        
        for r in results:
            for box in r.boxes:
                cls_id = int(box.cls[0])
                name = model.names[cls_id]
                conf = float(box.conf[0])
                x1, y1, x2, y2 = map(int, box.xyxy[0])
                
                # Clamp safely
                x1 = max(0, x1)
                y1 = max(0, y1)
                x2 = min(w, x2)
                y2 = min(h, y2)
                
                crop = img[y1:y2, x1:x2]
                embedding = None
                
                if name == "person" and crop.size > 0:
                    faces = face_app.get(crop)
                    if len(faces) > 0:
                        emb = faces[0].embedding
                        # Normalize embedding for consistent comparison
                        emb = emb / np.linalg.norm(emb)
                        embedding = emb.tolist()
                
                detections.append({
                    "object": name,
                    "confidence": conf,
                    "box": [x1, y1, x2, y2],
                    "embedding": embedding
                })
        
        return {"detections": detections}
    
    except cv2.error:
        raise HTTPException(status_code=400, detail="Image processing failed")
    except Exception:
        raise HTTPException(status_code=500, detail="Internal server error")


class CompareRequest(BaseModel):
    embedding1: list[float]
    embedding2: list[float]


@app.post("/compare")
async def compare_embeddings(req: CompareRequest):
    if len(req.embedding1) != 512 or len(req.embedding2) != 512:
        raise HTTPException(status_code=400, detail="Embeddings must be 512 dimensions")
    
    emb1 = np.array(req.embedding1)
    emb2 = np.array(req.embedding2)
    
    emb1 = emb1 / np.linalg.norm(emb1)
    emb2 = emb2 / np.linalg.norm(emb2)
    
    similarity = float(np.dot(emb1, emb2) * 100)
    
    return {
        "similarity": round(similarity, 2),
        "same_person": similarity > 70
    }