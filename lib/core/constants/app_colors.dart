import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Branding
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color accent = Color(0xFF10B981);  // Emerald/Teal
  static const Color accentGlow = Color(0x3310B981);

  // Backgrounds
  static const Color backgroundStart = Color(0xFF0F172A); // Slate 900
  static const Color backgroundEnd = Color(0xFF020617);   // Slate 950
  static const Color surface = Color(0xFF1E293B);          // Slate 800
  static const Color cardBg = Color(0xFF1E293B);

  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);    // Slate 50
  static const Color textSecondary = Color(0xFF94A3B8);  // Slate 400
  static const Color textHint = Color(0xFF64748B);       // Slate 500

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Shimmer / Glows
  static const Color primaryGlow = Color(0x266366F1); // 15% opacity

  // Light Theme Colors
  static const Color lightBackgroundStart = Color(0xFFF8FAFC); // Slate 50
  static const Color lightBackgroundEnd = Color(0xFFF1F5F9);   // Slate 100
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCardBg = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);          // Slate 200

  // Light Theme Text Colors
  static const Color lightTextPrimary = Color(0xFF0F172A);    // Slate 900
  static const Color lightTextSecondary = Color(0xFF475569);  // Slate 600
  static const Color lightTextHint = Color(0xFF94A3B8);       // Slate 400
}
