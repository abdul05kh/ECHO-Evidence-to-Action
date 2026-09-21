import 'package:flutter/material.dart';

/// ECHO Design System - STRICT LIGHT THEME
///
/// Palette specifications:
/// Canvas: #F7F9FC
/// Surface: #FFFFFF
/// Secondary Surface: #F1F5F9
/// Text Primary: #0F172A (Deep Slate Navy)
/// Text Secondary: #475569 (Muted Slate)
/// Text Tertiary: #94A3B8 (Subtle Slate)
/// Border / Divider: #E2E8F0
/// Primary Accent: #E5A000 / #F59E0B (iQOO Warm Gold)
/// Action Blue: #2563EB (Interactive actions)
/// Success: #16A34A (Accessible Green)
/// Warning: #D97706 (Accessible Amber)
/// Danger: #DC2626 (Accessible Red)
class EchoTheme {
  static const Color canvasColor = Color(0xFFF7F9FC);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color secondarySurface = Color(0xFFF1F5F9);
  static const Color tertiarySurface = Color(0xFFE2E8F0);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color borderColor = Color(0xFFE2E8F0);

  // iQOO Signature Accent
  static const Color accentGold = Color(0xFFE5A000);
  static const Color accentGoldLight = Color(0xFFFEF3C7);
  static const Color accentGoldDark = Color(0xFFB45309);

  // Interactive Action Blue
  static const Color actionBlue = Color(0xFF2563EB);
  static const Color actionBlueLight = Color(0xFFDBEAFE);

  // Status Colors
  static const Color successGreen = Color(0xFF16A34A);
  static const Color successGreenLight = Color(0xFFDCFCE7);

  static const Color warningAmber = Color(0xFFD97706);
  static const Color warningAmberLight = Color(0xFFFEF3C7);

  static const Color dangerRed = Color(0xFFDC2626);
  static const Color dangerRedLight = Color(0xFFFEE2E2);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: canvasColor,
      primaryColor: actionBlue,
      colorScheme: const ColorScheme.light(
        primary: actionBlue,
        onPrimary: Colors.white,
        secondary: accentGold,
        onSecondary: textPrimary,
        surface: surfaceColor,
        onSurface: textPrimary,
        error: dangerRed,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 1,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: borderColor, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: actionBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: borderColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borderColor,
        thickness: 1,
        space: 1,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.8,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.2,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.45,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textTertiary,
        ),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
