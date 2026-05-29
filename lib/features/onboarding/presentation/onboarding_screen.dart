/// File: onboarding_screen.dart
/// Purpose: Redesigned premium Welcome Screen for Zenup Health.
/// Center hero is now two avatars *walking and talking* (a short, looping,
/// positive mental-health conversation) with speech bubbles above their heads.
/// Arms/hands stay still — only legs (walk cycle), body bob and mouths animate.
library features;

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/constants/app_constants.dart';

/// Single source of truth for the brand orange.
const Color kOrange = Color(0xFFFF6B1A);
const Color kOrangeLight = Color(0xFFFF8C42);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  // ── Animation Controllers ──
  late AnimationController _walkController; // leg swing + body bob
  late AnimationController _talkController; // mouth open/close
  late AnimationController _auraController;  // soft breathing glow

  late Animation<double> _auraScale;
  late Animation<double> _auraOpacity;

  // ── Conversation state ──
  // speaker: 0 = left avatar, 1 = right avatar, -1 = nobody (brief gap).
  int _activeSpeaker = -1;
  String _currentLine = '';
  int _convoIndex = 0;
  Timer? _convoTimer;

  // Short, looping, positive mental-health exchange.
  static const List<_ConvoLine> _conversation = [
    _ConvoLine(0, "Rough week, huh?", 2400),
    _ConvoLine(1, "Yeah… some days feel heavier.", 2600),
    _ConvoLine(0, "You're not alone in this.", 2400),
    _ConvoLine(1, "Talking already helps a little.", 2600),
    _ConvoLine(0, "One step at a time \u2014 you've got this \ud83e\udde1", 2900),
  ];

  @override
  void initState() {
    super.initState();

    // Walk cycle (one full stride loop).
    _walkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();

    // Mouth movement while a character is speaking.
    _talkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..repeat();

    // Gentle orange breathing aura behind the avatars.
    _auraController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    )..repeat(reverse: true);

    _auraScale = Tween<double>(begin: 0.95, end: 1.12).animate(
      CurvedAnimation(parent: _auraController, curve: Curves.easeInOut),
    );
    _auraOpacity = Tween<double>(begin: 0.05, end: 0.16).animate(
      CurvedAnimation(parent: _auraController, curve: Curves.easeInOut),
    );

    // Kick off the looping conversation after the first frame.
    _convoTimer = Timer(const Duration(milliseconds: 600), _runConvoStep);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
  }

  void _runConvoStep() {
    if (!mounted) return;
    final line = _conversation[_convoIndex];
    setState(() {
      _activeSpeaker = line.speaker;
      _currentLine = line.text;
    });
    _convoTimer = Timer(Duration(milliseconds: line.durationMs), () {
      _convoIndex = (_convoIndex + 1) % _conversation.length;
      _runConvoStep();
    });
  }

  @override
  void dispose() {
    _convoTimer?.cancel();
    _walkController.dispose();
    _talkController.dispose();
    _auraController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding(String targetRoute) async {
    try {
      final box = Hive.box('settings');
      await box.put('onboarding_complete', true);
    } catch (_) {}
    if (mounted) {
      context.go(targetRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    const Color textPrimary = Color(0xFF1A2233);
    const Color textSecondary = Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),

                    // ── TOP SECTION: Branding & Headings ──
                    Center(
                      child: Image.asset(
                        AppConstants.zenupIconPng,
                        width: 72,
                        height: 72,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.spa_rounded,
                          color: kOrange,
                          size: 72,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your Mental Wellness\nJourney Starts Here',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: screenWidth > 360 ? 30 : 26,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                        letterSpacing: -0.6,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'Connect with licensed therapists, book sessions, and access professional support anytime, anywhere.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: screenWidth > 360 ? 14.5 : 13.5,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          fontFamily: AppTypography.fontFamily,
                        ),
                      ),
                    ),

                    // ── CENTER SECTION: Two avatars walking & talking ──
                    Expanded(
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 24.0),
                          height: 280,
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              // A. Soft breathing orange aura
                              AnimatedBuilder(
                                animation: _auraController,
                                builder: (context, _) {
                                  return Transform.scale(
                                    scale: _auraScale.value,
                                    child: Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            kOrange.withOpacity(
                                                _auraOpacity.value),
                                            kOrange.withOpacity(0.0),
                                          ],
                                          stops: const [0.2, 1.0],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),

                              // B. The walking + talking avatars
                              Positioned.fill(
                                child: AnimatedBuilder(
                                  animation: Listenable.merge(
                                      [_walkController, _talkController]),
                                  builder: (context, _) {
                                    return CustomPaint(
                                      painter: WalkingAvatarsPainter(
                                        walk: _walkController.value,
                                        talk: _talkController.value,
                                        activeSpeaker: _activeSpeaker,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // C. Speech bubble — LEFT avatar
                              Align(
                                alignment: const Alignment(-0.34, -0.62),
                                child: _SpeechBubble(
                                  text: _currentLine,
                                  visible: _activeSpeaker == 0,
                                ),
                              ),

                              // D. Speech bubble — RIGHT avatar
                              Align(
                                alignment: const Alignment(0.34, -0.62),
                                child: _SpeechBubble(
                                  text: _currentLine,
                                  visible: _activeSpeaker == 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ── BOTTOM SECTION: Call to Action ──
                    const SizedBox(height: 12),
                    AnimatedCTAButton(
                      label: 'Get Started',
                      onTap: () => _completeOnboarding(AppRoutes.authSignup),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            color: textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppTypography.fontFamily,
                          ),
                          children: [
                            const TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Sign In',
                              style: const TextStyle(
                                color: kOrange,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap =
                                    () => _completeOnboarding(AppRoutes.authLogin),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
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

/// Plain model for a single line of dialogue.
class _ConvoLine {
  final int speaker; // 0 = left, 1 = right
  final String text;
  final int durationMs;
  const _ConvoLine(this.speaker, this.text, this.durationMs);
}

/// Orange speech bubble that pops in above an avatar's head with a downward tail.
class _SpeechBubble extends StatelessWidget {
  final String text;
  final bool visible;

  const _SpeechBubble({required this.text, required this.visible});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedScale(
        scale: visible ? 1.0 : 0.7,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutBack,
        child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 240),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: kOrange,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: kOrange.withOpacity(0.30),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    fontFamily: AppTypography.fontFamily,
                  ),
                ),
              ),
              // Tail
              Transform.translate(
                offset: const Offset(0, -3),
                child: Transform.rotate(
                  angle: math.pi / 4,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: kOrange,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Draws two front-facing avatars with a walk cycle (swinging legs + body bob)
/// and a talking mouth for the active speaker. Arms/hands are intentionally static.
class WalkingAvatarsPainter extends CustomPainter {
  final double walk; // 0..1
  final double talk; // 0..1
  final int activeSpeaker; // 0 left, 1 right, -1 none

  WalkingAvatarsPainter({
    required this.walk,
    required this.talk,
    required this.activeSpeaker,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double baseY = size.height * 0.80;

    // Ground shadows
    final shadowPaint = Paint()..color = kOrange.withOpacity(0.10);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx - 52, baseY + 4), width: 46, height: 10),
      shadowPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx + 52, baseY + 4), width: 46, height: 10),
      shadowPaint,
    );

    // LEFT avatar
    _drawAvatar(
      canvas,
      cx: cx - 52,
      baseY: baseY,
      phase: walk,
      shirt: kOrange,
      pants: const Color(0xFFC2410C),
      hair: const Color(0xFF4A2C1A),
      skin: const Color(0xFFF6C9A8),
      talking: activeSpeaker == 0,
    );

    // RIGHT avatar (offset stride so they're not perfectly in sync)
    _drawAvatar(
      canvas,
      cx: cx + 52,
      baseY: baseY,
      phase: (walk + 0.5) % 1.0,
      shirt: kOrangeLight,
      pants: const Color(0xFF9A4513),
      hair: const Color(0xFF2E1C12),
      skin: const Color(0xFFECC49A),
      talking: activeSpeaker == 1,
    );
  }

  void _drawAvatar(
    Canvas c, {
    required double cx,
    required double baseY,
    required double phase,
    required Color shirt,
    required Color pants,
    required Color hair,
    required Color skin,
    required bool talking,
  }) {
    final double ph = phase * 2 * math.pi;
    final double bob = -2.5 * math.sin(ph).abs(); // gentle up-bob
    final double legSwing = math.sin(ph) * 9;

    final double hipY = baseY - 52 + bob;
    final double shouldersY = baseY - 98 + bob;

    // ── Legs (walk cycle) ──
    final double footAx = cx - 6 + legSwing;
    final double footAy = baseY + bob - (legSwing > 0 ? legSwing * 0.35 : 0);
    final double footBx = cx + 6 - legSwing;
    final double footBy = baseY + bob - (legSwing < 0 ? -legSwing * 0.35 : 0);

    final legPaint = Paint()
      ..color = pants
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    c.drawLine(Offset(cx - 4, hipY), Offset(footAx, footAy), legPaint);
    c.drawLine(Offset(cx + 4, hipY), Offset(footBx, footBy), legPaint);

    final shoePaint = Paint()..color = const Color(0xFF5E3A1E);
    c.drawCircle(Offset(footAx, footAy), 4.2, shoePaint);
    c.drawCircle(Offset(footBx, footBy), 4.2, shoePaint);

    // ── Arms (STATIC — no movement) ──
    final armPaint = Paint()
      ..color = shirt
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    c.drawLine(Offset(cx - 13, shouldersY + 4), Offset(cx - 17, hipY - 2), armPaint);
    c.drawLine(Offset(cx + 13, shouldersY + 4), Offset(cx + 17, hipY - 2), armPaint);
    final handPaint = Paint()..color = skin;
    c.drawCircle(Offset(cx - 17, hipY), 3.5, handPaint);
    c.drawCircle(Offset(cx + 17, hipY), 3.5, handPaint);

    // ── Torso ──
    final bodyPath = Path()
      ..moveTo(cx - 14, shouldersY)
      ..quadraticBezierTo(cx, shouldersY - 3, cx + 14, shouldersY)
      ..lineTo(cx + 11, hipY + 2)
      ..quadraticBezierTo(cx, hipY + 8, cx - 11, hipY + 2)
      ..close();
    c.drawPath(bodyPath, Paint()..color = shirt);

    // ── Neck ──
    c.drawRect(
      Rect.fromLTWH(cx - 3, shouldersY - 10, 6, 12),
      Paint()..color = skin,
    );

    // ── Head ──
    final headC = Offset(cx, shouldersY - 22);
    c.drawCircle(headC, 16, Paint()..color = skin);

    // Hair (top cap)
    c.drawArc(
      Rect.fromCircle(center: headC, radius: 16.5),
      math.pi,
      math.pi,
      true,
      Paint()..color = hair,
    );

    // Eyes
    final eyePaint = Paint()..color = const Color(0xFF3A2415);
    c.drawCircle(Offset(headC.dx - 5, headC.dy - 1), 2.0, eyePaint);
    c.drawCircle(Offset(headC.dx + 5, headC.dy - 1), 2.0, eyePaint);

    // Cheeks
    final cheekPaint = Paint()..color = const Color(0xFFF3A98A).withOpacity(0.5);
    c.drawCircle(Offset(headC.dx - 8, headC.dy + 4), 2.6, cheekPaint);
    c.drawCircle(Offset(headC.dx + 8, headC.dy + 4), 2.6, cheekPaint);

    // Mouth: animated open while talking, gentle smile otherwise
    if (talking) {
      final double open = (0.5 + 0.5 * math.sin(talk * 2 * math.pi)).clamp(0.0, 1.0);
      final double mh = 1.6 + open * 3.6;
      c.drawOval(
        Rect.fromCenter(
            center: Offset(headC.dx, headC.dy + 7), width: 7, height: mh),
        Paint()..color = const Color(0xFF7A3B1A),
      );
    } else {
      final smile = Path()
        ..moveTo(headC.dx - 5, headC.dy + 6)
        ..quadraticBezierTo(headC.dx, headC.dy + 10, headC.dx + 5, headC.dy + 6);
      c.drawPath(
        smile,
        Paint()
          ..color = const Color(0xFFB5663C)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WalkingAvatarsPainter oldDelegate) {
    return oldDelegate.walk != walk ||
        oldDelegate.talk != talk ||
        oldDelegate.activeSpeaker != activeSpeaker;
  }
}

// ── Custom Stateful CTA Button featuring press scaling & modern glow shadow ──
class AnimatedCTAButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const AnimatedCTAButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  State<AnimatedCTAButton> createState() => _AnimatedCTAButtonState();
}

class _AnimatedCTAButtonState extends State<AnimatedCTAButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: 56,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [kOrange, kOrangeLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: kOrange.withOpacity(_isPressed ? 0.25 : 0.38),
                blurRadius: _isPressed ? 14 : 20,
                offset: Offset(0, _isPressed ? 4 : 8),
              ),
            ],
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
              fontFamily: AppTypography.fontFamily,
            ),
          ),
        ),
      ),
    );
  }
}