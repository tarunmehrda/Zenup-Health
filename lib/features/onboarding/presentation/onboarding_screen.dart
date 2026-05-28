/// File: onboarding_screen.dart
/// Purpose: High-fidelity 5-slide onboarding tour featuring real Zenup content,
/// real therapist profiles, animated stats, auto-rotating testimonials, and spring physics page indicators.
/// Design style: White background layout, completely scroll-safe.
library features;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive/hive.dart';
import '../../../app/router/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/constants/app_constants.dart';

const List<String> _onboardingImageUrls = [
  'https://res.cloudinary.com/dalzfjt8f/image/upload/v1775200162/Gemini_Generated_Image_9ile2d9ile2d9ile_jphxwo.png',
  'https://zenuphealth.com/wp-content/uploads/2025/11/Gemini_Generated_Image_fd9kjafd9kjafd9k-1-scaled.png',
  'https://zenuphealth.com/wp-content/uploads/2025/11/Gemini_Generated_Image_nkb64knkb64knkb6.png',
  'https://zenuphealth.com/wp-content/uploads/2025/11/Gemini_Generated_Image_iw7i4diw7i4diw7i.png',
  'https://zenuphealth.com/wp-content/uploads/2025/11/Gemini_Generated_Image_bno9usbno9usbno9-3-scaled.png',
  'https://zenuphealth.com/wp-content/uploads/2025/11/Gemini_Generated_Image_bno9usbno9usbno9-4-scaled.png',
  'https://zenuphealth.com/wp-content/uploads/2025/11/Gemini_Generated_Image_2pgjzm2pgjzm2pgj-scaled.png',
  'https://zenuphealth.com/wp-content/uploads/2026/01/Bhoomi-2-e1767772602403.jpg',
  'https://zenuphealth.com/wp-content/uploads/2026/01/Anirudh-e1767771975908.png',
  'https://zenuphealth.com/wp-content/uploads/2026/03/Profiles-new-12-e1772586242442.jpg',
  'https://zenuphealth.com/wp-content/uploads/2026/01/WhatsApp-Image-2026-01-07-at-1.28.09-PM-1-e1767772797618.jpeg',
  'https://zenuphealth.com/wp-content/uploads/2025/12/3.jpg',
  'https://zenuphealth.com/wp-content/uploads/2026/01/Alia-e1767772057623.jpeg',
  'https://zenuphealth.com/wp-content/uploads/2026/01/Tanya-e1767772524441.png',
  'https://zenuphealth.com/wp-content/uploads/2026/01/Image-e1767772101515.jpeg',
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
    for (final url in _onboardingImageUrls) {
      final provider = ResizeImage.resizeIfNeeded(
        720,
        null,
        CachedNetworkImageProvider(url, cacheKey: url),
      );
      unawaited(precacheImage(provider, context).catchError((_) {}));
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
                    return _SlideOne(
                      isActive: _currentIndex == 0,
                      pageOffset: pageOffset,
                      screenWidth: screenWidth,
                    );
                  case 1:
                    return _SlideTwo(
                      isActive: _currentIndex == 1,
                      pageOffset: pageOffset,
                      screenWidth: screenWidth,
                    );
                  case 2:
                    return _SlideThree(
                      isActive: _currentIndex == 2,
                      pageOffset: pageOffset,
                      screenWidth: screenWidth,
                    );
                  case 3:
                    return _SlideFour(
                      isActive: _currentIndex == 3,
                      pageOffset: pageOffset,
                      screenWidth: screenWidth,
                    );
                  case 4:
                  default:
                    return _SlideFive(
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

// â”€â”€ Image Helper with Cached Placeholder and Error Fallback â”€â”€
Widget _buildNetworkImage(
  String url, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  double borderRadius = 0,
  int? cacheWidth,
  int? cacheHeight,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: CachedNetworkImage(
      imageUrl: url,
      cacheKey: url,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: cacheWidth,
      memCacheHeight: cacheHeight,
      maxWidthDiskCache: cacheWidth == null ? 900 : cacheWidth * 2,
      maxHeightDiskCache: cacheHeight == null ? null : cacheHeight * 2,
      fadeInDuration: const Duration(milliseconds: 160),
      fadeOutDuration: Duration.zero,
      placeholderFadeInDuration: Duration.zero,
      useOldImageOnUrlChange: true,
      imageBuilder: (context, imageProvider) => Image(
        image: imageProvider,
        width: width,
        height: height,
        fit: fit,
        gaplessPlayback: true,
        filterQuality: FilterQuality.medium,
      ),
      placeholder: (context, url) => Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        color: const Color(0xFFF3F4F6),
        child: const Center(
          child: Icon(Icons.image_outlined, color: Color(0xFFD1D5DB), size: 22),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        color: const Color(0xFFF3F4F6),
        child: const Center(
          child: Icon(
            Icons.videocam_off_rounded,
            color: Color(0xFF9CA3AF),
            size: 24,
          ),
        ),
      ),
    ),
  );
}

// â”€â”€ Trust Badge Helper â”€â”€
Widget _buildTrustBadge(IconData icon, Color iconColor, String text) {
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

// â”€â”€ Slide 1: Brand Hero â”€â”€
class _SlideOne extends StatefulWidget {
  final bool isActive;
  final double pageOffset;
  final double screenWidth;

  const _SlideOne({
    required this.isActive,
    required this.pageOffset,
    required this.screenWidth,
  });

  @override
  State<_SlideOne> createState() => _SlideOneState();
}

class _SlideOneState extends State<_SlideOne>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _titleOpacity;
  late Animation<double> _titleTranslation;
  late Animation<double> _logoOpacity;
  late Animation<double> _subOpacity;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 1.05, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.16, 0.55, curve: Curves.easeOut),
      ),
    );

    _titleTranslation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.16, 0.55, curve: Curves.easeOut),
      ),
    );

    _subOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.29, 0.7, curve: Curves.easeOut),
      ),
    );

    if (widget.isActive) {
      _entryController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant _SlideOne oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _entryController.reset();
      _entryController.forward();
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.of(context).size.height * 0.45;

    return Stack(
      children: [
        // Parallax Background shape
        Positioned(
          top: -30,
          right: -30,
          child: Transform.translate(
            offset: Offset(widget.pageOffset * widget.screenWidth * 0.4, 0),
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFF1E6).withValues(alpha: 0.5),
              ),
            ),
          ),
        ),

        // Scrollable content layout to prevent overflows
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Hero Image (Ken Burns effect)
              SizedBox(
                height: imageHeight,
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.white, Colors.transparent],
                            stops: [0.75, 1.0],
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.dstIn,
                        child: _buildNetworkImage(
                          'https://res.cloudinary.com/dalzfjt8f/image/upload/v1775200162/Gemini_Generated_Image_9ile2d9ile2d9ile_jphxwo.png',
                          fit: BoxFit.cover,
                          cacheWidth: 900,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Content Area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: AnimatedBuilder(
                  animation: _entryController,
                  builder: (context, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ZenUp Logo Icon
                        Opacity(
                          opacity: _logoOpacity.value,
                          child: Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFF47B20,
                                  ).withValues(alpha: 0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                AppConstants.zenupIconPng,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: const Color(0xFFF3F4F6),
                                      child: const Icon(
                                        Icons.spa_rounded,
                                        color: Color(0xFFF47B20),
                                        size: 40,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title
                        Opacity(
                          opacity: _titleOpacity.value,
                          child: Transform.translate(
                            offset: Offset(0, _titleTranslation.value),
                            child: const Text(
                              "Let's Help You Start A Better Life",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D0F1A),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Subtitle
                        Opacity(
                          opacity: _subOpacity.value,
                          child: const Text(
                            "Your path to mental well-being starts here",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF5B6270),
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Badges
                        _buildBadgeRow(),
                        const SizedBox(height: 88), // Space at bottom for page indicator
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeRow() {
    double b1 = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).transform(_entryController.getCurvePercent(0.4, 0.8));
    double b2 = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).transform(_entryController.getCurvePercent(0.5, 0.9));
    double b3 = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).transform(_entryController.getCurvePercent(0.6, 1.0));

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        Opacity(
          opacity: b1,
          child: _buildTrustBadge(
            Icons.shield_outlined,
            const Color(0xFF00C9A7),
            "100% Confidential",
          ),
        ),
        Opacity(
          opacity: b2,
          child: _buildTrustBadge(
            Icons.star_rounded,
            Colors.amber,
            "4.7/5 Rating",
          ),
        ),
        Opacity(
          opacity: b3,
          child: _buildTrustBadge(
            Icons.lock_outline_rounded,
            const Color(0xFFF47B20),
            "No Bots. Ever",
          ),
        ),
      ],
    );
  }
}

// Helper extension to calculate sub-ranges on AnimationController
extension on AnimationController {
  double getCurvePercent(double start, double end) {
    if (value < start) return 0.0;
    if (value > end) return 1.0;
    return (value - start) / (end - start);
  }
}

// â”€â”€ Slide 2: Services Grid â”€â”€
class _SlideTwo extends StatefulWidget {
  final bool isActive;
  final double pageOffset;
  final double screenWidth;

  const _SlideTwo({
    required this.isActive,
    required this.pageOffset,
    required this.screenWidth,
  });

  @override
  State<_SlideTwo> createState() => _SlideTwoState();
}

class _SlideTwoState extends State<_SlideTwo>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _titleOpacity;
  late Animation<double> _titleTranslation;
  late Animation<double> _subOpacity;

  final List<Map<String, String>> _services = [
    {
      'url':
          'https://zenuphealth.com/wp-content/uploads/2025/11/Gemini_Generated_Image_fd9kjafd9kjafd9k-1-scaled.png',
      'label': 'Anxiety / Stress',
    },
    {
      'url':
          'https://zenuphealth.com/wp-content/uploads/2025/11/Gemini_Generated_Image_nkb64knkb64knkb6.png',
      'label': 'Depression',
    },
    {
      'url':
          'https://zenuphealth.com/wp-content/uploads/2025/11/Gemini_Generated_Image_iw7i4diw7i4diw7i.png',
      'label': 'ADHD',
    },
    {
      'url':
          'https://zenuphealth.com/wp-content/uploads/2025/11/Gemini_Generated_Image_bno9usbno9usbno9-3-scaled.png',
      'label': 'Anger Issues',
    },
    {
      'url':
          'https://zenuphealth.com/wp-content/uploads/2025/11/Gemini_Generated_Image_bno9usbno9usbno9-4-scaled.png',
      'label': 'Low Self-Esteem',
    },
    {
      'url':
          'https://zenuphealth.com/wp-content/uploads/2025/11/Gemini_Generated_Image_2pgjzm2pgjzm2pgj-scaled.png',
      'label': 'Relationship Counselling',
    },
  ];

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.1, 0.45, curve: Curves.easeOut),
      ),
    );

    _titleTranslation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.1, 0.45, curve: Curves.easeOut),
      ),
    );

    _subOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.25, 0.65, curve: Curves.easeOut),
      ),
    );

    if (widget.isActive) {
      _entryController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant _SlideTwo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _entryController.reset();
      _entryController.forward();
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = (widget.screenWidth - 64) / 3;

    return Stack(
      children: [
        // Parallax Background shape
        Positioned(
          top: 100,
          left: -40,
          child: Transform.translate(
            offset: Offset(widget.pageOffset * widget.screenWidth * 0.4, 0),
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00C9A7).withValues(alpha: 0.04),
              ),
            ),
          ),
        ),

        // Scrollable slide layout that fills the screen dynamically
        LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 24),
                          // Category tag
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF1E6),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Text(
                                "Our Services",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFF47B20),
                                  letterSpacing: 0.08,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Title
                          AnimatedBuilder(
                            animation: _entryController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _titleOpacity.value,
                                child: Transform.translate(
                                  offset: Offset(0, _titleTranslation.value),
                                  child: const Text(
                                    "Expert Care For Your Mental Health",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0D0F1A),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 6),

                          // Subtitle
                          AnimatedBuilder(
                            animation: _entryController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _subOpacity.value,
                                child: const Text(
                                  "Evidence-based therapy tailored to your unique needs, delivered by certified professionals",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF5B6270),
                                    height: 1.5,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),

                          // GridView builder (shrinkWrapped)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio:
                                      cardWidth / (cardWidth + 48),
                                ),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              final item = _services[index];
                              double start = 0.3 + (index * 0.06);
                              double end = start + 0.35;
                              Animation<double> tileAnim =
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: _entryController,
                                      curve: Interval(
                                        start.clamp(0.0, 1.0),
                                        end.clamp(0.0, 1.0),
                                        curve: Curves.easeOut,
                                      ),
                                    ),
                                  );

                              return _buildServiceTile(
                                item['url']!,
                                item['label']!,
                                tileAnim,
                                cardWidth,
                              );
                            },
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 16),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "All sessions are 100% confidential and conducted in a safe, secure, and non-judgmental digital environment.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.5,
                                color: Color(0xFF9CA3AF),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Teal footer link
                          Center(
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                "+ 15 more concerns covered",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF00C9A7),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 88), // Spacing below for page indicator
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildServiceTile(
    String url,
    String label,
    Animation<double> animation,
    double width,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 16.0 * (1.0 - animation.value)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _buildNetworkImage(
                      url,
                      fit: BoxFit.cover,
                      borderRadius: 16,
                      cacheWidth: 260,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5B6270),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// â”€â”€ Slide 3: Real Therapists â”€â”€
class _SlideThree extends StatefulWidget {
  final bool isActive;
  final double pageOffset;
  final double screenWidth;

  const _SlideThree({
    required this.isActive,
    required this.pageOffset,
    required this.screenWidth,
  });

  @override
  State<_SlideThree> createState() => _SlideThreeState();
}

class _SlideThreeState extends State<_SlideThree>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _titleOpacity;
  late Animation<double> _titleTranslation;
  late Animation<double> _subOpacity;

  late ScrollController _scrollController;
  Timer? _scrollTimer;
  Timer? _resumeTimer;
  bool _isAutoScrolling = true;

  final List<Map<String, String>> _therapists = [
    {
      'name': 'Bhoomi Doshi',
      'url':
          'https://zenuphealth.com/wp-content/uploads/2026/01/Bhoomi-2-e1767772602403.jpg',
      'exp': '11+ Years',
    },
    {
      'name': 'Atharva Ghorpade',
      'url':
          'https://zenuphealth.com/wp-content/uploads/2026/01/Anirudh-e1767771975908.png',
      'exp': '5+ Years',
    },
    {
      'name': 'Sharvari Rane',
      'url':
          'https://zenuphealth.com/wp-content/uploads/2026/03/Profiles-new-12-e1772586242442.jpg',
      'exp': '2+ Years',
    },
    {
      'name': 'Maithili Joshi',
      'url':
          'https://zenuphealth.com/wp-content/uploads/2026/01/WhatsApp-Image-2026-01-07-at-1.28.09-PM-1-e1767772797618.jpeg',
      'exp': '20+ Years',
    },
    {
      'name': 'Pavitra Madhav',
      'url': 'https://zenuphealth.com/wp-content/uploads/2025/12/3.jpg',
      'exp': '4+ Years',
    },
    {
      'name': 'Tanya Chawda',
      'url':
          'https://zenuphealth.com/wp-content/uploads/2026/01/Alia-e1767772057623.jpeg',
      'exp': '7+ Years',
    },
    {
      'name': 'Alia S',
      'url':
          'https://zenuphealth.com/wp-content/uploads/2026/01/Tanya-e1767772524441.png',
      'exp': '3+ Years',
    },
    {
      'name': 'Mary Eliza',
      'url':
          'https://zenuphealth.com/wp-content/uploads/2026/01/Image-e1767772101515.jpeg',
      'exp': '5+ Years',
    },
  ];

  final List<String> _specialties = [
    'CBT',
    'REBT',
    'Trauma',
    'Grief',
    'ADHD',
    'Couples',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.1, 0.45, curve: Curves.easeOut),
      ),
    );

    _titleTranslation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.1, 0.45, curve: Curves.easeOut),
      ),
    );

    _subOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.25, 0.65, curve: Curves.easeOut),
      ),
    );

    if (widget.isActive) {
      _entryController.forward();
      _startScrolling();
    }
  }

  @override
  void didUpdateWidget(covariant _SlideThree oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _entryController.reset();
      _entryController.forward();
      _isAutoScrolling = true;
      _startScrolling();
    } else if (!widget.isActive && oldWidget.isActive) {
      _scrollTimer?.cancel();
      _resumeTimer?.cancel();
    }
  }

  void _startScrolling() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (_scrollController.hasClients && _isAutoScrolling) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.offset;
        double nextScroll = currentScroll + 0.8; // Slow linear speed
        if (nextScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(nextScroll);
        }
      }
    });
  }

  void _pauseAutoScroll() {
    setState(() {
      _isAutoScrolling = false;
    });
    _resumeTimer?.cancel();
    _resumeTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isAutoScrolling = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _scrollController.dispose();
    _scrollTimer?.cancel();
    _resumeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duplicatedTherapists = [..._therapists, ..._therapists];

    return Stack(
      children: [
        // Top-left Parallax Background shape
        Positioned(
          top: -20,
          left: 40,
          child: Transform.translate(
            offset: Offset(widget.pageOffset * widget.screenWidth * 0.4, 0),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFF1E6).withValues(alpha: 0.35),
              ),
            ),
          ),
        ),

        // Bottom-right Parallax Background shape (balancing element)
        Positioned(
          bottom: 40,
          right: -30,
          child: Transform.translate(
            offset: Offset(widget.pageOffset * widget.screenWidth * 0.4, 0),
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF47B20).withValues(alpha: 0.03),
              ),
            ),
          ),
        ),

        // Scrollable slide layout that fills the screen dynamically (90-95% coverage)
        LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedBuilder(
                        animation: _entryController,
                        builder: (context, child) {
                          // Animations:
                          double titleOp = _titleOpacity.value;
                          double titleTrans = _titleTranslation.value;
                          double subOp = _subOpacity.value;

                          // Infographic Animation: fade and slide up from 12px at 0.15 to 0.55
                          double infoProgress = _entryController
                              .getCurvePercent(0.15, 0.55);
                          double infoOp = Tween<double>(
                            begin: 0.0,
                            end: 1.0,
                          ).transform(infoProgress);
                          double infoTrans = Tween<double>(
                            begin: 12.0,
                            end: 0.0,
                          ).transform(infoProgress);

                          // Therapist scroller Animation: fade and slide up from 12px at 0.3 to 0.7
                          double listProgress = _entryController
                              .getCurvePercent(0.3, 0.7);
                          double listOp = Tween<double>(
                            begin: 0.0,
                            end: 1.0,
                          ).transform(listProgress);
                          double listTrans = Tween<double>(
                            begin: 12.0,
                            end: 0.0,
                          ).transform(listProgress);

                          // Category tag fade-in: at 0ms to 300ms
                          double tagProgress = _entryController.getCurvePercent(
                            0.0,
                            0.3,
                          );
                          double tagOp = Tween<double>(
                            begin: 0.0,
                            end: 1.0,
                          ).transform(tagProgress);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 24),
                              // Category tag
                              Opacity(
                                opacity: tagOp,
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF1E6),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Text(
                                      "Our Experts",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFF47B20),
                                        letterSpacing: 0.08,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Title
                              Opacity(
                                opacity: titleOp,
                                child: Transform.translate(
                                  offset: Offset(0, titleTrans),
                                  child: const Text(
                                    "Real Experts. Real Talk. Real Healing.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0D0F1A),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Subtitle
                              Opacity(
                                opacity: subOp,
                                child: const Text(
                                  "50+ verified therapists and psychiatrists across India",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF5B6270),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),

                              // Vetting & Quality Infographic Card
                              Opacity(
                                opacity: infoOp,
                                child: Transform.translate(
                                  offset: Offset(0, infoTrans),
                                  child: _buildExpertiseInfographic(),
                                ),
                              ),
                              const SizedBox(height: 18),

                              // Auto-scrolling row of verified therapists
                              Opacity(
                                opacity: listOp,
                                child: Transform.translate(
                                  offset: Offset(0, listTrans),
                                  child: SizedBox(
                                    height: 190,
                                    child: GestureDetector(
                                      onPanDown: (_) => _pauseAutoScroll(),
                                      child: ListView.builder(
                                        controller: _scrollController,
                                        scrollDirection: Axis.horizontal,
                                        physics: const ClampingScrollPhysics(),
                                        cacheExtent: widget.screenWidth * 2,
                                        itemCount: duplicatedTherapists.length,
                                        itemBuilder: (context, index) {
                                          final item =
                                              duplicatedTherapists[index];
                                          return _buildTherapistCard(item);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),

                              // Specialty tags wrapping row with custom emoji/icon visuals
                              _buildSpecialtyRow(),
                            ],
                          );
                        },
                      ),
                      Column(
                        children: const [
                          SizedBox(height: 18),
                          // Clinical Vetting Quality Footer note
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "Our therapists undergo a rigorous 5-step clinical evaluation process to ensure you receive high-quality, empathetic, and evidence-based mental healthcare.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.5,
                                color: Color(0xFF9CA3AF),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(height: 88), // Spacing below for page indicator
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildExpertiseInfographic() {
    final items = [
      {
        'icon': Icons.verified_user_outlined,
        'color': const Color(0xFF00C9A7),
        'title': '100% Vetted',
        'sub': 'Clinical check',
      },
      {
        'icon': Icons.history_edu_outlined,
        'color': const Color(0xFFF47B20),
        'title': '8+ Yrs Avg',
        'sub': 'Clinical exp',
      },
      {
        'icon': Icons.school_outlined,
        'color': Colors.indigo,
        'title': 'Master/Ph.D',
        'sub': 'Licensed team',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: (item['color'] as Color).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: item['color'] as Color,
                  size: 14,
                ),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item['title'] as String,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0D0F1A),
                    ),
                  ),
                  Text(
                    item['sub'] as String,
                    style: const TextStyle(
                      fontSize: 8,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTherapistCard(Map<String, String> data) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(left: 12, right: 4, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image header with "Verified" badge overlay
          SizedBox(
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: _buildNetworkImage(
                    data['url']!,
                    fit: BoxFit.cover,
                    cacheWidth: 280,
                    cacheHeight: 200,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00C9A7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.check, size: 8, color: Colors.white),
                        SizedBox(width: 2),
                        Text(
                          "Verified",
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info below
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0D0F1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data['exp']!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialtyRow() {
    final specialtyIcons = {
      'CBT': '',
      'REBT': '',
      'Trauma': '',
      'Grief': '',
      'ADHD': '',
      'Couples': '',
    };

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: List.generate(_specialties.length, (index) {
        final name = _specialties[index];
        final emoji = specialtyIcons[name] ?? 'âœ¨';
        double start = 0.4 + (index * 0.08);
        double end = start + 0.3;
        double opacity = Tween<double>(begin: 0.0, end: 1.0).transform(
          _entryController.getCurvePercent(
            start.clamp(0.0, 1.0),
            end.clamp(0.0, 1.0),
          ),
        );

        return Opacity(
          opacity: opacity,
          child: Container(
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 11)),
                const SizedBox(width: 4),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5B6270),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// â”€â”€ Slide 4: Social Proof â”€â”€
class _SlideFour extends StatefulWidget {
  final bool isActive;
  final double pageOffset;
  final double screenWidth;

  const _SlideFour({
    required this.isActive,
    required this.pageOffset,
    required this.screenWidth,
  });

  @override
  State<_SlideFour> createState() => _SlideFourState();
}

class _SlideFourState extends State<_SlideFour> with TickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _titleOpacity;
  late Animation<double> _titleTranslation;

  int _testimonialIndex = 0;
  Timer? _testimonialTimer;

  final List<Map<String, String>> _testimonials = [
    {
      'quote':
          'We were stuck in a cycle of blame and silence. Zenup\'s counselling helped us listen, reconnect and rediscover our partnership. We\'re more in love than ever.',
      'name': 'Sanya and Rohit',
      'location': 'Bangalore',
      'service': 'Couples Therapy',
      'initials': 'SR',
    },
    {
      'quote':
          'As a college student dealing with severe anxiety, I was skeptical about therapy. But Zenup made it accessible and judgment-free. My therapist truly understood me.',
      'name': 'Neha K',
      'location': 'Mumbai',
      'service': 'Anxiety',
      'initials': 'NK',
    },
    {
      'quote':
          'Postpartum depression hit me harder than I expected. Zenup matched me with a therapist who specialized in maternal mental health. She literally saved my life.',
      'name': 'Divya N',
      'location': 'Lucknow',
      'service': 'Postpartum Support',
      'initials': 'DN',
    },
  ];

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _titleTranslation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    if (widget.isActive) {
      _entryController.forward();
      _startTestimonialTimer();
    }
  }

  @override
  void didUpdateWidget(covariant _SlideFour oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _entryController.reset();
      _entryController.forward();
      _startTestimonialTimer();
    } else if (!widget.isActive && oldWidget.isActive) {
      _testimonialTimer?.cancel();
    }
  }

  void _startTestimonialTimer() {
    _testimonialTimer?.cancel();
    _testimonialTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _testimonialIndex = (_testimonialIndex + 1) % _testimonials.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _testimonialTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top-left Parallax Background shape (Amber glow)
        Positioned(
          top: -30,
          left: -30,
          child: Transform.translate(
            offset: Offset(widget.pageOffset * widget.screenWidth * 0.4, 0),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF59E0B).withValues(alpha: 0.03),
              ),
            ),
          ),
        ),

        // Bottom-right Parallax Background shape (Lavender glow)
        Positioned(
          bottom: 120,
          right: -30,
          child: Transform.translate(
            offset: Offset(widget.pageOffset * widget.screenWidth * 0.4, 0),
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFF1E6).withValues(alpha: 0.5),
              ),
            ),
          ),
        ),

        // Scrollable slide layout that fills the screen dynamically (90-95% coverage)
        LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedBuilder(
                        animation: _entryController,
                        builder: (context, child) {
                          // Animations:
                          double titleOp = _titleOpacity.value;
                          double titleTrans = _titleTranslation.value;

                          // Grid Progress Animation: at 0.15 to 0.55
                          double gridProgress = _entryController
                              .getCurvePercent(0.15, 0.55);
                          double gridOp = Tween<double>(
                            begin: 0.0,
                            end: 1.0,
                          ).transform(gridProgress);
                          double gridTrans = Tween<double>(
                            begin: 12.0,
                            end: 0.0,
                          ).transform(gridProgress);

                          // Testimonial Progress Animation: at 0.3 to 0.7
                          double testProgress = _entryController
                              .getCurvePercent(0.3, 0.7);
                          double testOp = Tween<double>(
                            begin: 0.0,
                            end: 1.0,
                          ).transform(testProgress);
                          double testTrans = Tween<double>(
                            begin: 12.0,
                            end: 0.0,
                          ).transform(testProgress);

                          // Category tag Progress: at 0ms to 300ms
                          double tagProgress = _entryController.getCurvePercent(
                            0.0,
                            0.3,
                          );
                          double tagOp = Tween<double>(
                            begin: 0.0,
                            end: 1.0,
                          ).transform(tagProgress);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 24),
                              // Category tag
                              Opacity(
                                opacity: tagOp,
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF1E6),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Text(
                                      "Testimonials",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFF47B20),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Headline
                              Opacity(
                                opacity: titleOp,
                                child: Transform.translate(
                                  offset: Offset(0, titleTrans),
                                  child: const Text(
                                    "Thousands Have Found Healing Here",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0D0F1A),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Subtitle
                              Opacity(
                                opacity: titleOp,
                                child: const Text(
                                  "Real stories from real users on their journey to mental wellness",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF5B6270),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Metrics 2x2 grid (Using shrinkwrapped GridView)
                              Opacity(
                                opacity: gridOp,
                                child: Transform.translate(
                                  offset: Offset(0, gridTrans),
                                  child: GridView(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          childAspectRatio: 2.2,
                                        ),
                                    children: [
                                      _AnimatedMetricCard(
                                        targetValue: 50000,
                                        label: "Lives Impacted",
                                        suffix: "+",
                                        icon: Icons.people_alt_outlined,
                                        iconColor: const Color(0xFFF47B20),
                                        isActive: widget.isActive,
                                      ),
                                      _AnimatedMetricCard(
                                        targetValue: 96,
                                        label: "Clients Satisfied",
                                        suffix: "%",
                                        icon: Icons
                                            .sentiment_very_satisfied_outlined,
                                        iconColor: const Color(0xFF00C9A7),
                                        isActive: widget.isActive,
                                      ),
                                      _AnimatedMetricCard(
                                        targetValue: 50,
                                        label: "Expert Therapists",
                                        suffix: "+",
                                        icon: Icons.workspace_premium_outlined,
                                        iconColor: const Color(0xFFF47B20),
                                        isActive: widget.isActive,
                                      ),
                                      _AnimatedMetricCard(
                                        targetValue: 4.7,
                                        label: "Average Rating",
                                        suffix: "/5",
                                        decimalPlaces: 1,
                                        valueColor: Colors.amber,
                                        icon: Icons.star_rate_rounded,
                                        iconColor: Colors.amber,
                                        isActive: widget.isActive,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Testimonial crossfade box
                              Opacity(
                                opacity: testOp,
                                child: Transform.translate(
                                  offset: Offset(0, testTrans),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        child: _buildTestimonialCard(
                                          _testimonials[_testimonialIndex],
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      // Testimonials slide index indicator dots
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          _testimonials.length,
                                          (dotIdx) {
                                            bool isDotActive =
                                                dotIdx == _testimonialIndex;
                                            return AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 4,
                                                  ),
                                              width: isDotActive ? 12 : 4,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                color: isDotActive
                                                    ? const Color(0xFFF47B20)
                                                    : const Color(0xFFE5E7EB),
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      Column(
                        children: const [
                          SizedBox(height: 16),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "All quotes are shared by actual clients with full permission. Zenup protects user privacy and clinical data at the highest standards.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.5,
                                color: Color(0xFF9CA3AF),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(height: 88), // Spacing below for page indicator
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTestimonialCard(Map<String, String> t) {
    return Container(
      key: ValueKey(t['name']),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Left vertical border gradient indicator
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(width: 4, color: const Color(0xFFF47B20)),
          ),

          // Background double quote tag (top right)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF1E6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.format_quote_rounded,
                size: 14,
                color: Color(0xFFF47B20),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Quote body
                Text(
                  t['quote']!,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF5B6270),
                  ),
                ),
                const SizedBox(height: 12),
                // Author info
                Row(
                  children: [
                    // Initials
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF1E6),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          t['initials']!,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFF47B20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t['name']!,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0D0F1A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${t['location']!} â€¢ ${t['service']!}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€ Slide 5: Final CTA â”€â”€
class _SlideFive extends StatefulWidget {
  final bool isActive;
  final double pageOffset;
  final double screenWidth;
  final VoidCallback onGetStarted;

  const _SlideFive({
    required this.isActive,
    required this.pageOffset,
    required this.screenWidth,
    required this.onGetStarted,
  });

  @override
  State<_SlideFive> createState() => _SlideFiveState();
}

class _SlideFiveState extends State<_SlideFive> with TickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _logoOpacity;
  late Animation<double> _titleOpacity;
  late Animation<double> _titleTranslation;
  late Animation<double> _subOpacity;
  late Animation<double> _subTranslation;

  late AnimationController _buttonScaleController;
  late Animation<double> _buttonScaleAnimation;

  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  // Continuous animation for logo (slow float, glowing pulse)
  late AnimationController _logoAnimationController;
  late Animation<double> _logoFloat;
  late Animation<double> _logoGlow;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
      ),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );

    _titleTranslation = Tween<double>(begin: 16.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );

    _subOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    _subTranslation = Tween<double>(begin: 16.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    _buttonScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _buttonScaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _buttonScaleController, curve: Curves.elasticOut),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // Continuous floating and glowing animation
    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );
    _logoFloat = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _logoGlow = Tween<double>(begin: 0.06, end: 0.16).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isActive) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    _entryController.reset();
    _buttonScaleController.reset();
    _shimmerController.reset();
    _logoAnimationController.reset();

    _entryController.forward();
    _logoAnimationController.repeat(reverse: true);

    // Stagger button entry
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _buttonScaleController.forward();
        _shimmerController.forward();
      }
    });
  }

  @override
  void didUpdateWidget(covariant _SlideFive oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _startAnimations();
    } else if (!widget.isActive && oldWidget.isActive) {
      _logoAnimationController.stop();
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _buttonScaleController.dispose();
    _shimmerController.dispose();
    _logoAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Parallax Background shapes
        Positioned(
          bottom: -30,
          left: -30,
          child: Transform.translate(
            offset: Offset(widget.pageOffset * widget.screenWidth * 0.4, 0),
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF47B20).withValues(alpha: 0.04),
              ),
            ),
          ),
        ),
        Positioned(
          top: 60,
          right: -20,
          child: Transform.translate(
            offset: Offset(widget.pageOffset * widget.screenWidth * 0.2, 0),
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00C9A7).withValues(alpha: 0.03),
              ),
            ),
          ),
        ),

        // Scrollable slide layout that fills the screen dynamically
        LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: AnimatedBuilder(
                    animation: _entryController,
                    builder: (context, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Top header & logo block
                          Column(
                            children: [
                              const SizedBox(height: 24),
                              // Premium Logo Container with Floating & Glowing Pulse Animations
                              Center(
                                child: AnimatedBuilder(
                                  animation: Listenable.merge([
                                    _entryController,
                                    _logoAnimationController,
                                  ]),
                                  builder: (context, child) {
                                    double entryOpacity = _logoOpacity.value;
                                    double entryScale = _scaleAnimation.value;
                                    double floatVal = _logoFloat.value;
                                    double glowVal = _logoGlow.value;

                                    return Opacity(
                                      opacity: entryOpacity,
                                      child: Transform.scale(
                                        scale: entryScale,
                                        child: Transform.translate(
                                          offset: Offset(0, floatVal),
                                          child: Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              border: Border.all(
                                                color: const Color(
                                                  0xFFF47B20,
                                                ).withValues(alpha: 0.1),
                                                width: 4.0,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(
                                                    0xFFF47B20,
                                                  ).withValues(alpha: glowVal),
                                                  blurRadius:
                                                      28 + (glowVal * 40),
                                                  spreadRadius:
                                                      2 + (glowVal * 8),
                                                  offset: const Offset(0, 6),
                                                ),
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.03),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: ClipOval(
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  4.0,
                                                ),
                                                child: Image.asset(
                                                  AppConstants.zenupIconPng,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => Container(
                                                        color: const Color(
                                                          0xFFF3F4F6,
                                                        ),
                                                        child: const Icon(
                                                          Icons.spa_rounded,
                                                          color: Color(
                                                            0xFFF47B20,
                                                          ),
                                                          size: 48,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Title and Subtitle Block
                              Opacity(
                                opacity: _titleOpacity.value,
                                child: Transform.translate(
                                  offset: Offset(0, _titleTranslation.value),
                                  child: const Text(
                                    "Your Healing Starts Here",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0D0F1A),
                                      letterSpacing: -0.8,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Opacity(
                                opacity: _subOpacity.value,
                                child: Transform.translate(
                                  offset: Offset(0, _subTranslation.value),
                                  child: const Text(
                                    "Join 50,000+ people who chose to live a happier, healthier life",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF5B6270),
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Middle Infographic Feature Area (staggered cards)
                          Column(
                            children: [
                              const SizedBox(height: 24),
                              _buildPremiumFeaturesGrid(),
                              const SizedBox(height: 16),
                              _buildZenupPromiseCard(),
                            ],
                          ),

                          // Bottom Action & Trust Badges Footer
                          Column(
                            children: [
                              const SizedBox(height: 24),
                              // Get Started Button
                              ScaleTransition(
                                scale: _buttonScaleAnimation,
                                child: AnimatedBuilder(
                                  animation: _shimmerAnimation,
                                  builder: (context, child) {
                                    return InkWell(
                                      onTap: widget.onGetStarted,
                                      borderRadius: BorderRadius.circular(16),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 56,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFFF47B20),
                                                    Color(0xFFE06A12),
                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(
                                                      0xFFF47B20,
                                                    ).withValues(alpha: 0.25),
                                                    blurRadius: 16,
                                                    offset: const Offset(0, 6),
                                                  ),
                                                ],
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  "Get Started",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                    letterSpacing: 0.2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned.fill(
                                              child: FractionallySizedBox(
                                                widthFactor: 0.35,
                                                alignment: Alignment(
                                                  _shimmerAnimation.value,
                                                  0.0,
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.white.withValues(
                                                          alpha: 0.0,
                                                        ),
                                                        Colors.white.withValues(
                                                          alpha: 0.25,
                                                        ),
                                                        Colors.white.withValues(
                                                          alpha: 0.0,
                                                        ),
                                                      ],
                                                      stops: const [
                                                        0.0,
                                                        0.5,
                                                        1.0,
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Already have an account row
                              Center(
                                child: Text.rich(
                                  TextSpan(
                                    text: "Already have an account? ",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF5B6270),
                                    ),
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: GestureDetector(
                                          onTap: widget.onGetStarted,
                                          child: const Text(
                                            "Sign in",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFFF47B20),
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),

                              // Trust Badge Row
                              _buildBottomTrustBadgeRow(),
                              const SizedBox(height: 32), // Bottom padding
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPremiumFeaturesGrid() {
    final list = [
      {
        'icon': Icons.lock_outline_rounded,
        'color': const Color(0xFFF47B20),
        'bg': const Color(0xFFF47B20).withValues(alpha: 0.08),
        'lbl': '100% Private',
        'sub':
            'Strict confidentiality under clinical guidelines. No recordings.',
      },
      {
        'icon': Icons.verified_user_outlined,
        'color': const Color(0xFF00C9A7),
        'bg': const Color(0xFF00C9A7).withValues(alpha: 0.08),
        'lbl': 'Vetted Experts',
        'sub': 'Top 3% practitioners with rigorous clinical auditing.',
      },
      {
        'icon': Icons.favorite_border_rounded,
        'color': const Color(0xFFF47B20),
        'bg': const Color(0xFFF47B20).withValues(alpha: 0.08),
        'lbl': 'True Human Care',
        'sub': 'No AI, bots, or canned answers. Real empathetic therapists.',
      },
      {
        'icon': Icons.event_available_outlined,
        'color': const Color(0xFF00C9A7),
        'bg': const Color(0xFF00C9A7).withValues(alpha: 0.08),
        'lbl': 'Flexible Scheduling',
        'sub': 'Book anytime. No expiring care plans or forced timelines.',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.25,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        final item = list[index];
        double start = 0.45 + (index * 0.08);
        double end = start + 0.25;
        double progress = _entryController.getCurvePercent(
          start.clamp(0.0, 1.0),
          end.clamp(0.0, 1.0),
        );
        double translateY = Tween<double>(
          begin: 16.0,
          end: 0.0,
        ).transform(progress);
        double opacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).transform(progress);

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, translateY),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF2F4F7)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.015),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: item['bg'] as Color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      size: 18,
                      color: item['color'] as Color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item['lbl'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D0F1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      item['sub'] as String,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF5B6270),
                        height: 1.35,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildZenupPromiseCard() {
    double progress = _entryController.getCurvePercent(0.7, 0.9);
    double opacity = Tween<double>(begin: 0.0, end: 1.0).transform(progress);
    double translateY = Tween<double>(
      begin: 12.0,
      end: 0.0,
    ).transform(progress);

    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(0, translateY),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFF47B20).withValues(alpha: 0.05),
                const Color(0xFF00C9A7).withValues(alpha: 0.03),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFF47B20).withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_outlined,
                  color: Color(0xFFF47B20),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Clinical Vetting Guarantee",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D0F1A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Every therapy session is conducted by licensed practitioners vetted under rigorous medical standards.",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF5B6270),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomTrustBadgeRow() {
    double progress = _entryController.getCurvePercent(0.8, 1.0);
    double opacity = Tween<double>(begin: 0.0, end: 1.0).transform(progress);

    return Opacity(
      opacity: opacity,
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          _buildSmallTrustItem(Icons.security, "HIPAA Compliant"),
          _buildSmallTrustItem(Icons.lock_outline, "24/7 Encryption"),
          _buildSmallTrustItem(
            Icons.headset_mic_outlined,
            "Helpline: +91 7208235555",
          ),
        ],
      ),
    );
  }

  Widget _buildSmallTrustItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }
}

// â”€â”€ Metric Count-up Card â”€â”€
class _AnimatedMetricCard extends StatefulWidget {
  final double targetValue;
  final String label;
  final String suffix;
  final int decimalPlaces;
  final Color? valueColor;
  final bool isActive;
  final IconData icon;
  final Color iconColor;

  const _AnimatedMetricCard({
    required this.targetValue,
    required this.label,
    required this.suffix,
    this.decimalPlaces = 0,
    this.valueColor,
    required this.isActive,
    required this.icon,
    required this.iconColor,
  });

  @override
  State<_AnimatedMetricCard> createState() => _AnimatedMetricCardState();
}

class _AnimatedMetricCardState extends State<_AnimatedMetricCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.targetValue,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    if (widget.isActive) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant _AnimatedMetricCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          String displayValue;
          if (widget.decimalPlaces > 0) {
            displayValue = _animation.value.toStringAsFixed(
              widget.decimalPlaces,
            );
          } else {
            int intVal = _animation.value.round();
            if (intVal >= 1000) {
              String raw = intVal.toString();
              displayValue =
                  "${raw.substring(0, raw.length - 3)},${raw.substring(raw.length - 3)}";
            } else {
              displayValue = intVal.toString();
            }
          }

          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$displayValue${widget.suffix}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: widget.valueColor ?? const Color(0xFFF47B20),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF5B6270),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: widget.iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: widget.iconColor, size: 16),
              ),
            ],
          );
        },
      ),
    );
  }
}


