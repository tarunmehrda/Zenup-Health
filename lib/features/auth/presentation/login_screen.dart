// File: login_screen.dart
// Purpose: Unified single-page Authentication Screen for Zenup Health with seamless transitions,
// warm aesthetics, and premium animations.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/router/app_routes.dart';
import '../../../core/utils/validators.dart';
import '../../../app/theme/app_colors.dart';
import '../domain/auth_notifier.dart';
import 'widgets/auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  final bool startInSignupMode;
  const LoginScreen({super.key, this.startInSignupMode = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  // Login controllers
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  // Signup controllers
  final _signupNameController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPhoneController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _signupConfirmPasswordController = TextEditingController();

  final _authNotifier = AuthNotifier();
  bool _isLogin = true;
  bool _isEmailLogin = true;

  // Entrance animation controllers
  late final AnimationController _entranceController;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _headerOpacity;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _formOpacity;
  late final Animation<double> _footerOpacity;

  // Affirmation cycle state
  Timer? _affirmationTimer;
  int _affirmationIndex = 0;

  final List<String> _loginAffirmations = [
    "we're glad you're here again.",
    "take a slow breath, we're ready when you are.",
    "this space is yours.",
    "you are safe here.",
  ];

  final List<String> _signupAffirmations = [
    "your journey to peace begins here.",
    "take a slow breath, let's create your space.",
    "everything you share here is private.",
    "you are in control of your space.",
  ];

  @override
  void initState() {
    super.initState();
    _isLogin = !widget.startInSignupMode;

    // Staggered entrance animations
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.33, curve: Curves.easeOut),
      ),
    );

    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.20, 0.60, curve: Curves.easeOut),
      ),
    );

    _headerSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.20, 0.60, curve: Curves.easeOut),
      ),
    );

    _formOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.40, 0.80, curve: Curves.easeOut),
      ),
    );

    _footerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
      ),
    );

    _entranceController.forward();

    // Affirmation cycle timer (6 seconds cross-fade)
    _affirmationTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (mounted) {
        setState(() {
          final list = _isLogin ? _loginAffirmations : _signupAffirmations;
          _affirmationIndex = (_affirmationIndex + 1) % list.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _signupNameController.dispose();
    _signupEmailController.dispose();
    _signupPhoneController.dispose();
    _signupPasswordController.dispose();
    _signupConfirmPasswordController.dispose();
    _authNotifier.dispose();
    _entranceController.dispose();
    _affirmationTimer?.cancel();
    super.dispose();
  }

  void _onLogin() async {
    if (_loginFormKey.currentState!.validate()) {
      final loginInput = _isEmailLogin ? _emailController.text : _phoneController.text;
      final success = await _authNotifier.login(
        loginInput,
        _passwordController.text,
      );
      if (mounted) {
        if (success) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        } else {
          _showError(_authNotifier.errorMessage ?? 'Authentication failed');
        }
      }
    }
  }

  void _onSignup() async {
    if (_signupFormKey.currentState!.validate()) {
      if (_signupPasswordController.text != _signupConfirmPasswordController.text) {
        _showError('passwords do not match');
        return;
      }

      final success = await _authNotifier.register(
        _signupNameController.text,
        _signupEmailController.text,
        _signupPasswordController.text,
      );
      if (mounted) {
        if (success) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.profileSetup);
        } else {
          _showError(_authNotifier.errorMessage ?? 'Registration failed');
        }
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.dmSans(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFD49494),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  int _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0;
    int score = 0;
    if (password.length >= 6) score++;
    if (password.length >= 8) score++;
    if (RegExp(r'[a-zA-Z]').hasMatch(password) && RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$&*~]').hasMatch(password) && password.length >= 10) score++;
    return score;
  }

  Widget _buildPasswordStrengthBar() {
    final strength = _calculatePasswordStrength(_signupPasswordController.text);
    
    Color getStrengthColor(int index) {
      if (index >= strength) return const Color(0xFFE5DDD2).withValues(alpha: 0.5);
      switch (strength) {
        case 1:
          return const Color(0xFFD49494);
        case 2:
          return const Color(0xFFE08B6F);
        case 3:
          return const Color(0xFFA8C4A2);
        case 4:
          return AppColors.primary;
        default:
          return const Color(0xFFE5DDD2);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(
                  left: index == 0 ? 0 : 2,
                  right: index == 3 ? 0 : 2,
                ),
                height: 4,
                decoration: BoxDecoration(
                  color: getStrengthColor(index),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Text(
          'a strong password keeps your space safe.',
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontStyle: FontStyle.italic,
            color: const Color(0xFF8A857F),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginTypeSelector() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF2ECE4).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE5DDD2).withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(3),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = (constraints.maxWidth - 6) / 2;
          return Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                alignment: _isEmailLogin ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  width: tabWidth,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(19),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (!_isEmailLogin) {
                          setState(() {
                            _isEmailLogin = true;
                          });
                        }
                      },
                      child: Center(
                        child: Text(
                          'email address',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _isEmailLogin
                                ? AppColors.primary
                                : const Color(0xFF8A857F),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (_isEmailLogin) {
                          setState(() {
                            _isEmailLogin = false;
                          });
                        }
                      },
                      child: Center(
                        child: Text(
                          'phone number',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: !_isEmailLogin
                                ? AppColors.primary
                                : const Color(0xFF8A857F),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoginForm(double height) {
    return KeyedSubtree(
      key: const ValueKey('login_form'),
      child: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo
            const Center(child: ZenupLogo()),
            const SizedBox(height: 24),

            // Middle Section — Headline and Affirmation
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome back',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.6,
                    color: const Color(0xFF1C1B1B),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 24,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Text(
                      _loginAffirmations[_affirmationIndex],
                      key: ValueKey<int>(_affirmationIndex + 100),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFF8A857F),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Fields
            _buildLoginTypeSelector(),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.05),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _isEmailLogin
                  ? PremiumInputField(
                      key: const ValueKey('email_field'),
                      labelText: 'your email',
                      hintText: 'name@example.com',
                      controller: _emailController,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                    )
                  : PremiumInputField(
                      key: const ValueKey('phone_field'),
                      labelText: 'your phone number',
                      hintText: '10-digit number',
                      controller: _phoneController,
                      prefixIcon: Icons.phone_outlined,
                      prefixText: '+91 ',
                      keyboardType: TextInputType.phone,
                      validator: Validators.validatePhone,
                    ),
            ),
            const SizedBox(height: 16),
            PremiumInputField(
              labelText: 'your password',
              hintText: 'enter your password',
              controller: _passwordController,
              prefixIcon: Icons.lock_outline_rounded,
              isPassword: true,
              validator: Validators.validatePassword,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  // Placeholder for forgot password
                },
                child: Text(
                  'forgot password?',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFE08B6F),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Primary Button
            PremiumButton(
              label: 'continue',
              isLoading: _authNotifier.isLoading,
              suffixIcon: Icons.arrow_forward_rounded,
              onPressed: _onLogin,
            ),
            const SizedBox(height: 16),

            // Socials & Switchers
            _buildCommonFooter(
              promptText: "don't have an account?",
              actionText: "sign up",
              onToggle: () {
                setState(() {
                  _isLogin = false;
                  _affirmationIndex = 0;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupForm(double height) {
    return KeyedSubtree(
      key: const ValueKey('signup_form'),
      child: Form(
        key: _signupFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo
            const Center(child: ZenupLogo()),
            const SizedBox(height: 24),

            // Middle Section — Headline and Affirmation
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Create your space',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.6,
                    color: const Color(0xFF1C1B1B),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 24,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Text(
                      _signupAffirmations[_affirmationIndex],
                      key: ValueKey<int>(_affirmationIndex + 200),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFF8A857F),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Fields
            PremiumInputField(
              labelText: 'your name or nickname',
              hintText: 'how should we call you?',
              controller: _signupNameController,
              prefixIcon: Icons.person_outline_rounded,
              validator: (val) => val == null || val.isEmpty ? 'please tell us your name' : null,
            ),
            const SizedBox(height: 16),
            PremiumInputField(
              labelText: 'your email',
              hintText: 'name@example.com',
              controller: _signupEmailController,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 16),
            PremiumInputField(
              labelText: 'your phone number',
              hintText: '10-digit number',
              controller: _signupPhoneController,
              prefixIcon: Icons.phone_outlined,
              prefixText: '+91 ',
              keyboardType: TextInputType.phone,
              validator: Validators.validatePhone,
            ),
            const SizedBox(height: 16),
            PremiumInputField(
              labelText: 'create a password',
              hintText: 'create a strong password',
              controller: _signupPasswordController,
              prefixIcon: Icons.lock_outline_rounded,
              isPassword: true,
              validator: Validators.validatePassword,
              onChanged: (_) => setState(() {}),
            ),
            _buildPasswordStrengthBar(),
            const SizedBox(height: 16),
            PremiumInputField(
              labelText: 'confirm password',
              hintText: 'repeat your password',
              controller: _signupConfirmPasswordController,
              prefixIcon: Icons.lock_clock_outlined,
              isPassword: true,
              validator: (val) {
                if (val != _signupPasswordController.text) {
                  return 'passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Primary Button
            PremiumButton(
              label: 'continue',
              isLoading: _authNotifier.isLoading,
              suffixIcon: Icons.arrow_forward_rounded,
              onPressed: _onSignup,
            ),
            const SizedBox(height: 16),

            // Socials & Switchers
            _buildCommonFooter(
              promptText: "already have an account?",
              actionText: "log in",
              onToggle: () {
                setState(() {
                  _isLogin = true;
                  _affirmationIndex = 0;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommonFooter({
    required String promptText,
    required String actionText,
    required VoidCallback onToggle,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Divider
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFFE5DDD2).withValues(alpha: 0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF8A857F),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFFE5DDD2).withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Social Sign-In buttons
        Row(
          children: [
            // Google
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Google Sign-In
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.80),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE5DDD2),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(18, 18),
                        painter: GoogleLogoPainter(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Google',
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2C2A28),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Apple
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Apple Sign-In
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF000000),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF000000),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(14, 17),
                        painter: AppleLogoPainter(color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Apple',
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Anonymity Toggle
        GestureDetector(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.masks_outlined,
                size: 14,
                color: Color(0xFF8A857F),
              ),
              const SizedBox(width: 8),
              Text(
                'prefer to stay anonymous? use just a nickname.',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF8A857F),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),

        // Switch Mode Link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              promptText,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF8A857F),
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onToggle,
              child: Text(
                actionText,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Privacy Footer
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              size: 11,
              color: Color(0xFFA8C4A2),
            ),
            const SizedBox(width: 6),
            Text(
              'private and encrypted — always.',
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF8A857F),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const double contentPaddingHorizontal = 24.0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _authNotifier,
          builder: (context, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: contentPaddingHorizontal, vertical: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Form Section (logo is inside each form now)
                        FadeTransition(
                          opacity: _formOpacity,
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOutCubic,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              switchInCurve: Curves.easeInOutCubic,
                              switchOutCurve: Curves.easeInOutCubic,
                              layoutBuilder: (currentChild, previousChildren) {
                                return Stack(
                                  alignment: Alignment.topCenter,
                                  children: <Widget>[
                                    ...previousChildren,
                                    if (currentChild != null) currentChild,
                                  ],
                                );
                              },
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                final isChildLogin = (child.key == const ValueKey('login_form'));
                                final beginOffset = isChildLogin 
                                    ? const Offset(0.0, -0.15) 
                                    : const Offset(0.0, 0.15);
                                
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: beginOffset,
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOutCubic,
                                      ),
                                    ),
                                    child: child,
                                  ),
                                );
                              },
                              child: _isLogin
                                  ? _buildLoginForm(constraints.maxHeight)
                                  : _buildSignupForm(constraints.maxHeight),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
