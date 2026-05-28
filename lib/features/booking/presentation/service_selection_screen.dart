/// File: service_selection_screen.dart
/// Purpose: High-fidelity "choose your care type" screen for Zenup Health.
/// Appears immediately after splash and onboarding.
library features;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../app/theme/app_typography.dart';

// ── Therapy card image URLs ──
// Using direct WordPress CDN URLs; images are pre-cached on screen entry.
const List<String> _serviceSelectionImageUrls = [
  'https://zenuphealth.com/wp-content/uploads/2025/12/Gemini_Generated_Image_kmaauqkmaauqkmaa.png',
  'https://zenuphealth.com/wp-content/uploads/2025/12/Gemini_Generated_Image_8mz4h38mz4h38mz4-1.png',
  'https://zenuphealth.com/wp-content/uploads/2025/12/Gemini_Generated_Image_11jezh11jezh11je.png',
];

class ServiceSelectionScreen extends StatefulWidget {
  const ServiceSelectionScreen({super.key});

  @override
  State<ServiceSelectionScreen> createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _headerFadeAnimation;
  late Animation<double> _headerSlideAnimation;

  late List<Animation<double>> _cardFadeAnimations;
  late List<Animation<double>> _cardSlideAnimations;
  bool _didPrecacheImages = false;

  @override
  void initState() {
    super.initState();
    // 700ms total duration accommodates the stagger perfectly
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Header fades & slides up ~12px over 300ms
    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 300 / 700, curve: Curves.easeOut),
      ),
    );
    _headerSlideAnimation = Tween<double>(begin: 12.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 300 / 700, curve: Curves.easeOut),
      ),
    );

    // Cards stagger-fade-in sequentially (80ms offset each, 300ms duration per card)
    // Card 0: 80ms to 380ms
    // Card 1: 160ms to 460ms
    // Card 2: 240ms to 540ms
    _cardFadeAnimations = List.generate(3, (index) {
      final start = (80 * (index + 1)) / 700;
      final end = (80 * (index + 1) + 300) / 700;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: Interval(
            start.clamp(0.0, 1.0),
            end.clamp(0.0, 1.0),
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    _cardSlideAnimations = List.generate(3, (index) {
      final start = (80 * (index + 1)) / 700;
      final end = (80 * (index + 1) + 300) / 700;
      return Tween<double>(begin: 12.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: Interval(
            start.clamp(0.0, 1.0),
            end.clamp(0.0, 1.0),
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    _entryController.forward();

    // Kick off image pre-caching immediately in initState so images are
    // ready before the cards animate into view (no context needed for
    // CachedNetworkImageProvider — only precacheImage needs context).
    _warmImageCache();
  }

  /// Warms the CachedNetworkImage disk + memory cache for all therapy card
  /// images. Called in initState so caching starts before the first frame.
  void _warmImageCache() {
    for (final url in _serviceSelectionImageUrls) {
      // Prime the disk cache immediately (no context required).
      CachedNetworkImageProvider(
        url,
        cacheKey: url,
      ).resolve(const ImageConfiguration());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrecacheImages) return;
    _didPrecacheImages = true;
    // Also call Flutter's precacheImage so the decoded bitmap is in the
    // image cache — this eliminates the decode-on-first-paint jank.
    for (final url in _serviceSelectionImageUrls) {
      unawaited(
        precacheImage(
          CachedNetworkImageProvider(url, cacheKey: url),
          context,
        ).catchError((_) {}),
      );
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double sidePadding = screenWidth > 360 ? 24.0 : 20.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: sidePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),

                    // ── A. Pill Badge ──
                    AnimatedBuilder(
                      animation: _entryController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _headerFadeAnimation.value,
                          child: Transform.translate(
                            offset: Offset(0, _headerSlideAnimation.value),
                            child: child,
                          ),
                        );
                      },
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.auto_awesome, // Sparkle icon
                                color: Color(0xFFF47B20),
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'FIND YOUR INNER PEACE',
                                style: AppTypography.labelSmall.copyWith(
                                  color: const Color(0xFFF47B20),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  letterSpacing: 0.08 * 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── B. Headline ──
                    AnimatedBuilder(
                      animation: _entryController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _headerFadeAnimation.value,
                          child: Transform.translate(
                            offset: Offset(0, _headerSlideAnimation.value),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Feeling overwhelmed, anxious or just',
                            textAlign: TextAlign.center,
                            style: AppTypography.headlineLargeMobile.copyWith(
                              color: const Color(0xFF1A2233),
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth > 360 ? 28 : 24,
                              height: 1.15,
                            ),
                          ),
                          Text(
                            'not yourself?',
                            textAlign: TextAlign.center,
                            style: AppTypography.headlineLargeMobile.copyWith(
                              color: const Color(0xFFF47B20),
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth > 360 ? 28 : 24,
                              height: 1.15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── C. Subtext ──
                    AnimatedBuilder(
                      animation: _entryController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _headerFadeAnimation.value,
                          child: Transform.translate(
                            offset: Offset(0, _headerSlideAnimation.value),
                            child: child,
                          ),
                        );
                      },
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 540),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: AppTypography.bodyMedium.copyWith(
                                color: const Color(0xFF6B7280),
                                fontSize: 15,
                                height: 1.5,
                              ),
                              children: const [
                                TextSpan(text: 'Get matched with a '),
                                TextSpan(
                                  text: 'licensed expert',
                                  style: TextStyle(
                                    color: Color(0xFF1A2233),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: ' who '),
                                TextSpan(
                                  text: 'actually understands you',
                                  style: TextStyle(
                                    color: Color(0xFF1A2233),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '. Personalized mental healthcare - ',
                                ),
                                TextSpan(
                                  text: 'online, confidential, and affordable',
                                  style: TextStyle(
                                    color: Color(0xFF1A2233),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: '.'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── D. The 3 Service Cards ──
                    ServiceCardWidget(
                      title: 'Individual Therapy',
                      icon: Icons.person_outline_rounded,
                      buttonLabel: 'BOOK SESSION',
                      imageUrl: _serviceSelectionImageUrls[0],
                      onTap: () {}, // Placeholder click action
                      entryFade: _cardFadeAnimations[0],
                      entrySlide: _cardSlideAnimations[0],
                    ),
                    ServiceCardWidget(
                      title: 'Couples Therapy',
                      icon: Icons.people_outline_rounded,
                      buttonLabel: 'BOOK SESSION',
                      imageUrl: _serviceSelectionImageUrls[1],
                      onTap: () {}, // Placeholder click action
                      entryFade: _cardFadeAnimations[1],
                      entrySlide: _cardSlideAnimations[1],
                      imageAlignment: const Alignment(
                        0,
                        -0.3,
                      ), // Move image slightly to bottom to show people properly
                    ),
                    ServiceCardWidget(
                      title: 'Psychiatric Consultation',
                      icon: Icons.medical_services_outlined,
                      buttonLabel: 'BOOK CONSULTATION',
                      imageUrl: _serviceSelectionImageUrls[2],
                      onTap: () {}, // Placeholder click action
                      entryFade: _cardFadeAnimations[2],
                      entrySlide: _cardSlideAnimations[2],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ServiceCardWidget extends StatefulWidget {
  final String title;
  final IconData icon;
  final String buttonLabel;
  final String imageUrl;
  final VoidCallback onTap;
  final Alignment imageAlignment;
  final Animation<double> entryFade;
  final Animation<double> entrySlide;

  const ServiceCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.buttonLabel,
    required this.imageUrl,
    required this.onTap,
    required this.entryFade,
    required this.entrySlide,
    this.imageAlignment = Alignment.center,
  });

  @override
  State<ServiceCardWidget> createState() => _ServiceCardWidgetState();
}

class _ServiceCardWidgetState extends State<ServiceCardWidget>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.entryFade, widget.entrySlide]),
      builder: (context, child) {
        return Opacity(
          opacity: widget.entryFade.value,
          child: Transform.translate(
            offset: Offset(0, widget.entrySlide.value),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _pressController.forward();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _pressController.reverse();
          widget.onTap();
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _pressController.reverse();
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 380, // Portrait aspect ratio (~4:5)
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: _isPressed ? 0.12 : 0.06,
                  ),
                  blurRadius: _isPressed ? 32 : 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: [
                  // 1. Cover Image
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      cacheKey: widget.imageUrl,
                      fit: BoxFit.cover,
                      alignment: widget.imageAlignment,
                      memCacheWidth: 800,
                      maxWidthDiskCache: 1200,
                      fadeInDuration: const Duration(milliseconds: 200),
                      fadeOutDuration: Duration.zero,
                      placeholderFadeInDuration: Duration.zero,
                      useOldImageOnUrlChange: true,
                      imageBuilder: (context, imageProvider) => Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        alignment: widget.imageAlignment,
                        gaplessPlayback: true,
                        filterQuality: FilterQuality.medium,
                      ),
                      placeholder: (context, url) => _TherapyCardPlaceholder(
                        alignment: widget.imageAlignment,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: const Color(0xFFFFF1E6),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Color(0xFFF47B20),
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 2. Dark Overlay Gradient transparent -> rgba(20,18,16,0.75) bottom 45%
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color.fromRGBO(20, 18, 16, 0.75),
                          ],
                          stops: [0.55, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // 3. Content bottom-left
                  Positioned(
                    left: 20,
                    bottom: 24,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: -0.2,
                                fontFamily: AppTypography.fontFamily,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(widget.icon, color: Colors.white, size: 18),
                          ],
                        ),
                        const SizedBox(height: 12),
                        AnimatedCardButton(
                          label: widget.buttonLabel,
                          onTap: widget.onTap,
                        ),
                      ],
                    ),
                  ),

                  // 4. Thin solid orange accent bar along the very bottom edge of the card
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 4,
                    child: Container(color: const Color(0xFFF47B20)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedCardButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const AnimatedCardButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  State<AnimatedCardButton> createState() => _AnimatedCardButtonState();
}

class _AnimatedCardButtonState extends State<AnimatedCardButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color orangeColor = Color(0xFFF47B20);
    const Color darkOrangeColor = Color(0xFFE06A12);

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _isPressed ? darkOrangeColor : orangeColor,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.05,
              fontFamily: AppTypography.fontFamily,
            ),
          ),
        ),
      ),
    );
  }
}

class _TherapyCardPlaceholder extends StatelessWidget {
  final Alignment alignment;

  const _TherapyCardPlaceholder({
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFF1E6),
      alignment: alignment,
      child: const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            color: Color(0xFFF47B20),
            strokeWidth: 2.5,
          ),
        ),
      ),
    );
  }
}
