/// File: context_extensions.dart
/// Purpose: Provides utility extension methods on BuildContext for cleaner UI code.
library core;

import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // Media Query shortcuts
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;
  Orientation get orientation => mediaQuery.orientation;

  // Navigator shortcuts
  NavigatorState get navigator => Navigator.of(this);

  void go(String routeName, {Object? arguments}) {
    Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
  }
}
