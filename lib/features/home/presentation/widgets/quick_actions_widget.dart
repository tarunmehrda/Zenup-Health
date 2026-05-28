/// File: quick_actions_widget.dart
/// Purpose: Displays horizontal list of shortcuts for booking, messaging, and health logs.
library features;

import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

class QuickActionsWidget extends StatelessWidget {
  final Function(String action)? onActionSelected;

  const QuickActionsWidget({super.key, this.onActionSelected});

  Widget _buildActionItem(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: AppSpacing.borderRadiusMD,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionItem(
          context,
          label: 'Book Consult',
          icon: Icons.calendar_month_rounded,
          color: AppColors.primary,
          onTap: () => onActionSelected?.call('book'),
        ),
        _buildActionItem(
          context,
          label: 'Chat Doctor',
          icon: Icons.chat_bubble_outline_rounded,
          color: AppColors.accent,
          onTap: () => onActionSelected?.call('chat'),
        ),
        _buildActionItem(
          context,
          label: 'Wellness Log',
          icon: Icons.spa_rounded,
          color: Colors.orangeAccent,
          onTap: () => onActionSelected?.call('wellness'),
        ),
        _buildActionItem(
          context,
          label: 'Find Clinic',
          icon: Icons.explore_outlined,
          color: Colors.blueAccent,
          onTap: () => onActionSelected?.call('discovery'),
        ),
      ],
    );
  }
}
