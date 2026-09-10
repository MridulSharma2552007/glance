import 'package:flutter/material.dart';
import 'package:glance/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextTheme get textTheme => TextTheme(
    displayLarge: GoogleFonts.fraunces(
      fontSize: 40,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.3,
      color: AppColors.amberSoft,
    ),
    headlineLarge: GoogleFonts.fraunces(
      fontSize: 28,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.2,
      color: AppColors.ink,
    ),
    headlineMedium: GoogleFonts.fraunces(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.2,
      color: AppColors.ink,
    ),
    titleMedium: GoogleFonts.fraunces(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      color: AppColors.ink,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.ink,
      height: 1.45,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 13.5,
      fontWeight: FontWeight.w400,
      color: AppColors.inkSoft,
      height: 1.4,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 14.5,
      fontWeight: FontWeight.w600,
      color: AppColors.ink,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12.5,
      fontWeight: FontWeight.w600,
      color: AppColors.inkSoft,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
      color: AppColors.inkSoft,
    ),
  );
}
