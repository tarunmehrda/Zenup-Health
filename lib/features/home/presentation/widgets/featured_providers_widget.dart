/// File: featured_providers_widget.dart
/// Purpose: Shows a horizontal list of featured wellness doctors.
library features;

import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/z_avatar.dart';
import '../../../../mock_services/mock_data/mock_providers.dart';

class FeaturedProvidersWidget extends StatelessWidget {
  final Function(MockProvider provider)? onProviderSelected;

  const FeaturedProvidersWidget({super.key, this.onProviderSelected});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Practitioners',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: mockProvidersList.length,
            itemBuilder: (context, index) {
              final provider = mockProvidersList[index];
              return GestureDetector(
                onTap: () => onProviderSelected?.call(provider),
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surface : AppColors.lightSurface,
                    borderRadius: AppSpacing.borderRadiusMD,
                    border: Border.all(
                      color: isDark ? Colors.white10 : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ZAvatar(name: provider.name, radius: 20),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        provider.name.split(' ').last,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        provider.specialty,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                          fontSize: 11,
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
