/// File: messaging_screen.dart
/// Purpose: Displays chat list history and message log screens.
library features;

import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/z_loader.dart';
import '../domain/messaging_notifier.dart';
import 'widgets/message_bubble.dart';
import 'widgets/chat_input_bar.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final _messagingNotifier = MessagingNotifier();

  @override
  void initState() {
    super.initState();
    _messagingNotifier.loadMessages();
  }

  @override
  void dispose() {
    _messagingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundStart : AppColors.lightBackgroundStart,
      appBar: AppBar(
        title: const Text('Dr. Sarah Jenkins'),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListenableBuilder(
                listenable: _messagingNotifier,
                builder: (context, child) {
                  if (_messagingNotifier.isLoading) {
                    return const ZLoader();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: _messagingNotifier.messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messagingNotifier.messages[index];
                      final isMe = msg.senderId == 'user';
                      return MessageBubble(
                        text: msg.text,
                        isMe: isMe,
                        time: '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                      );
                    },
                  );
                },
              ),
            ),
            ChatInputBar(
              onSend: (text) {
                _messagingNotifier.send(text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
