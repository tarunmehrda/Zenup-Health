/// File: mood_selector.dart
/// Purpose: Displays emoji chips to log patient daily mood.
library features;

import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

class MoodSelector extends StatefulWidget {
  final Function(String mood) onMoodSelected;

  const MoodSelector({super.key, required this.onMoodSelected});

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  String? _selectedMood;

  final List<Map<String, String>> _moodOptions = const [
    {'label': 'Calm', 'emoji': '😊'},
    {'label': 'Energetic', 'emoji': '⚡'},
    {'label': 'Tired', 'emoji': '😴'},
    {'label': 'Anxious', 'emoji': '😔'},
    {'label': 'Zen', 'emoji': '🧘'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How are you feeling today?',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _moodOptions.length,
            itemBuilder: (context, index) {
              final option = _moodOptions[index];
              final isSelected = _selectedMood == option['label'];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMood = option['label'];
                  });
                  widget.onMoodSelected(option['label']!);
                },
                child: Container(
                  width: 75,
                  margin: const EdgeInsets.only(right: AppSpacing.md),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(option['emoji']!, style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        option['label']!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
