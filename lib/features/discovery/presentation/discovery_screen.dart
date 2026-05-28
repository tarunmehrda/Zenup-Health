/// File: discovery_screen.dart
/// Purpose: Lists clinics and doctors with search bars and specialty filters.
library features;

import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/router/app_routes.dart';
import '../../../shared/widgets/z_loader.dart';
import '../../../shared/widgets/z_empty_state.dart';
import '../domain/discovery_notifier.dart';
import 'widgets/provider_card.dart';
import 'widgets/filter_chips_widget.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final _searchController = TextEditingController();
  final _discoveryNotifier = DiscoveryNotifier();

  @override
  void initState() {
    super.initState();
    _discoveryNotifier.loadAll();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _discoveryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(
            'Find Medical Support',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Search for clinicians, cardiologists, and counselors.',
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _searchController,
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Search doctors, specialties...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear_rounded),
                onPressed: () {
                  _searchController.clear();
                  _discoveryNotifier.search('');
                },
              ),
              filled: true,
              fillColor: isDark ? AppColors.surface : AppColors.lightSurface,
              border: OutlineInputBorder(
                borderRadius: AppSpacing.borderRadiusMD,
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (val) {
              _discoveryNotifier.search(val);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          FilterChipsWidget(
            filters: const ['All', 'Cardiologist', 'Mental Health', 'Nutritionist'],
            onFilterChanged: (filter) {
              final query = filter == 'All' ? '' : filter;
              _discoveryNotifier.search(query);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListenableBuilder(
              listenable: _discoveryNotifier,
              builder: (context, child) {
                if (_discoveryNotifier.isLoading) {
                  return const ZLoader();
                }

                if (_discoveryNotifier.providers.isEmpty) {
                  return const ZEmptyState(
                    title: 'No practitioners found',
                    description: 'Try adjusting your search filters or queries.',
                    icon: Icons.search_off_rounded,
                  );
                }

                return ListView.separated(
                  itemCount: _discoveryNotifier.providers.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final provider = _discoveryNotifier.providers[index];
                    return ProviderCard(
                      name: provider.name,
                      specialty: provider.specialty,
                      rating: provider.rating,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.providerProfile,
                          arguments: provider.id,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
