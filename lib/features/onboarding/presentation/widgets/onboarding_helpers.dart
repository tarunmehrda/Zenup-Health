import 'package:flutter/material.dart';

/// Helper widget to build asset images with rounded corners and error fallback.
Widget buildAssetImage(
  String assetPath, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  double borderRadius = 0,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      gaplessPlayback: true,
      filterQuality: FilterQuality.medium,
      errorBuilder: (context, error, stackTrace) => Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        color: const Color(0xFFF3F4F6),
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Color(0xFF9CA3AF),
            size: 24,
          ),
        ),
      ),
    ),
  );
}

/// Helper widget to build trust badges with icons and labels.
Widget buildTrustBadge(IconData icon, Color iconColor, String text) {
  return Container(
    height: 32,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(50),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: iconColor),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0D0F1A),
          ),
        ),
      ],
    ),
  );
}

/// Helper extension on AnimationController to calculate percent completion within a curve.
extension OnboardingAnimationExtension on AnimationController {
  double getCurvePercent(double start, double end) {
    if (value < start) return 0.0;
    if (value > end) return 1.0;
    return (value - start) / (end - start);
  }
}
