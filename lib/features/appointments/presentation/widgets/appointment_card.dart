/// File: appointment_card.dart
/// Purpose: Displays single scheduled appointment details in schedule screens.
library features;

import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/z_card.dart';
import '../../../../shared/widgets/z_badge.dart';

class AppointmentCard extends StatelessWidget {
  final String providerName;
  final String specialty;
  final String date;
  final String time;
  final String type;
  final String status;
  final VoidCallback? onCancel;

  const AppointmentCard({
    super.key,
    required this.providerName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.type,
    required this.status,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ZBadgeType badgeType;
    if (status == 'Upcoming') {
      badgeType = ZBadgeType.info;
    } else if (status == 'Completed') {
      badgeType = ZBadgeType.success;
    } else {
      badgeType = ZBadgeType.error;
    }

    return ZCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                type,
                style: TextStyle(
                  color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ZBadge(label: status, type: badgeType),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            providerName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            specialty,
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: Colors.white12),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 16,
                    color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '$date at $time',
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              if (status == 'Upcoming' && onCancel != null)
                TextButton(
                  onPressed: onCancel,
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                  child: const Text('Cancel'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
