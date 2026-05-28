/// File: auth_repository.dart
/// Purpose: Adapts the mock auth service for clean architecture repository interfaces.
library features;

import '../../../mock_services/mock_auth_service.dart';
import '../../../mock_services/mock_data/mock_users.dart';

class AuthRepository {
  final MockAuthService _authService;

  AuthRepository(this._authService);

  MockUser? get currentUser => _authService.currentUser;

  bool get isAuthenticated => _authService.isAuthenticated;

  Future<MockUser> signIn(String email, String password) async {
    return await _authService.login(email, password);
  }

  Future<MockUser> signUp(String name, String email, String password) async {
    return await _authService.signUp(name, email, password);
  }

  Future<void> signOut() async {
    await _authService.logout();
  }
}
