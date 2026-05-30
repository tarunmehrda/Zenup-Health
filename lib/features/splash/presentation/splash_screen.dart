/// File: splash_screen.dart
/// Purpose: Premium splash screen for Zenup with organic logo animation,
/// floating effect, brand identity, and progress bar.
/// Matches the HTML design: circular logo with organic rock + slow float,
/// "Zenup" title + "Productive Calm" subtitle, thin progress bar at bottom.
/// No particles/bubbles.
library features;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/router/app_routes.dart';
import '../../../core/constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Organic rocking animation (rotation ±6°, 4s loop) ──
  late AnimationController _rockController;
  late Animation<double> _rockAngle;

  // ── Slow floating animation (translateY -12px, 6s loop) ──
  late AnimationController _floatController;
  late Animation<double> _floatOffset;

  // ── Progress bar animation (0→100%, 2.5s) ──
  late AnimationController _progressController;

  // ── Fade-in for logo ──
  late AnimationController _fadeController;
  late Animation<double> _logoOpacity;
  bool _didPrecache = false;

  @override
  void initState() {
    super.initState();

    // Status bar: light background with dark icons
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    _initAnimations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrecache) return;
    _didPrecache = true;

    // Pre-cache critical heavy local assets during splash screen idle time
    const criticalAssets = [
      'assets/onboarding/onboarding_hero.png',
      'assets/booking/booking_individual.png',
      'assets/booking/booking_couples.png',
      'assets/booking/booking_psychiatric.png',
    ];

    for (final asset in criticalAssets) {
      precacheImage(
        AssetImage(asset),
        context,
      ).catchError((_) {});
    }
  }

  void _initAnimations() {
    // ── Organic Rock: ±6° rotation, 4s, infinite ──
    _rockController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    _rockAngle = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 6.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 6.0, end: -6.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -6.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
    ]).animate(_rockController);

    // ── Slow Float: -12px vertical, 6s, infinite ──
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat(reverse: true);

    _floatOffset = Tween<double>(begin: 0.0, end: -12.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // ── Progress bar: fills over 2.5s, then navigate ──
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );



    // ── Fade in sequence: logo → title → subtitle ──
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );



    // Start animations
    _fadeController.forward();

    // Delay progress bar slightly for polish
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _progressController.forward().then((_) => _navigateNext());
      }
    });
  }

  void _navigateNext() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
  }

  @override
  void dispose() {
    _rockController.dispose();
    _floatController.dispose();
    _progressController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: AnimatedBuilder(
          animation: Listenable.merge([
            _rockController,
            _floatController,
            _progressController,
            _fadeController,
          ]),
          builder: (context, _) {
            return Stack(
              children: [
                // ── Main content: centered logo + brand ──
                Center(
                  child: Transform.translate(
                    offset: Offset(0, _floatOffset.value),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Opacity(
                          opacity: _logoOpacity.value,
                          child: Transform.rotate(
                            angle: _rockAngle.value * (math.pi / 180),
                            child: Image.asset(
                              AppConstants.zenupIconPng,
                              width: 160,
                              height: 160,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.spa_rounded,
                                  color: AppColors.primary,
                                  size: 160,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Bottom progress loader ──
                Positioned(
                  bottom: 48,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Opacity(
                      opacity: _logoOpacity.value,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: SizedBox(
                          height: 2,
                          width: 120,
                          child: LinearProgressIndicator(
                            value: _progressController.value,
                            backgroundColor: const Color(0xFFE5E7EB),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
