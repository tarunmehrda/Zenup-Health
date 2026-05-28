/// File: connectivity_service.dart
/// Purpose: Simulates network internet connection status tracking.
library core;

import 'dart:async';
import '../utils/logger.dart';

class ConnectivityService {
  final _controller = StreamController<bool>.broadcast();
  bool _isConnected = true;

  ConnectivityService() {
    Logger.info('ConnectivityService Initialized');
  }

  Stream<bool> get onConnectivityChanged => _controller.stream;

  bool get isConnected => _isConnected;

  void toggleConnectionState() {
    _isConnected = !_isConnected;
    _controller.add(_isConnected);
    Logger.warning('Network Connection state simulated changed to: ${_isConnected ? "CONNECTED" : "OFFLINE"}');
  }

  void dispose() {
    _controller.close();
  }
}
