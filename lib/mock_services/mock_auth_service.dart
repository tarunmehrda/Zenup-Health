/// File: mock_auth_service.dart
/// Purpose: Simulates remote authentication service for testing signup and login processes.
library mock_services;

import 'dart:async';
import 'mock_data/mock_users.dart';

class MockAuthService {
  MockUser? _currentUser;

  MockAuthService() {
    // Default logged in user for mock setup
    _currentUser = mockUsersList.first;
  }

  MockUser? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  Future<MockUser> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate remote call
    if (email.trim().isEmpty || password.isEmpty) {
      throw Exception('Credentials cannot be empty');
    }
    // Set mock user
    _currentUser = MockUser(
      id: 'usr-auto',
      email: email,
      name: email.split('@').first.toUpperCase(),
      wellnessScore: '70%',
    );
    return _currentUser!;
  }

  Future<MockUser> signUp(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
      throw Exception('All fields are required');
    }
    _currentUser = MockUser(
      id: 'usr-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
      wellnessScore: '80%',
    );
    return _currentUser!;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }
}
