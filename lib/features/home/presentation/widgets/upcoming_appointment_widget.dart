/// File: upcoming_appointment_widget.dart
/// Purpose: Renders the next upcoming medical appointment on the home screen.
library features;

import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/z_card.dart';
import '../../../../shared/widgets/z_badge.dart';

class UpcomingAppointmentWidget extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String date;
  final String time;
  final VoidCallback? onTap;

  const UpcomingAppointmentWidget({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ZCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ZBadge(label: 'Upcoming', type: ZBadgeType.info),
              Icon(
                Icons.calendar_today_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            doctorName,
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
        ],
      ),
    );
  }
}
