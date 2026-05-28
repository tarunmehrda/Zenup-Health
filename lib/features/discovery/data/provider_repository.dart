/// File: provider_repository.dart
/// Purpose: Retrieves doctor and clinic profiles for doctor discovery.
library features;

import '../../../mock_services/mock_provider_service.dart';
import '../../../mock_services/mock_data/mock_providers.dart';

class ProviderRepository {
  final MockProviderService _providerService = MockProviderService();

  Future<List<MockProvider>> getProviders({String? query}) async {
    if (query != null && query.isNotEmpty) {
      return await _providerService.searchProviders(query);
    }
    return await _providerService.fetchAllProviders();
  }

  Future<MockProvider?> getProviderById(String id) async {
    return await _providerService.getProviderById(id);
  }
}
