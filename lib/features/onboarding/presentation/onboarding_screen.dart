/// File: onboarding_screen.dart
/// Purpose: High-fidelity 5-slide onboarding tour featuring real Zenup content,
/// real therapist profiles, animated stats, auto-rotating testimonials, and spring physics page indicators.
/// Design style: White background layout, completely scroll-safe.
library features;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../app/router/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/constants/app_constants.dart';
import 'widgets/slide_one.dart';
import 'widgets/slide_two.dart';
import 'widgets/slide_three.dart';
import 'widgets/slide_four.dart';
import 'widgets/slide_five.dart';

const List<String> _onboardingAssets = [
  'lib/assets/onboarding/onboarding_hero.png',
  'lib/assets/onboarding/service_anxiety.png',
  'lib/assets/onboarding/service_depression.png',
  'lib/assets/onboarding/service_adhd.png',
  'lib/assets/onboarding/service_anger.png',
  'lib/assets/onboarding/service_esteem.png',
  'lib/assets/onboarding/service_relationship.png',
  'lib/assets/onboarding/therapist_bhoomi.jpg',
  'lib/assets/onboarding/therapist_atharva.png',
  'lib/assets/onboarding/therapist_sharvari.jpg',
  'lib/assets/onboarding/therapist_maithili.jpeg',
  'lib/assets/onboarding/therapist_pavitra.jpg',
  'lib/assets/onboarding/therapist_tanya.jpeg',
  'lib/assets/onboarding/therapist_alia.png',
  'lib/assets/onboarding/therapist_mary.jpeg',
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  double _currentPage = 0.0;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _precacheOnboardingImages();
      }
    });
  }

  void _onPageScroll() {
    if (mounted) {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
        _currentIndex = _currentPage.round();
      });
    }
  }

  void _precacheOnboardingImages() {
    for (final asset in _onboardingAssets) {
      unawaited(precacheImage(AssetImage(asset), context).catchError((_) {}));
    }
  }

  Future<void> _completeOnboarding() async {
    final box = Hive.box('settings');
    await box.put('onboarding_complete', true);
    if (mounted) {
      context.go(AppRoutes.serviceSelection);
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageScroll);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // PageView container
            PageView.builder(
              controller: _pageController,
              itemCount: 5,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final pageOffset = _currentPage - index;
                switch (index) {
                  case 0:
                    return SlideOne(
                      isActive: _currentIndex == 0,
                      pageOffset: pageOffset,
                      screenWidth: screenWidth,
                    );
                  case 1:
                    return SlideTwo(
                      isActive: _currentIndex == 1,
                      pageOffset: pageOffset,
                      screenWidth: screenWidth,
                    );
                  case 2:
                    return SlideThree(
                      isActive: _currentIndex == 2,
                      pageOffset: pageOffset,
                      screenWidth: screenWidth,
                    );
                  case 3:
                    return SlideFour(
                      isActive: _currentIndex == 3,
                      pageOffset: pageOffset,
                      screenWidth: screenWidth,
                    );
                  case 4:
                  default:
                    return SlideFive(
                      isActive: _currentIndex == 4,
                      pageOffset: pageOffset,
                      screenWidth: screenWidth,
                      onGetStarted: _completeOnboarding,
                    );
                }
              },
            ),

            // Top-right Skip Button
            if (_currentIndex != 4)
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: _completeOnboarding,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                ),
              ),

            // Page Indicator & Next Button
            if (_currentIndex != 4)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.0),
                        Colors.white.withValues(alpha: 0.95),
                        Colors.white,
                      ],
                      stops: const [0.0, 0.35, 1.0],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Page dots — left-aligned
                      _buildPageIndicator(),
                      // Next button — right-aligned
                      _buildNextButton(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _nextPage() {
    if (_currentIndex < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Widget _buildNextButton() {
    return _NextButton(onTap: _nextPage);
  }

  Widget _buildPageIndicator() {
    const int count = 5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == _currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20.0 : 6.0,
          height: 6.0,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFF47B20) : const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

// ── Stateful Next Button with press animation ──
class _NextButton extends StatefulWidget {
  final VoidCallback onTap;
  const _NextButton({required this.onTap});

  @override
  State<_NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<_NextButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.94,
    ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) {
        _pressController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: const Color(0xFFF47B20),
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF47B20).withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
