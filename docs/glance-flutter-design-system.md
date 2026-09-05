# Glance — Flutter Design System

A token reference for building `AppTheme` / a shared design library in Flutter, matching the warm mockup. Copy the Dart blocks as-is into your `lib/design/` folder and wire them into `MaterialApp(theme: ...)`.

Suggested file layout:
```
lib/design/
  colors.dart
  typography.dart
  radii.dart
  spacing.dart
  shadows.dart
  theme.dart
  components/ (button_styles.dart, card_styles.dart, chip_styles.dart)
```

---

## 1. Color tokens

| Token | Hex | Use |
|---|---|---|
| `cream` | `#F6EFE2` | App background |
| `paper` | `#FCF8F0` | Card / field background, elevated surfaces |
| `ink` | `#2B2318` | Primary text, primary buttons, splash bg |
| `inkSoft` | `#7A6F5E` | Secondary text, hints, captions |
| `line` | `#E6D9C2` | Borders, dividers, hairlines |
| `amber` | `#C68A3D` | Primary accent — CTAs, active states, student role |
| `amberSoft` | `#EFD9B0` | Amber background tint (chips, highlight cards) |
| `moss` | `#5C6E4E` | Success / present / live states |
| `mossSoft` | `#DCE3CE` | Moss background tint |
| `rose` | `#C97F70` | Destructive / absent / logout |
| `roseSoft` | `#F0D8CE` | Rose background tint |
| `sky` | `#5F7887` | Teacher role accent, secondary info |
| `skySoft` | `#D9E2E4` | Sky background tint |
| `lav` | `#8A7C9B` | Tertiary class-card accent |
| `lavSoft` | `#E4DBEA` | Lav background tint |

```dart
// lib/design/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const cream     = Color(0xFFF6EFE2);
  static const paper     = Color(0xFFFCF8F0);
  static const ink       = Color(0xFF2B2318);
  static const inkSoft   = Color(0xFF7A6F5E);
  static const line      = Color(0xFFE6D9C2);

  static const amber     = Color(0xFFC68A3D);
  static const amberSoft  = Color(0xFFEFD9B0);

  static const moss      = Color(0xFF5C6E4E);
  static const mossSoft   = Color(0xFFDCE3CE);

  static const rose       = Color(0xFFC97F70);
  static const roseSoft   = Color(0xFFF0D8CE);

  static const sky        = Color(0xFF5F7887);
  static const skySoft    = Color(0xFFD9E2E4);

  static const lav        = Color(0xFF8A7C9B);
  static const lavSoft    = Color(0xFFE4DBEA);

  /// Class-card rotation, in display order.
  static const classCardBg = [roseSoft, lavSoft, skySoft, mossSoft, amberSoft];
}
```

**Semantic mapping** (use these names in widgets, not raw colors):
- `success` → `moss` / `mossSoft`
- `danger` → `rose` / `roseSoft`
- `studentRole` → `amber`
- `teacherRole` → `sky`
- `primaryText` → `ink`
- `secondaryText` → `inkSoft`
- `surface` → `paper`
- `background` → `cream`
- `border` → `line`

---

## 2. Typography

Two families, matching the mockup: **Fraunces** (serif, display/headings — carries the app's warmth) and **Inter** (sans, UI/body — everything functional).

Add to `pubspec.yaml`:
```yaml
dependencies:
  google_fonts: ^6.2.1
```

| Style | Family | Size | Weight | Letter-spacing | Use |
|---|---|---|---|---|---|
| `displayLarge` | Fraunces | 40 | 500 | -0.01em | Splash logotype |
| `headlineLarge` | Fraunces | 28 | 500 | -0.01em | Screen titles ("Welcome back") |
| `headlineMedium` | Fraunces | 22 | 500 | -0.01em | Section-level headings |
| `titleMedium` | Fraunces | 17 | 500 | 0 | Card titles (class name) |
| `bodyLarge` | Inter | 15 | 400 | 0 | Primary body copy |
| `bodyMedium` | Inter | 13.5 | 400 | 0 | Secondary copy, descriptions |
| `labelLarge` | Inter | 14.5 | 600 | 0 | Button labels |
| `labelMedium` | Inter | 12.5 | 600 | 0 | Field labels, section eyebrows |
| `labelSmall` | Inter | 11 | 700 | 0.02em | Status pills, tiny meta text |

```dart
// lib/design/typography.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTypography {
  AppTypography._();

  static TextTheme get textTheme => TextTheme(
    displayLarge: GoogleFonts.fraunces(
      fontSize: 40, fontWeight: FontWeight.w500, letterSpacing: -0.3, color: AppColors.ink),
    headlineLarge: GoogleFonts.fraunces(
      fontSize: 28, fontWeight: FontWeight.w500, letterSpacing: -0.2, color: AppColors.ink),
    headlineMedium: GoogleFonts.fraunces(
      fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: -0.2, color: AppColors.ink),
    titleMedium: GoogleFonts.fraunces(
      fontSize: 17, fontWeight: FontWeight.w500, color: AppColors.ink),
    bodyLarge: GoogleFonts.inter(
      fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.ink, height: 1.45),
    bodyMedium: GoogleFonts.inter(
      fontSize: 13.5, fontWeight: FontWeight.w400, color: AppColors.inkSoft, height: 1.4),
    labelLarge: GoogleFonts.inter(
      fontSize: 14.5, fontWeight: FontWeight.w600, color: AppColors.ink),
    labelMedium: GoogleFonts.inter(
      fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.inkSoft),
    labelSmall: GoogleFonts.inter(
      fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.2, color: AppColors.inkSoft),
  );
}
```

---

## 3. Spacing scale

4px base unit — keeps padding/margins consistent across every screen.

| Token | Value |
|---|---|
| `xs` | 4 |
| `sm` | 8 |
| `md` | 12 |
| `lg` | 16 |
| `xl` | 20 |
| `xxl` | 24 |
| `xxxl` | 32 |

```dart
// lib/design/spacing.dart
class AppSpacing {
  AppSpacing._();
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;
}
```

Screen content padding standard: `EdgeInsets.fromLTRB(22, 20, 22, 22)` (matches the mockup's phone content inset).

---

## 4. Radius scale

Roundness is deliberately layered — bigger surfaces get bigger radii, so nothing looks like one uniform "rounded card" default.

| Token | Value | Use |
|---|---|---|
| `radiusSm` | 10 | Field boxes, small chips |
| `radiusMd` | 14 | Settings rows, small buttons |
| `radiusLg` | 16 | Primary buttons, notification cards |
| `radiusXl` | 18 | Role-select cards, dashboard tiles |
| `radiusXxl` | 20 | Class cards |
| `radiusPill` | 100 | Chips, pills, toggles |
| `radiusPhoneFrame` | 42 | Outer device frame (design reference only) |
| `radiusScreen` | 33 | Screen corner inside frame (design reference only) |

```dart
// lib/design/radii.dart
class AppRadius {
  AppRadius._();
  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 16.0;
  static const xl = 18.0;
  static const xxl = 20.0;
  static const pill = 100.0;
}
```

---

## 5. Elevation / shadow

Only two shadow levels are used — resist adding a shadow to every card; reserve it for things that visually "float" (notification banners, the primary CTA).

```dart
// lib/design/shadows.dart
import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  /// Resting cards — no shadow, border only (see AppColors.line).
  static const List<BoxShadow> none = [];

  /// Floating elements: notification banners, dialogs.
  static const List<BoxShadow> floating = [
    BoxShadow(color: Color(0x332B2318), blurRadius: 24, offset: Offset(0, 10)),
  ];

  /// Hero/splash-level depth (rarely used).
  static const List<BoxShadow> hero = [
    BoxShadow(color: Color(0x472B2318), blurRadius: 50, offset: Offset(0, 24)),
  ];
}
```

---

## 6. Component specs

### Buttons
| Variant | Background | Text | Radius | Padding | Use |
|---|---|---|---|---|---|
| Primary | `ink` | `paper` | `lg` (16) | 15v / 20h | Main CTA per screen |
| Outline | transparent | `ink`, 1.4px `ink` border | `lg` (16) | 15v / 20h | Secondary action |
| Outline (danger) | transparent | `rose`, 1.4px `rose` border | `lg` (16) | 15v / 20h | Log out, end class |
| Ghost | transparent | `inkSoft` | — | 8 | Tertiary / dismiss text link |

```dart
// lib/design/components/button_styles.dart
import 'package:flutter/material.dart';
import '../colors.dart';
import '../radii.dart';

class AppButtonStyles {
  AppButtonStyles._();

  static ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: AppColors.ink,
    foregroundColor: AppColors.paper,
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
    elevation: 0,
    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5),
  );

  static ButtonStyle outline = OutlinedButton.styleFrom(
    foregroundColor: AppColors.ink,
    side: const BorderSide(color: AppColors.ink, width: 1.4),
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
  );

  static ButtonStyle outlineDanger = OutlinedButton.styleFrom(
    foregroundColor: AppColors.rose,
    side: const BorderSide(color: AppColors.rose, width: 1.4),
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
  );

  static ButtonStyle ghost = TextButton.styleFrom(
    foregroundColor: AppColors.inkSoft,
    textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13.5),
  );
}
```

### Fields
- Background `paper`, border `1px line`, radius `sm` (10), padding `13v / 14h`.
- Label above field: `labelMedium` style, 6px gap below.

### Class card
- Radius `xxl` (20), padding `16`, min-height `118`.
- Background: rotate through `classCardBg` list.
- Monogram: 34×34 circle, `ink` @ 12% opacity fill, `titleMedium`-weight letter.
- Title: `titleMedium`. Meta line: `labelSmall`-ish but at 11.5px, `ink` @ 62% opacity.

### Status pill
- Radius `pill`, padding `4v / 10h`, text `labelSmall`.
- `present` → bg `mossSoft`, text `moss`. `absent` → bg `roseSoft`, text `rose`.

### Role chip
- Radius `pill`, bg `paper`, border `1px line`, padding `6 6 6 6` (leading dot) `12` trailing.
- Leading dot: 20×20 circle, `amber` for student context / `sky` for teacher context.

### Settings row
- Bg `paper`, border `1px line`, radius `md` (14), padding `13v / 15h`.
- Label `bodyLarge`-weight 600 at 13.5px; hint `labelSmall`-ish at 11px `inkSoft`.

### Toggle
- 38×38 track, radius `pill`. On: bg `moss`, knob right. Off: bg `line`, knob left. Knob: 18×18 circle, `paper`.

### Match / attendance ring
- `conic-gradient`-equivalent: use `CustomPainter` with `SweepGradient` — arc in `amber` (enrollment) or `moss` (successful match) from 0° to `percentage * 360°`, remainder in `line`.
- Center text: percentage in Fraunces 30px/500, label below in `labelSmall`.

---

## 7. Full `ThemeData`

```dart
// lib/design/theme.dart
import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.cream,
    colorScheme: const ColorScheme.light(
      primary: AppColors.ink,
      onPrimary: AppColors.paper,
      secondary: AppColors.amber,
      onSecondary: AppColors.ink,
      surface: AppColors.paper,
      onSurface: AppColors.ink,
      error: AppColors.rose,
      onError: AppColors.paper,
    ),
    textTheme: AppTypography.textTheme,
    dividerColor: AppColors.line,
    cardColor: AppColors.paper,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.paper,
      contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.ink, width: 1.4),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cream,
      foregroundColor: AppColors.ink,
      elevation: 0,
      centerTitle: false,
    ),
  );
}
```

Wire it in:
```dart
MaterialApp(
  theme: AppTheme.light,
  home: const SplashScreen(),
);
```

---

## 8. Do / don't (keep the library consistent)

- **Do** reserve Fraunces for headings and titles only — never for body copy or button labels.
- **Do** vary radius by surface size (bigger surface → bigger radius); don't apply one `radiusMd` everywhere.
- **Do** use border + flat fill for resting cards; reserve shadow (`AppShadows.floating`) for things that should feel like they're overlaying content (notifications, sheets).
- **Don't** introduce a new accent color outside the token list above for a one-off screen — extend the token list first, so the palette stays coherent.
- **Don't** use pure black/white anywhere — always `ink`/`paper`/`cream`, which keeps the warm tone consistent even in shadows and dividers.
