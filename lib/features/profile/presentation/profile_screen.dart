/// File: profile_screen.dart
/// Purpose: Displays user bio metrics, profile avatars, and settings triggers.
library features;

import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/router/app_routes.dart';
import '../../../shared/widgets/z_avatar.dart';
import '../../../shared/widgets/z_card.dart';
import '../../../shared/widgets/z_loader.dart';
import '../domain/profile_notifier.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileNotifier = ProfileNotifier();

  @override
  void initState() {
    super.initState();
    _profileNotifier.loadProfile();
  }

  @override
  void dispose() {
    _profileNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: _profileNotifier,
      builder: (context, child) {
        if (_profileNotifier.isLoading || _profileNotifier.user == null) {
          return const ZLoader();
        }

        final u = _profileNotifier.user!;

        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.settings);
                    },
                  ),
                ],
              ),
              ZAvatar(name: u.name, radius: 45, showBorder: true),
              const SizedBox(height: AppSpacing.md),
              Text(
                u.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                    ),
              ),
              Text(
                u.email,
                style: TextStyle(
                  color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ZCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          u.wellnessScore,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text('Wellness Index', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                      child: VerticalDivider(color: Colors.white10),
                    ),
                    const Column(
                      children: [
                        Text(
                          'Active',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('Plan Status', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ZCard(
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.appointments);
                },
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: AppSpacing.borderRadiusSM,
                    ),
                    child: const Icon(Icons.calendar_month_rounded, color: AppColors.primary),
                  ),
                  title: Text(
                    'My Appointments',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
