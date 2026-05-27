import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../home/presentation/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _glowController;
  late AnimationController _shimmerController;

  // Animation values
  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _logoOpacity;
  late Animation<double> _glowScale;
  
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleOffset;
  late Animation<double> _subtitleOpacity;
  late Animation<Offset> _subtitleOffset;

  late Animation<double> _progressWidth;
  late Animation<double> _shimmerOffset;
  late Animation<double> _splashFadeOut;

  @override
  void initState() {
    super.initState();

    // Main controller for entry and progress (3.8 seconds)
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    );

    // Glow controller for breathing elements (2.2 seconds loop)
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    // Shimmer controller for progress indicator wave (1.8 seconds loop)
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    // 1. Logo Scale Animation (0.0 to 0.45, elastic overshoot)
    _logoScale = Tween<double>(begin: 0.15, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );

    // 1.b Logo Rotation Animation (0.0 to 0.5, spins 1 full turn with bounce)
    _logoRotation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    // 2. Logo Opacity Animation (0.0 to 0.3)
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // 3. Glow breathing scale
    _glowScale = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );

    // 4. Staggered Title Entry (0.35 to 0.6)
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.35, 0.6, curve: Curves.easeIn),
      ),
    );

    _titleOffset = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.35, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // 4.b Staggered Subtitle Entry (0.48 to 0.72)
    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.48, 0.72, curve: Curves.easeIn),
      ),
    );

    _subtitleOffset = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.48, 0.72, curve: Curves.easeOutBack),
      ),
    );

    // 5. Progress Indicator Animation (0.1 to 0.88)
    _progressWidth = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.88, curve: Curves.easeInOutSine),
      ),
    );

    // 5.b Shimmer loop offset (-1.0 to 2.0 to span across progress bar)
    _shimmerOffset = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _shimmerController,
        curve: Curves.linear,
      ),
    );

    // 6. Splash Page Fade Out before transition (0.92 to 1.0)
    _splashFadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.92, 1.0, curve: Curves.easeOut),
      ),
    );

    // Start splash flow
    _mainController.forward().then((_) {
      _navigateToHome();
    });
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 900),
      ),
    );
  }

  @override
  void dispose() {
    _mainController.dispose();
    _glowController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundEnd,
      body: AnimatedBuilder(
        animation: Listenable.merge([_mainController, _glowController, _shimmerController]),
        builder: (context, child) {
          return Opacity(
            opacity: _splashFadeOut.value,
            child: Stack(
              children: [
                // Clean Premium Light Radial Background
                Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.3,
                      colors: [
                        AppColors.lightBackgroundStart,
                        AppColors.lightBackgroundEnd,
                      ],
                    ),
                  ),
                ),

                // Decorative Ambient Color Blob (Top-Left soft purple/indigo)
                Positioned(
                  top: -100,
                  left: -100,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.05 + (0.01 * _glowScale.value)),
                          AppColors.primary.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),

                // Decorative Ambient Color Blob (Bottom-Right soft teal)
                Positioned(
                  bottom: -120,
                  right: -120,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.accent.withValues(alpha: 0.06 + (0.02 * _glowScale.value)),
                          AppColors.accent.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),

                // Ambient halo soft glow behind main logo
                Center(
                  child: Opacity(
                    opacity: _logoOpacity.value * 0.5,
                    child: Transform.scale(
                      scale: _logoScale.value * _glowScale.value,
                      child: Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              blurRadius: 60,
                              spreadRadius: 15,
                            ),
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.08),
                              blurRadius: 40,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Main Logo & Brand Text block
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo (Elastic entry scale & full spin)
                      Opacity(
                        opacity: _logoOpacity.value,
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: Transform.rotate(
                            angle: _logoRotation.value * 2 * 3.1415926535,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(70),
                                child: Image.asset(
                                  AppAssets.zenupIconPng,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: AppColors.lightSurface,
                                      child: const Icon(
                                        Icons.favorite_rounded,
                                        color: AppColors.accent,
                                        size: 60,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),

                      // Staggered Title slide & fade-in
                      Opacity(
                        opacity: _titleOpacity.value,
                        child: FractionalTranslation(
                          translation: _titleOffset.value,
                          child: Text(
                            'ZENUP',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  color: AppColors.lightTextPrimary,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 8,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Staggered Subtitle slide & fade-in
                      Opacity(
                        opacity: _subtitleOpacity.value,
                        child: FractionalTranslation(
                          translation: _subtitleOffset.value,
                          child: Text(
                            'Your Path to Zen Health',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Shimmering capsule progress bar at bottom
                Positioned(
                  bottom: 75,
                  left: 60,
                  right: 60,
                  child: Opacity(
                    opacity: _titleOpacity.value,
                    child: Column(
                      children: [
                        // Glassmorphic pill progress track
                        Container(
                          width: double.infinity,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black.withValues(alpha: 0.02),
                              width: 0.5,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: _progressWidth.value,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    // Progress bar gradient filling
                                    Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primary,
                                            AppColors.accent,
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Repeating shimmer sweep overlay
                                    Positioned.fill(
                                      child: FractionalTranslation(
                                        translation: Offset(_shimmerOffset.value, 0.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.white.withValues(alpha: 0.0),
                                                Colors.white.withValues(alpha: 0.45),
                                                Colors.white.withValues(alpha: 0.0),
                                              ],
                                              stops: const [0.35, 0.5, 0.65],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Initializing Wellness Platform...',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.lightTextSecondary.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
