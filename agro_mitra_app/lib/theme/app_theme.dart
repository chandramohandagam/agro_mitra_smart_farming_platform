import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
        inversePrimary: AppColors.inversePrimary,
        surfaceTint: AppColors.surfaceTint,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _buildTextTheme(),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
        color: AppColors.surfaceContainerLowest,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          minimumSize: const Size(double.infinity, 56),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          side: const BorderSide(color: AppColors.primary),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceBright.withValues(alpha: 0.7),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        backgroundColor: AppColors.surfaceContainerHigh,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        height: 64 / 57,
        color: AppColors.onSurface,
      ),
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 40 / 32,
        color: AppColors.onSurface,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 36 / 28,
        color: AppColors.onSurface,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 28 / 22,
        color: AppColors.onSurface,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 24 / 16,
        color: AppColors.onSurface,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 20 / 14,
        color: AppColors.onSurface,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 20 / 14,
        color: AppColors.onSurface,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 16 / 11,
        color: AppColors.onSurface,
      ),
    );
  }
}
