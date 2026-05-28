/// File: app_colors.dart
/// Purpose: Defines the color palette and branding colors for Zenup Health.
/// Design tokens: Warm, productive calm aesthetic with orange-brown primary.
library app_theme;

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primary Branding (from design) ──
  static const Color primary = Color(0xFF8C5000);           // Warm brown
  static const Color primaryContainer = Color(0xFFF2911B);   // Orange
  static const Color primaryFixed = Color(0xFFFFDCBF);       // Light peach
  static const Color primaryFixedDim = Color(0xFFFFB873);    // Warm gold
  static const Color inversePrimary = Color(0xFFFFB873);     // Inverse accent

  // ── Secondary ──
  static const Color secondary = Color(0xFF5E5E5E);          // Neutral gray
  static const Color secondaryContainer = Color(0xFFE3E2E2);
  static const Color secondaryFixed = Color(0xFFE3E2E2);

  // ── Tertiary ──
  static const Color tertiary = Color(0xFF645D54);
  static const Color tertiaryContainer = Color(0xFFAFA79C);

  // ── Backgrounds & Surfaces ──
  static const Color background = Color(0xFFFFFFFF);         // Pure white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceContainer = Color(0xFFF8F9FC);   // Light surface card
  static const Color surfaceContainerLow = Color(0xFFFFFFFF);
  static const Color surfaceContainerHigh = Color(0xFFF3F4F6);
  static const Color surfaceContainerHighest = Color(0xFFE5E2E1);
  static const Color surfaceDim = Color(0xFFDCD9D9);
  static const Color surfaceBright = Color(0xFFFCF9F8);
  static const Color inverseSurface = Color(0xFF313030);

  // ── Text / On-colors ──
  static const Color textPrimary = Color(0xFF1C1B1B);        // on-background
  static const Color textSecondary = Color(0xFF5E5E5E);      // secondary
  static const Color textPlaceholder = Color(0xFF877363);     // outline
  static const Color textHint = textPlaceholder;              // Alias
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1C1B1B);
  static const Color onSurfaceVariant = Color(0xFF544435);

  // ── Outline ──
  static const Color outline = Color(0xFF877363);
  static const Color outlineVariant = Color(0xFFDAC2AF);

  // ── Status Colors ──
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color info = Color(0xFF3B82F6);

  // ── Icon Colors ──
  static const Color iconActive = Color(0xFF8C5000);
  static const Color iconInactive = Color(0xFF877363);

  // ── Elevation / Shadow ──
  static const Color cardShadow = Color(0x0F000000);

  // ── Glows / Accents ──
  static const Color accent = Color(0xFFF2911B);             // Orange accent
  static const Color accentGlow = Color(0x33F2911B);
  static const Color primaryGlow = Color(0x268C5000);

  // ── Legacy aliases ──
  static const Color backgroundStart = background;
  static const Color backgroundEnd = background;
  static const Color cardBg = surfaceContainer;
  static const Color lightBackgroundStart = background;
  static const Color lightBackgroundEnd = background;
  static const Color lightSurface = background;
  static const Color lightCardBg = surfaceContainer;
  static const Color lightBorder = outlineVariant;
  static const Color lightTextPrimary = textPrimary;
  static const Color lightTextSecondary = textSecondary;
  static const Color lightTextHint = textPlaceholder;
}
