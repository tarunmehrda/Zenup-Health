/// File: date_slot_picker.dart
/// Purpose: Displays date slots and time selections to reserve appointments.
library features;

import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

class DateSlotPicker extends StatelessWidget {
  final List<String> availableTimes;
  final String selectedDate;
  final String selectedTime;
  final Function(String date, String time) onSlotChanged;

  const DateSlotPicker({
    super.key,
    required this.availableTimes,
    required this.selectedDate,
    required this.selectedTime,
    required this.onSlotChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Date',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String>(
          value: selectedDate,
          dropdownColor: isDark ? AppColors.surface : AppColors.lightSurface,
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? AppColors.surface : AppColors.lightSurface,
            enabledBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusMD,
              borderSide: BorderSide(
                color: isDark ? Colors.white10 : AppColors.lightBorder,
              ),
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'June 04, 2026', child: Text('Thursday, June 04, 2026')),
            DropdownMenuItem(value: 'June 05, 2026', child: Text('Friday, June 05, 2026')),
            DropdownMenuItem(value: 'June 06, 2026', child: Text('Saturday, June 06, 2026')),
          ],
          onChanged: (val) {
            if (val != null) {
              onSlotChanged(val, selectedTime);
            }
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Select Time',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: availableTimes.map((time) {
            final isSelected = selectedTime == time;
            return ChoiceChip(
              label: Text(time),
              selected: isSelected,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
              ),
              backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
              onSelected: (selected) {
                if (selected) {
                  onSlotChanged(selectedDate, time);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
