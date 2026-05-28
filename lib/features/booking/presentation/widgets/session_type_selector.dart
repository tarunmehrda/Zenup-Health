/// File: session_type_selector.dart
/// Purpose: Lets users choose between Video Consultation and In-Person Visit.
library features;

import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

class SessionTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String selectedType) onTypeChanged;

  const SessionTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  Widget _buildTypeItem(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String value,
  }) {
    final isSelected = selectedType == value;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTypeChanged(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.12)
                : (isDark ? AppColors.surface : AppColors.lightSurface),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? Colors.white10 : AppColors.lightBorder),
              width: isSelected ? 1.5 : 1.0,
            ),
            borderRadius: AppSpacing.borderRadiusMD,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildTypeItem(
          context,
          label: 'Video Consultation',
          icon: Icons.videocam_rounded,
          value: 'Video Consultation',
        ),
        const SizedBox(width: AppSpacing.md),
        _buildTypeItem(
          context,
          label: 'In-Person Visit',
          icon: Icons.business_rounded,
          value: 'In-Person Visit',
        ),
      ],
    );
  }
}
