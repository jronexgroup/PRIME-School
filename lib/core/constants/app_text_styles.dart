import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle display({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        letterSpacing: -1,
      );

  static TextStyle h1({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        letterSpacing: -0.5,
      );

  static TextStyle h2({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        letterSpacing: -0.3,
      );

  static TextStyle h3({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      );

  static TextStyle h4({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      );

  static TextStyle bodyLarge({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        height: 1.5,
      );

  static TextStyle body({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        height: 1.5,
      );

  static TextStyle bodySmall({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      );

  static TextStyle label({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
        letterSpacing: 0.5,
      );

  static TextStyle button() => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.2,
      );

  static TextStyle buttonSmall() => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle caption({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
      );

  static TextStyle bengali({bool isDark = false}) => GoogleFonts.notoSansBengali(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        height: 1.6,
      );

  static TextStyle bengaliLarge({bool isDark = false}) => GoogleFonts.notoSansBengali(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      );
}
