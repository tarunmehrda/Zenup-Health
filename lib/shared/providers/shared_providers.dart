/// File: shared_providers.dart
/// Purpose: Simulates a service locator / dependency container for shared application services.
library shared;

import '../../core/services/local_storage_service.dart';
import '../../core/services/connectivity_service.dart';

class SharedProviders {
  SharedProviders._();

  static final LocalStorageService localStorage = LocalStorageService();
  static final ConnectivityService connectivity = ConnectivityService();
}
