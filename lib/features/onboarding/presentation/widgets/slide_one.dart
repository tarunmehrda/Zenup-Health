import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import 'onboarding_helpers.dart';

class SlideOne extends StatefulWidget {
  final bool isActive;
  final double pageOffset;
  final double screenWidth;

  const SlideOne({
    super.key,
    required this.isActive,
    required this.pageOffset,
    required this.screenWidth,
  });

  @override
  State<SlideOne> createState() => _SlideOneState();
}

class _SlideOneState extends State<SlideOne>
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
  void didUpdateWidget(covariant SlideOne oldWidget) {
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
                        child: buildAssetImage(
                          'assets/onboarding/onboarding_hero.png',
                          fit: BoxFit.cover,
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
          child: buildTrustBadge(
            Icons.shield_outlined,
            const Color(0xFF00C9A7),
            "100% Confidential",
          ),
        ),
        Opacity(
          opacity: b2,
          child: buildTrustBadge(
            Icons.star_rounded,
            Colors.amber,
            "4.7/5 Rating",
          ),
        ),
        Opacity(
          opacity: b3,
          child: buildTrustBadge(
            Icons.lock_outline_rounded,
            const Color(0xFFF47B20),
            "No Bots. Ever",
          ),
        ),
      ],
    );
  }
}
