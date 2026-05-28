import 'package:flutter/material.dart';
import 'onboarding_helpers.dart';

class SlideTwo extends StatefulWidget {
  final bool isActive;
  final double pageOffset;
  final double screenWidth;

  const SlideTwo({
    super.key,
    required this.isActive,
    required this.pageOffset,
    required this.screenWidth,
  });

  @override
  State<SlideTwo> createState() => _SlideTwoState();
}

class _SlideTwoState extends State<SlideTwo>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _titleOpacity;
  late Animation<double> _titleTranslation;
  late Animation<double> _subOpacity;

  final List<Map<String, String>> _services = [
    {
      'url': 'assets/onboarding/service_anxiety.png',
      'label': 'Anxiety / Stress',
    },
    {
      'url': 'assets/onboarding/service_depression.png',
      'label': 'Depression',
    },
    {
      'url': 'assets/onboarding/service_adhd.png',
      'label': 'ADHD',
    },
    {
      'url': 'assets/onboarding/service_anger.png',
      'label': 'Anger Issues',
    },
    {
      'url': 'assets/onboarding/service_esteem.png',
      'label': 'Low Self-Esteem',
    },
    {
      'url': 'assets/onboarding/service_relationship.png',
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
  void didUpdateWidget(covariant SlideTwo oldWidget) {
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
                    child: buildAssetImage(
                      url,
                      fit: BoxFit.cover,
                      borderRadius: 16,
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
