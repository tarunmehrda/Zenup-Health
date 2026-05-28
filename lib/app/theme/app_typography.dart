/// File: app_typography.dart
/// Purpose: Defines text styles and typography for Zenup Health.
/// Design tokens: Manrope font family across all platforms.
library app_theme;

import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  /// Primary font family — Manrope.
  static const String fontFamily = 'Manrope';

  // ── Headlines ──
  static const TextStyle headlineXl = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.2,         // 48/40
    letterSpacing: -0.8,  // -0.02em
  );

  static TextStyle get headlineLarge => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,         // 40/32
    letterSpacing: -0.32, // -0.01em
  );

  static TextStyle get headlineLargeMobile => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.286,       // 36/28
  );

  static TextStyle get headlineMedium => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.333,       // 32/24
  );

  static TextStyle get headlineSmall => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ── Titles ──
  static TextStyle get titleLarge => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get titleMedium => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get titleSmall => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  // ── Body ──
  static TextStyle get bodyLarge => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.556,       // 28/18
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,         // 24/16
  );

  static TextStyle get bodySmall => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ── Labels ──
  static TextStyle get labelLarge => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.429,       // 20/14
    letterSpacing: 0.14,  // 0.01em
  );

  static TextStyle get labelMedium => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.429,
    letterSpacing: 0.14,
  );

  static TextStyle get labelSmall => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.333,       // 16/12
    letterSpacing: 0.24,  // 0.02em
  );
}
