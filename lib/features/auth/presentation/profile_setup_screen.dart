/// File: profile_setup_screen.dart
/// Purpose: Guides new users to complete their health profiles and set wellness goals.
library features;

import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/router/app_routes.dart';
import '../../../shared/widgets/z_button.dart';
import '../../../shared/widgets/z_input_field.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String _selectedGoal = 'Track Vitals';

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _onComplete() async {
    // Simulate updating user profile parameters
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Setting up your custom wellness plan...'),
        backgroundColor: AppColors.primary,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundStart : AppColors.lightBackgroundStart,
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Let\'s customize Zenup for you',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Enter your details so we can tailor the metrics and insights to your body.',
                style: TextStyle(
                  color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ZInputField(
                labelText: 'Age',
                hintText: 'e.g. 28',
                controller: _ageController,
                prefixIcon: Icons.calendar_month_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.md),
              ZInputField(
                labelText: 'Weight (kg)',
                hintText: 'e.g. 70',
                controller: _weightController,
                prefixIcon: Icons.monitor_weight_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.md),
              ZInputField(
                labelText: 'Height (cm)',
                hintText: 'e.g. 175',
                controller: _heightController,
                prefixIcon: Icons.height_rounded,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Your Primary Health Goal',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                value: _selectedGoal,
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
                  DropdownMenuItem(value: 'Track Vitals', child: Text('Track Daily Vitals')),
                  DropdownMenuItem(value: 'Mental Clarity', child: Text('Reduce Stress & Improve Sleep')),
                  DropdownMenuItem(value: 'Telehealth Consultations', child: Text('Virtual Medical Support')),
                  DropdownMenuItem(value: 'Diet & Nutrition', child: Text('Mindful Nutrition Plans')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedGoal = val;
                    });
                  }
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
              ZButton(
                label: 'Save & Continue',
                onPressed: _onComplete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
