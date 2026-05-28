/// File: filter_chips_widget.dart
/// Purpose: Horizontally scrollable list of specialty filter chips.
library features;

import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

class FilterChipsWidget extends StatefulWidget {
  final List<String> filters;
  final Function(String selectedFilter) onFilterChanged;

  const FilterChipsWidget({
    super.key,
    required this.filters,
    required this.onFilterChanged,
  });

  @override
  State<FilterChipsWidget> createState() => _FilterChipsWidgetState();
}

class _FilterChipsWidgetState extends State<FilterChipsWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.filters.length,
        itemBuilder: (context, index) {
          final filter = widget.filters[index];
          final isSelected = _selectedIndex == index;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: ChoiceChip(
              label: Text(filter),
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
                  setState(() {
                    _selectedIndex = index;
                  });
                  widget.onFilterChanged(filter);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
