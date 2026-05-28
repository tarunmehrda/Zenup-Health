/// File: messaging_notifier.dart
/// Purpose: Manages messaging states and handles incoming/outgoing text message triggers.
library features;

import 'package:flutter/material.dart';
import '../data/messaging_repository.dart';

class MessagingNotifier extends ChangeNotifier {
  final MessagingRepository _repository = MessagingRepository();
  bool _isLoading = false;
  List<MockMessage> _messages = [];

  bool get isLoading => _isLoading;
  List<MockMessage> get messages => _messages;

  Future<void> loadMessages() async {
    _isLoading = true;
    notifyListeners();

    try {
      _messages = await _repository.fetchMessages();
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  Future<void> send(String text) async {
    if (text.trim().isEmpty) return;
    try {
      final msg = await _repository.sendMessage(text);
      _messages = [..._messages, msg];
      notifyListeners();
    } catch (_) {}
  }
}
