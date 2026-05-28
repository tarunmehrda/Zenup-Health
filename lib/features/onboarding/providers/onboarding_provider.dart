/// File: onboarding_provider.dart
/// Purpose: Manages user progress and slide selections within Onboarding flow.
library features;

import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  int _currentPage = 0;
  final int totalSlides = 3;

  int get currentPage => _currentPage;

  void setPage(int index) {
    if (index >= 0 && index < totalSlides) {
      _currentPage = index;
      notifyListeners();
    }
  }

  void nextPage() {
    if (_currentPage < totalSlides - 1) {
      _currentPage++;
      notifyListeners();
    }
  }
}
