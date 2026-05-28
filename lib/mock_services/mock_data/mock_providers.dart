/// File: mock_providers.dart
/// Purpose: Holds mock lists of healthcare and wellness providers.
library mock_services;

class MockProvider {
  final String id;
  final String name;
  final String specialty;
  final String rating;
  final String imageUrl;
  final String bio;
  final List<String> availableSlots;

  const MockProvider({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.imageUrl,
    required this.bio,
    required this.availableSlots,
  });
}

const List<MockProvider> mockProvidersList = [
  MockProvider(
    id: 'prov-001',
    name: 'Dr. Sarah Jenkins',
    specialty: 'Cardiologist',
    rating: '4.9',
    imageUrl: 'lib/assets/zenup-icon.png',
    bio: 'Specialist in preventive cardiology and holistic wellness plans with over 12 years of experience.',
    availableSlots: ['09:00 AM', '10:30 AM', '02:00 PM', '04:30 PM'],
  ),
  MockProvider(
    id: 'prov-002',
    name: 'Dr. Marcus Vance',
    specialty: 'Mental Health Counselor',
    rating: '4.8',
    imageUrl: 'lib/assets/zenup-icon.png',
    bio: 'Dedicated to helping patients achieve mental clarity, stress reduction, and optimal emotional resilience.',
    availableSlots: ['11:00 AM', '01:00 PM', '03:00 PM', '05:00 PM'],
  ),
  MockProvider(
    id: 'prov-003',
    name: 'Dr. Emily Stone',
    specialty: 'Nutritionist',
    rating: '4.7',
    imageUrl: 'lib/assets/zenup-icon.png',
    bio: 'Empowering individuals to transition to mindful, clean eating habits tailored to their genetic profiles.',
    availableSlots: ['08:30 AM', '10:00 AM', '01:30 PM', '03:30 PM'],
  ),
];
