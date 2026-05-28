/// File: home_notifier.dart
/// Purpose: Manages loading states and operations for the home dashboard.
library features;

import 'package:flutter/material.dart';
import '../data/home_repository.dart';

class HomeNotifier extends ChangeNotifier {
  final HomeRepository _repository = HomeRepository();
  bool _isLoading = false;
  Map<String, dynamic> _vitals = {};

  bool get isLoading => _isLoading;
  Map<String, dynamic> get vitals => _vitals;

  Future<void> loadDashboard() async {
    _isLoading = true;
    notifyListeners();
    try {
      _vitals = await _repository.fetchVitals();
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }
}
