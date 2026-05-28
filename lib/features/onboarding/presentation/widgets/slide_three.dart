import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_helpers.dart';

class SlideThree extends StatefulWidget {
  final bool isActive;
  final double pageOffset;
  final double screenWidth;

  const SlideThree({
    super.key,
    required this.isActive,
    required this.pageOffset,
    required this.screenWidth,
  });

  @override
  State<SlideThree> createState() => _SlideThreeState();
}

class _SlideThreeState extends State<SlideThree>
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
      'url': 'assets/onboarding/therapist_bhoomi.jpg',
      'exp': '11+ Years',
    },
    {
      'name': 'Atharva Ghorpade',
      'url': 'assets/onboarding/therapist_atharva.png',
      'exp': '5+ Years',
    },
    {
      'name': 'Sharvari Rane',
      'url': 'assets/onboarding/therapist_sharvari.jpg',
      'exp': '2+ Years',
    },
    {
      'name': 'Maithili Joshi',
      'url': 'assets/onboarding/therapist_maithili.jpeg',
      'exp': '20+ Years',
    },
    {
      'name': 'Pavitra Madhav',
      'url': 'assets/onboarding/therapist_pavitra.jpg',
      'exp': '4+ Years',
    },
    {
      'name': 'Tanya Chawda',
      'url': 'assets/onboarding/therapist_tanya.jpeg',
      'exp': '7+ Years',
    },
    {
      'name': 'Alia S',
      'url': 'assets/onboarding/therapist_alia.png',
      'exp': '3+ Years',
    },
    {
      'name': 'Mary Eliza',
      'url': 'assets/onboarding/therapist_mary.jpeg',
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
  void didUpdateWidget(covariant SlideThree oldWidget) {
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
          return Expanded(
            child: Row(
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item['title'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0D0F1A),
                        ),
                      ),
                      Text(
                        item['sub'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 8,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                  child: buildAssetImage(
                    data['url']!,
                    fit: BoxFit.cover,
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
        final emoji = specialtyIcons[name] ?? '✨';
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
