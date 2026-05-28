import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import 'onboarding_helpers.dart';

class SlideFive extends StatefulWidget {
  final bool isActive;
  final double pageOffset;
  final double screenWidth;
  final VoidCallback onGetStarted;

  const SlideFive({
    super.key,
    required this.isActive,
    required this.pageOffset,
    required this.screenWidth,
    required this.onGetStarted,
  });

  @override
  State<SlideFive> createState() => _SlideFiveState();
}

class _SlideFiveState extends State<SlideFive> with TickerProviderStateMixin {
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
  void didUpdateWidget(covariant SlideFive oldWidget) {
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
        childAspectRatio: 1.15,
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
