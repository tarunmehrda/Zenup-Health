/// File: logger.dart
/// Purpose: Provides formatted debug logging outputs for development.
library core;

import 'package:flutter/foundation.dart';

class Logger {
  Logger._();

  static void info(String message) {
    if (kDebugMode) {
      print('💡 [INFO] ${DateTime.now().toIso8601String()}: $message');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('🚨 [ERROR] ${DateTime.now().toIso8601String()}: $message');
      if (error != null) print('Details: $error');
      if (stackTrace != null) print(stackTrace);
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      print('⚠️ [WARNING] ${DateTime.now().toIso8601String()}: $message');
    }
  }
}
