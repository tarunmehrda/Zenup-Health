/// File: mock_provider_service.dart
/// Purpose: Simulates remote retrieval of wellness and medical providers.
library mock_services;

import 'dart:async';
import 'mock_data/mock_providers.dart';

class MockProviderService {
  Future<List<MockProvider>> fetchAllProviders() async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate latency
    return mockProvidersList;
  }

  Future<List<MockProvider>> searchProviders(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (query.trim().isEmpty) return mockProvidersList;
    return mockProvidersList.where((p) {
      return p.name.toLowerCase().contains(query.toLowerCase()) ||
          p.specialty.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Future<MockProvider?> getProviderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return mockProvidersList.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
