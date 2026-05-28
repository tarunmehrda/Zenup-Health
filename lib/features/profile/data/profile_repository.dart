/// File: profile_repository.dart
/// Purpose: Retrieves and saves user settings and account detail records.
library features;

import '../../../mock_services/mock_data/mock_users.dart';

class ProfileRepository {
  Future<MockUser> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return mockUsersList.first;
  }
}
