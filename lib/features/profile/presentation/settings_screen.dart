/// File: settings_screen.dart
/// Purpose: Holds user customization options (like theme settings and accounts logout).
library features;

import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/router/app_routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundStart : AppColors.lightBackgroundStart,
      appBar: AppBar(
        title: const Text('Settings'),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'App Preferences',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SwitchListTile(
              title: Text(
                'Push Notifications',
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                ),
              ),
              subtitle: const Text('Receive wellness tips and updates'),
              value: _notificationsEnabled,
              activeColor: AppColors.accent,
              onChanged: (val) {
                setState(() {
                  _notificationsEnabled = val;
                });
              },
            ),
            const Divider(color: Colors.white10),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Account & Security',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ListTile(
              title: Text(
                'Change Password',
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                ),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                'Log Out',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.logout_rounded, color: AppColors.error),
              onTap: () {
                // Navigate back to login
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.authLogin,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
