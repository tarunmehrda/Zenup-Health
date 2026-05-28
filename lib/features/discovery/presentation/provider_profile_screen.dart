/// File: provider_profile_screen.dart
/// Purpose: Displays bio, slots, ratings, and booking button for a specific wellness doctor.
library features;

import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/router/app_routes.dart';
import '../../../shared/widgets/z_avatar.dart';
import '../../../shared/widgets/z_button.dart';
import '../../../shared/widgets/z_loader.dart';
import '../../../mock_services/mock_data/mock_providers.dart';
import '../data/provider_repository.dart';

class ProviderProfileScreen extends StatefulWidget {
  final String providerId;

  const ProviderProfileScreen({super.key, required this.providerId});

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  final ProviderRepository _repository = ProviderRepository();
  MockProvider? _provider;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProvider();
  }

  void _loadProvider() async {
    final p = await _repository.getProviderById(widget.providerId);
    setState(() {
      _provider = p;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_loading) {
      return const Scaffold(body: ZLoader());
    }

    if (_provider == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Practitioner not found.')),
      );
    }

    final p = _provider!;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundStart : AppColors.lightBackgroundStart,
      appBar: AppBar(
        title: Text(p.name),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    ZAvatar(name: p.name, radius: 50, showBorder: true),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      p.name,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      p.specialty,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${p.rating} / 5.0 Rating',
                          style: TextStyle(
                            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Biography',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                            ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      p.bio,
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Available Hours Today',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                            ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: p.availableSlots.map((slot) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surface : AppColors.lightSurface,
                            borderRadius: AppSpacing.borderRadiusSM,
                            border: Border.all(
                              color: isDark ? Colors.white10 : AppColors.lightBorder,
                            ),
                          ),
                          child: Text(
                            slot,
                            style: TextStyle(
                              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SizedBox(
                width: double.infinity,
                child: ZButton(
                  label: 'Book Consultation',
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.bookingFlow,
                      arguments: p,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
