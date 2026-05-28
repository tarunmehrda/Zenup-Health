/// File: z_avatar.dart
/// Purpose: Displays user profiles or initials fallback.
library shared;

import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class ZAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double radius;
  final bool showBorder;

  const ZAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.radius = 24,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().split(' ').map((e) => e[0].toUpperCase()).take(2).join();

    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
      foregroundImage: imageUrl != null && imageUrl!.startsWith('assets/')
          ? AssetImage(imageUrl!) as ImageProvider
          : imageUrl != null
              ? NetworkImage(imageUrl!)
              : null,
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if (showBorder) {
      return Container(
        padding: const EdgeInsets.all(2.5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.accent],
          ),
        ),
        child: avatar,
      );
    }

    return avatar;
  }
}
