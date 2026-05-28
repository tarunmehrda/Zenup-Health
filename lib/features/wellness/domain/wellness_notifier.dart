/// File: wellness_notifier.dart
/// Purpose: Manages state trackers for wellness charts and mood selectors.
library features;

import 'package:flutter/material.dart';
import '../data/wellness_repository.dart';

class WellnessNotifier extends ChangeNotifier {
  final WellnessRepository _repository = WellnessRepository();
  bool _isLoading = false;
  List<MoodEntry> _moods = [];

  bool get isLoading => _isLoading;
  List<MoodEntry> get moods => _moods;

  Future<void> loadWellness() async {
    _isLoading = true;
    notifyListeners();
    try {
      _moods = await _repository.fetchMoodHistory();
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logMood(String mood) async {
    try {
      await _repository.saveMood(mood);
      await loadWellness();
    } catch (_) {}
  }
}
