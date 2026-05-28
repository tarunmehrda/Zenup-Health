/// File: messaging_repository.dart
/// Purpose: Simulates fetching and sending text messages inside conversations.
library features;

class MockMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;

  const MockMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });
}

class MessagingRepository {
  final List<MockMessage> _messages = [
    MockMessage(
      id: 'msg-01',
      senderId: 'doctor',
      text: 'Hello! How are you feeling today? Did you log your vitals?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    MockMessage(
      id: 'msg-02',
      senderId: 'user',
      text: 'Hi Dr. Jenkins, yes I logged them. Sleep has improved!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    MockMessage(
      id: 'msg-03',
      senderId: 'doctor',
      text: 'Great to hear! I will review the charts before our call next week.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
  ];

  Future<List<MockMessage>> fetchMessages() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _messages;
  }

  Future<MockMessage> sendMessage(String text) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final msg = MockMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'user',
      text: text,
      timestamp: DateTime.now(),
    );
    _messages.add(msg);
    return msg;
  }
}
