import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Base palette — warmed up to match the logo exploration
  static const cream    = Color(0xFFF6F0D6); // was F6EFE2 — more yellow, matches sketch bg
  static const paper    = Color(0xFFFBF6E4); // was FCF8F0 — matches logo tile card bg
  static const ink      = Color(0xFF1E1B16); // was 2B2318 — deeper charcoal, matches rough outline color
  static const inkSoft  = Color(0xFF7A7460); // was 7A6F5E — nudged to sit with the new ink
  static const line     = Color(0xFFE6D9C2); // unchanged

  // Amber — primary accent, CTAs, active states, student role
  static const amber     = Color(0xFFC68A3D); // unchanged — used as Concept A's blob fill
  static const amberSoft = Color(0xFFEFD9B0); // unchanged

  // Moss — success / present / live
  static const moss     = Color(0xFF5C6E4E); // unchanged — used as Concept B's blob fill
  static const mossSoft = Color(0xFFDCE3CE); // unchanged

  // Rose — destructive / absent / logout
  static const rose     = Color(0xFFC97F70); // unchanged — used as Concept C's blob fill
  static const roseSoft = Color(0xFFF0D8CE); // unchanged

  // Sky — teacher role accent, secondary info
  static const sky     = Color(0xFF5F7887); // unchanged
  static const skySoft = Color(0xFFD9E2E4); // unchanged

  // Lav — tertiary class-card accent
  static const lav     = Color(0xFF8A7C9B); // unchanged
  static const lavSoft = Color(0xFFE4DBEA); // unchanged

  // Logo / illustration-only token — the rough hand-drawn outline color.
  // Slightly different from `ink` on purpose: this is pure charcoal for linework,
  // while `ink` stays the UI text/button color. Keep them separate so a future
  // UI-ink tweak doesn't silently change the logo.
  static const charcoal = Color(0xFF000000);

  // Class-card background rotation
  static const classCardBg = [roseSoft, lavSoft, skySoft, mossSoft, amberSoft];
}