/// File: app_spacing.dart
/// Purpose: Defines spacing, padding, and layout constants for Zenup Health.
library app_theme;

import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // Basic spacing units
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // EdgeInsets constants
  static const EdgeInsets paddingAllXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingAllSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingAllMD = EdgeInsets.all(md);
  static const EdgeInsets paddingAllLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingAllXL = EdgeInsets.all(xl);

  static const EdgeInsets paddingSymmetricH = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingSymmetricV = EdgeInsets.symmetric(vertical: md);

  // Border radius values
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;

  // BorderRadius objects
  static final BorderRadius borderRadiusXS = BorderRadius.circular(radiusXS);
  static final BorderRadius borderRadiusSM = BorderRadius.circular(radiusSM);
  static final BorderRadius borderRadiusMD = BorderRadius.circular(radiusMD);
  static final BorderRadius borderRadiusLG = BorderRadius.circular(radiusLG);
  static final BorderRadius borderRadiusXL = BorderRadius.circular(radiusXL);
}
