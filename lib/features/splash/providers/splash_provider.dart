/// File: splash_provider.dart
/// Purpose: Holds logic and states for initial app loading/initialization tasks.
library features;

import 'package:flutter/material.dart';

class SplashProvider extends ChangeNotifier {
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initializeApp() async {
    // Perform mock setup tasks (like loading preferences or checking auth state)
    await Future.delayed(const Duration(milliseconds: 3000));
    _isInitialized = true;
    notifyListeners();
  }
}
