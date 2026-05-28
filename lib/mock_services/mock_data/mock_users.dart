/// File: mock_users.dart
/// Purpose: Holds mock user data objects for development environment.
library mock_services;

class MockUser {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String wellnessScore;

  const MockUser({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    required this.wellnessScore,
  });
}

const List<MockUser> mockUsersList = [
  MockUser(
    id: 'usr-001',
    email: 'zenmaster@zenup.health',
    name: 'Zen Master',
    wellnessScore: '78%',
  ),
  MockUser(
    id: 'usr-002',
    email: 'john.doe@gmail.com',
    name: 'John Doe',
    wellnessScore: '65%',
  ),
];
