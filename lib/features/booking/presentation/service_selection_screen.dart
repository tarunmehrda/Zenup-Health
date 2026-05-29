/// File: service_selection_screen.dart
/// Purpose: High-fidelity "choose your care type" screen for Zenup Health.
/// Appears immediately after splash and onboarding.
library features;

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/extensions/context_extensions.dart';


// ── Therapy card image assets ──
const List<String> _serviceSelectionAssets = [
  'assets/booking/booking_individual.png',
  'assets/booking/booking_couples.png',
  'assets/booking/booking_psychiatric.png',
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

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrecacheImages) return;
    _didPrecacheImages = true;
    // Call Flutter's precacheImage for local assets to avoid paint latency.
    for (final asset in _serviceSelectionAssets) {
      unawaited(
        precacheImage(
          AssetImage(asset),
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
                      icon: Icons.person_rounded,
                      buttonLabel: 'BOOK SESSION',
                      imagePath: _serviceSelectionAssets[0],
                      description: 'One-on-one therapy sessions tailored to your concerns and goals.',
                      tags: const [
                        'RCI-registered Experts',
                        'Personalised Care',
                        'Evidence-based',
                        '100% Confidential',
                        'Flexible Online Sessions',
                        'Trauma & Grief',
                        'Anxiety & Stress',
                        'Safe Supportive Space',
                      ],
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Individual Therapy booking coming soon!'),
                            backgroundColor: Color(0xFFF47B20),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      entryFade: _cardFadeAnimations[0],
                      entrySlide: _cardSlideAnimations[0],
                    ),
                    ServiceCardWidget(
                      title: 'Couples Therapy',
                      icon: Icons.people_rounded,
                      buttonLabel: 'BOOK SESSION',
                      imagePath: _serviceSelectionAssets[1],
                      description: 'Therapy sessions designed for partners who want to work on their relationship together.',
                      tags: const [
                        'Trained Practitioners',
                        'Build Trust',
                        'Conflict Resolution',
                        'Evidence-based',
                        'Neutral Space',
                        'Strengthen Connections',
                        'Improve Communication',
                      ],
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Couples Therapy booking coming soon!'),
                            backgroundColor: Color(0xFFF47B20),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      entryFade: _cardFadeAnimations[1],
                      entrySlide: _cardSlideAnimations[1],
                      imageAlignment: const Alignment(
                        0,
                        -0.7,
                      ), // Move image slightly to bottom to show people properly
                    ),
                    ServiceCardWidget(
                      title: 'Psychiatric Consultation',
                      icon: Icons.medical_services_rounded,
                      buttonLabel: 'BOOK CONSULTATION',
                      imagePath: _serviceSelectionAssets[2],
                      description: 'One-on-one consultations with an MD Psychiatrist for clinical assessment and medication support.',
                      tags: const [
                        'MD Psychiatrist',
                        'Clinical Assessment',
                        'Medication Management',
                        'Confidential Online',
                        'Personalized Plan',
                        'Comprehensive Evaluation',
                      ],
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Psychiatric Consultation booking coming soon!'),
                            backgroundColor: Color(0xFFF47B20),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
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
  final String imagePath;
  final String description;
  final List<String> tags;
  final VoidCallback onTap;
  final Alignment imageAlignment;
  final Animation<double> entryFade;
  final Animation<double> entrySlide;

  const ServiceCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.buttonLabel,
    required this.imagePath,
    required this.description,
    required this.tags,
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
  bool _showDetails = false;
  late AnimationController _detailsController;

  @override
  void initState() {
    super.initState();
    _detailsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 375),
    );
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.entryFade, widget.entrySlide, _detailsController]),
      builder: (context, _) {
        final double height = Tween<double>(begin: 260.0, end: 500.0)
            .animate(CurvedAnimation(
              parent: _detailsController,
              curve: Curves.fastOutSlowIn,
            ))
            .value;
        final double blurValue = Tween<double>(begin: 0.0, end: 8.0)
            .animate(CurvedAnimation(
              parent: _detailsController,
              curve: Curves.easeInOut,
            ))
            .value;

        return Opacity(
          opacity: widget.entryFade.value,
          child: Transform.translate(
            offset: Offset(0, widget.entrySlide.value),
            child: GestureDetector(
              onTap: () {
                if (_showDetails) {
                  _detailsController.reverse();
                } else {
                  _detailsController.forward();
                }
                setState(() {
                  _showDetails = !_showDetails;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_showDetails ? 0.12 : 0.06),
                      blurRadius: _showDetails ? 32 : 24,
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
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
                          child: Image.asset(
                            widget.imagePath,
                            fit: BoxFit.cover,
                            alignment: widget.imageAlignment,
                            gaplessPlayback: true,
                            filterQuality: FilterQuality.medium,
                          ),
                        ),
                      ),

                      // 2. Dark Overlay Gradient
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.1 + (0.35 * _detailsController.value)),
                                Colors.black.withOpacity(0.75 + (0.1 * _detailsController.value)),
                              ],
                              stops: const [0.4, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // 3. Collapsed View Content
                      if (_detailsController.value < 1.0)
                        Positioned(
                          left: 20,
                          bottom: 24,
                          right: 20,
                          child: Opacity(
                            opacity: 1.0 - _detailsController.value,
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
                                        fontSize: 22,
                                        letterSpacing: -0.4,
                                        fontFamily: AppTypography.fontFamily,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(widget.icon, color: Colors.white, size: 20),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(
                                      'Tap to view details & features',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.75),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: AppTypography.fontFamily,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white.withOpacity(0.75),
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                      // 4. Expanded View Content
                      if (_detailsController.value > 0.0)
                        Positioned(
                          left: 20,
                          top: 24,
                          right: 20,
                          bottom: 24,
                          child: Opacity(
                            opacity: _detailsController.value,
                            child: Transform.translate(
                              offset: Offset(0, 15.0 * (1.0 - _detailsController.value)),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: height - 48,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  widget.title,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 24,
                                                    letterSpacing: -0.5,
                                                    fontFamily: AppTypography.fontFamily,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Icon(
                                                widget.icon,
                                                color: const Color(0xFFF47B20),
                                                size: 26,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            widget.description,
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.9),
                                              fontSize: 14.5,
                                              height: 1.45,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: AppTypography.fontFamily,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: widget.tags.map((tag) => Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.12),
                                                borderRadius: BorderRadius.circular(50),
                                                border: Border.all(
                                                  color: Colors.white.withOpacity(0.25),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                tag,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: AppTypography.fontFamily,
                                                ),
                                              ),
                                            )).toList(),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const SizedBox(height: 16),
                                          AnimatedCardButton(
                                            label: widget.buttonLabel,
                                            onTap: widget.onTap,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      // 5. Thin solid orange accent bar along the very bottom edge of the card
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
      },
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
          height: 48,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _isPressed ? darkOrangeColor : orangeColor,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: orangeColor.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
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
