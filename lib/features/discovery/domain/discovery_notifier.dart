/// File: discovery_notifier.dart
/// Purpose: Manages state for the doctor discovery screen, tracking searches and filters.
library features;

import 'package:flutter/material.dart';
import '../data/provider_repository.dart';
import '../../../mock_services/mock_data/mock_providers.dart';

class DiscoveryNotifier extends ChangeNotifier {
  final ProviderRepository _repository = ProviderRepository();
  bool _isLoading = false;
  List<MockProvider> _providers = [];
  String _searchQuery = '';

  bool get isLoading => _isLoading;
  List<MockProvider> get providers => _providers;
  String get searchQuery => _searchQuery;

  Future<void> search(String query) async {
    _searchQuery = query;
    _isLoading = true;
    notifyListeners();

    try {
      _providers = await _repository.getProviders(query: query);
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadAll() async {
    await search('');
  }
}
