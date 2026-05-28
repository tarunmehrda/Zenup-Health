/// File: message_bubble.dart
/// Purpose: Renders a text bubble for a single chat message.
library features;

import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.primary
              : (isDark ? AppColors.surface : AppColors.lightSurface),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppSpacing.radiusLG),
            topRight: const Radius.circular(AppSpacing.radiusLG),
            bottomLeft: Radius.circular(isMe ? AppSpacing.radiusLG : 0),
            bottomRight: Radius.circular(isMe ? 0 : AppSpacing.radiusLG),
          ),
          border: isMe
              ? null
              : Border.all(
                  color: isDark ? Colors.white10 : AppColors.lightBorder,
                ),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isMe
                    ? Colors.white
                    : (isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
                fontSize: 14.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: isMe
                    ? Colors.white60
                    : (isDark ? AppColors.textHint : AppColors.lightTextHint),
                fontSize: 9.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
