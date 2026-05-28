/// File: auth_notifier.dart
/// Purpose: Holds current session state and drives user authentication events.
library features;

import 'package:flutter/material.dart';
import '../data/auth_repository.dart';
import '../../../mock_services/mock_auth_service.dart';
import '../../../mock_services/mock_data/mock_users.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository(MockAuthService());
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  MockUser? get user => _repository.currentUser;
  bool get isAuthenticated => _repository.isAuthenticated;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.signIn(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.signUp(name, email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await _repository.signOut();
    _isLoading = false;
    notifyListeners();
  }
}
