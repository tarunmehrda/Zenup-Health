/// File: profile_notifier.dart
/// Purpose: Manages state values for user profile displays and settings configuration.
library features;

import 'package:flutter/material.dart';
import '../data/profile_repository.dart';
import '../../../mock_services/mock_data/mock_users.dart';

class ProfileNotifier extends ChangeNotifier {
  final ProfileRepository _repository = ProfileRepository();
  bool _isLoading = false;
  MockUser? _user;

  bool get isLoading => _isLoading;
  MockUser? get user => _user;

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _repository.getUserProfile();
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }
}
