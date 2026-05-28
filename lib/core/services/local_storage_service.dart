/// File: local_storage_service.dart
/// Purpose: Simulates key-value local storage for user preferences and session caching.
library core;

import '../utils/logger.dart';

class LocalStorageService {
  final Map<String, dynamic> _mockStorage = {};

  LocalStorageService() {
    Logger.info('LocalStorageService Initialized');
  }

  Future<void> write(String key, dynamic value) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate async IO
    _mockStorage[key] = value;
    Logger.info('LocalStorage: Wrote key [$key] with value [$value]');
  }

  Future<dynamic> read(String key) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final val = _mockStorage[key];
    Logger.info('LocalStorage: Read key [$key] returning [$val]');
    return val;
  }

  Future<void> remove(String key) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _mockStorage.remove(key);
    Logger.info('LocalStorage: Removed key [$key]');
  }

  Future<void> clear() async {
    await Future.delayed(const Duration(milliseconds: 50));
    _mockStorage.clear();
    Logger.info('LocalStorage: Cleared all key/values');
  }
}
