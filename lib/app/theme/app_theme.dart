import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.cairoTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.surfaceLight,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryCharcoal,
        onPrimaryContainer: AppColors.surfaceLight,
        secondary: AppColors.secondaryTerracotta,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: Colors.white,
        tertiary: AppColors.successGreen,
        onTertiary: Colors.white,
        error: AppColors.errorRed,
        onError: Colors.white,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.errorRed,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.onSurfaceLight,
        onSurfaceVariant: AppColors.onSurfaceVariantLight,
        outline: AppColors.outlineLight,
        outlineVariant: AppColors.outlineVariantLight,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.cairo(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurfaceLight,
          height: 1.3,
        ),
        displayMedium: GoogleFonts.cairo(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurfaceLight,
          height: 1.3,
        ),
        headlineLarge: GoogleFonts.cairo(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurfaceLight,
          height: 1.3,
        ),
        headlineMedium: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurfaceLight,
          height: 1.35,
        ),
        titleLarge: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurfaceLight,
        ),
        titleMedium: GoogleFonts.cairo(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceLight,
        ),
        bodyLarge: GoogleFonts.cairo(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceLight,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.cairo(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceVariantLight,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurfaceLight,
        ),
        labelMedium: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceVariantLight,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.onSurfaceLight),
        titleTextStyle: TextStyle(
          color: AppColors.onSurfaceLight,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceCardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          side: const BorderSide(color: AppColors.outlineLight, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceCardLight,
        selectedItemColor: AppColors.secondaryTerracotta,
        unselectedItemColor: AppColors.onSurfaceVariantLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.outlineLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.outlineLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.secondaryTerracotta, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
        hintStyle: const TextStyle(
          color: AppColors.onSurfaceVariantLight,
          fontSize: 14,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.cairoTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Colors.white,
      scaffoldBackgroundColor: AppColors.surfaceDark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Colors.white,
        onPrimary: AppColors.surfaceDark,
        primaryContainer: AppColors.surfaceContainerDark,
        onPrimaryContainer: Colors.white,
        secondary: AppColors.secondaryTerracotta,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: Colors.white,
        tertiary: AppColors.successGreenLight,
        onTertiary: Colors.white,
        error: AppColors.errorRed,
        onError: Colors.white,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.errorRed,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.onSurfaceDark,
        onSurfaceVariant: AppColors.onSurfaceVariantDark,
        outline: AppColors.outlineDark,
        outlineVariant: AppColors.outlineVariantDark,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.cairo(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurfaceDark,
          height: 1.3,
        ),
        displayMedium: GoogleFonts.cairo(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurfaceDark,
          height: 1.3,
        ),
        headlineLarge: GoogleFonts.cairo(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurfaceDark,
          height: 1.3,
        ),
        headlineMedium: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurfaceDark,
          height: 1.35,
        ),
        titleLarge: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurfaceDark,
        ),
        titleMedium: GoogleFonts.cairo(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceDark,
        ),
        bodyLarge: GoogleFonts.cairo(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceDark,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.cairo(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceVariantDark,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurfaceDark,
        ),
        labelMedium: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceVariantDark,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.onSurfaceDark),
        titleTextStyle: TextStyle(
          color: AppColors.onSurfaceDark,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceCardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          side: const BorderSide(color: AppColors.outlineDark, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceCardDark,
        selectedItemColor: AppColors.secondaryTerracotta,
        unselectedItemColor: AppColors.onSurfaceVariantDark,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLowDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.outlineDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.outlineDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.secondaryTerracotta, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
        hintStyle: const TextStyle(
          color: AppColors.onSurfaceVariantDark,
          fontSize: 14,
        ),
      ),
    );
  }
}
