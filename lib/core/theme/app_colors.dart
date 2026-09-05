import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Base palette
  static const cream = Color(0xFFF6EFE2);
  static const paper = Color(0xFFFCF8F0);
  static const ink = Color(0xFF2B2318);
  static const inkSoft = Color(0xFF7A6F5E);
  static const line = Color(0xFFE6D9C2);

  // Amber — primary accent, CTAs, active states, student role
  static const amber = Color(0xFFC68A3D);
  static const amberSoft = Color(0xFFEFD9B0);

  // Moss — success / present / live
  static const moss = Color(0xFF5C6E4E);
  static const mossSoft = Color(0xFFDCE3CE);

  // Rose — destructive / absent / logout
  static const rose = Color(0xFFC97F70);
  static const roseSoft = Color(0xFFF0D8CE);

  // Sky — teacher role accent, secondary info
  static const sky = Color(0xFF5F7887);
  static const skySoft = Color(0xFFD9E2E4);

  // Lav — tertiary class-card accent
  static const lav = Color(0xFF8A7C9B);
  static const lavSoft = Color(0xFFE4DBEA);

  // Class-card background rotation
  static const classCardBg = [roseSoft, lavSoft, skySoft, mossSoft, amberSoft];
}
