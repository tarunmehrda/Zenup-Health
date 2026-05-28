/// File: z_badge.dart
/// Purpose: Renders labels for state and statuses.
library shared;

import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

enum ZBadgeType { info, success, warning, error }

class ZBadge extends StatelessWidget {
  final String label;
  final ZBadgeType type;

  const ZBadge({
    super.key,
    required this.label,
    this.type = ZBadgeType.info,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (type) {
      case ZBadgeType.success:
        color = AppColors.success;
        break;
      case ZBadgeType.warning:
        color = AppColors.warning;
        break;
      case ZBadgeType.error:
        color = AppColors.error;
        break;
      case ZBadgeType.info:
        color = AppColors.info;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
