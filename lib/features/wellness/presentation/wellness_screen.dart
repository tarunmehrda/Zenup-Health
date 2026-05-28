/// File: wellness_screen.dart
/// Purpose: Holds user visual charts and logs moods and sleep schedules.
library features;

import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/z_loader.dart';
import '../domain/wellness_notifier.dart';
import 'widgets/mood_selector.dart';
import 'widgets/wellness_chart.dart';

class WellnessScreen extends StatefulWidget {
  const WellnessScreen({super.key});

  @override
  State<WellnessScreen> createState() => _WellnessScreenState();
}

class _WellnessScreenState extends State<WellnessScreen> {
  final _wellnessNotifier = WellnessNotifier();

  @override
  void initState() {
    super.initState();
    _wellnessNotifier.loadWellness();
  }

  @override
  void dispose() {
    _wellnessNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundStart : AppColors.lightBackgroundStart,
      appBar: AppBar(
        title: const Text('Wellness Center'),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _wellnessNotifier,
          builder: (context, child) {
            if (_wellnessNotifier.isLoading) {
              return const ZLoader();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const WellnessChart(),
                  const SizedBox(height: AppSpacing.xl),
                  MoodSelector(
                    onMoodSelected: (mood) {
                      _wellnessNotifier.logMood(mood);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Logged your mood: $mood'),
                          backgroundColor: AppColors.accent,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Mood History',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (_wellnessNotifier.moods.isEmpty)
                    Text(
                      'No moods logged yet. Check in above!',
                      style: TextStyle(
                        color: isDark ? AppColors.textHint : AppColors.lightTextHint,
                      ),
                    )
                  else
                    ..._wellnessNotifier.moods.map((entry) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          title: Text(
                            entry.mood,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          subtitle: Text(
                            'Logged on ${entry.date.month}/${entry.date.day}/${entry.date.year}',
                            style: TextStyle(
                              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                              fontSize: 12,
                            ),
                          ),
                          trailing: const Icon(Icons.check_circle_outline_rounded, color: AppColors.accent),
                        ),
                      );
                    }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
