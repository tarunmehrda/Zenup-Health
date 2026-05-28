import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_helpers.dart';

class SlideFour extends StatefulWidget {
  final bool isActive;
  final double pageOffset;
  final double screenWidth;

  const SlideFour({
    super.key,
    required this.isActive,
    required this.pageOffset,
    required this.screenWidth,
  });

  @override
  State<SlideFour> createState() => _SlideFourState();
}

class _SlideFourState extends State<SlideFour> with TickerProviderStateMixin {
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
  void didUpdateWidget(covariant SlideFour oldWidget) {
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
                                      childAspectRatio: 1.9,
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
                            '${t['location']!} • ${t['service']!}',
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

// ── Metric Count-up Card ──
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: widget.valueColor ?? const Color(0xFFF47B20),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
