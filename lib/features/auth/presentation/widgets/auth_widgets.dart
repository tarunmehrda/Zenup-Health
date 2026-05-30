// File: auth_widgets.dart
// Purpose: Premium reusable UI components and CustomPainters for the authentication screens.


import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';

/// Renders the Zenup abstract branding logo mark and tagline.
class ZenupLogo extends StatelessWidget {
  const ZenupLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppConstants.zenupIconPng,
      width: 100,
      height: 100,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return CustomPaint(
          size: const Size(100, 100),
          painter: ZenupLogoPainter(),
        );
      },
    );
  }
}

/// Painter for the Zenup logo mark - an organic open circle with terracotta-to-teal gradient and a leaf inside.
class ZenupLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Draw open circle arc
    final circlePaint = Paint()
      ..shader = const SweepGradient(
        colors: [
          AppColors.primary,
          AppColors.accent,
          AppColors.primary,
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
      
    // Draw open circle (from -45 degrees to 270 degrees)
    canvas.drawArc(rect.deflate(1.75), -0.8, 5.0, false, circlePaint);
    
    // Draw tiny leaf inside
    final center = Offset(size.width / 2, size.height / 2);
    final path = Path();
    
    path.moveTo(center.dx - 4, center.dy + 8);
    path.quadraticBezierTo(center.dx - 8, center.dy, center.dx, center.dy - 6);
    path.quadraticBezierTo(center.dx + 8, center.dy, center.dx - 4, center.dy + 8);
    path.close();
    
    final leafPaint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(path, leafPaint);
    
    // Draw leaf stem/flowing curve suggesting growth
    final curvePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
      
    final curvePath = Path();
    curvePath.moveTo(center.dx - 8, center.dy + 8);
    curvePath.quadraticBezierTo(center.dx - 3, center.dy + 5, center.dx - 4, center.dy + 8);
    canvas.drawPath(curvePath, curvePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Painter for the multi-colored Google "G" logo.
class GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double r = w / 2;
    final center = Offset(w / 2, h / 2);

    final clipPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: r))
      ..addOval(Rect.fromCircle(center: center, radius: r * 0.6))
      ..fillType = PathFillType.evenOdd;

    canvas.save();
    canvas.clipPath(clipPath);

    // Red sector (top)
    final redPaint = Paint()..color = const Color(0xFFEA4335);
    final redPath = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(center.dx - r * 1.5, center.dy - r * 1.5)
      ..lineTo(center.dx + r * 1.5, center.dy - r * 1.5)
      ..close();
    canvas.drawPath(redPath, redPaint);

    // Yellow sector (left)
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    final yellowPath = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(center.dx - r * 1.5, center.dy - r * 1.5)
      ..lineTo(center.dx - r * 1.5, center.dy + r * 1.5)
      ..close();
    canvas.drawPath(yellowPath, yellowPaint);

    // Green sector (bottom)
    final greenPaint = Paint()..color = const Color(0xFF34A853);
    final greenPath = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(center.dx - r * 1.5, center.dy + r * 1.5)
      ..lineTo(center.dx + r * 1.5, center.dy + r * 1.5)
      ..close();
    canvas.drawPath(greenPath, greenPaint);

    // Blue sector (right)
    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    final bluePath = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(center.dx + r * 1.5, center.dy + r * 1.5)
      ..lineTo(center.dx + r * 1.5, center.dy - r * 1.5)
      ..close();
    canvas.drawPath(bluePath, bluePaint);

    canvas.restore();

    // Blue horizontal bar
    final barPaint = Paint()..color = const Color(0xFF4285F4);
    final barRect = Rect.fromLTWH(center.dx, center.dy - r * 0.2, r, r * 0.4);
    canvas.drawRect(barRect, barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Painter for the official Apple logo.
class AppleLogoPainter extends CustomPainter {
  final Color color;
  
  AppleLogoPainter({this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double w = size.width;
    final double scale = w / 24.0;
    
    // Apple leaf path
    final leafPath = Path();
    leafPath.moveTo(13.51 * scale, 3.47 * scale);
    leafPath.cubicTo(14.54 * scale, 2.19 * scale, 15.86 * scale, 1.28 * scale, 17.26 * scale, 1.28 * scale);
    leafPath.cubicTo(17.44 * scale, 2.76 * scale, 16.74 * scale, 4.22 * scale, 15.71 * scale, 5.48 * scale);
    leafPath.cubicTo(14.71 * scale, 6.70 * scale, 13.38 * scale, 7.64 * scale, 12.01 * scale, 7.56 * scale);
    leafPath.cubicTo(11.83 * scale, 6.13 * scale, 12.51 * scale, 4.67 * scale, 13.51 * scale, 3.47 * scale);
    leafPath.close();

    // Apple body path
    final bodyPath = Path();
    bodyPath.moveTo(19.26 * scale, 12.92 * scale);
    bodyPath.cubicTo(19.23 * scale, 10.36 * scale, 21.32 * scale, 9.09 * scale, 21.41 * scale, 9.04 * scale);
    bodyPath.cubicTo(20.21 * scale, 7.29 * scale, 18.35 * scale, 7.05 * scale, 17.72 * scale, 7.02 * scale);
    bodyPath.cubicTo(16.03 * scale, 6.85 * scale, 14.39 * scale, 8.03 * scale, 13.53 * scale, 8.03 * scale);
    bodyPath.cubicTo(12.66 * scale, 8.03 * scale, 11.31 * scale, 7.04 * scale, 9.91 * scale, 7.07 * scale);
    bodyPath.cubicTo(8.08 * scale, 7.10 * scale, 6.38 * scale, 8.14 * scale, 5.44 * scale, 9.78 * scale);
    bodyPath.cubicTo(3.52 * scale, 13.11 * scale, 4.95 * scale, 18.01 * scale, 6.81 * scale, 20.69 * scale);
    bodyPath.cubicTo(7.72 * scale, 22.00 * scale, 8.75 * scale, 23.47 * scale, 10.16 * scale, 23.41 * scale);
    bodyPath.cubicTo(11.53 * scale, 23.36 * scale, 12.05 * scale, 22.53 * scale, 13.61 * scale, 22.53 * scale);
    bodyPath.cubicTo(15.17 * scale, 22.53 * scale, 15.65 * scale, 23.41 * scale, 17.07 * scale, 23.39 * scale);
    bodyPath.cubicTo(18.52 * scale, 23.36 * scale, 19.43 * scale, 22.05 * scale, 20.33 * scale, 20.73 * scale);
    bodyPath.cubicTo(21.38 * scale, 19.20 * scale, 21.81 * scale, 17.73 * scale, 21.84 * scale, 17.65 * scale);
    bodyPath.cubicTo(21.78 * scale, 17.63 * scale, 19.29 * scale, 16.67 * scale, 19.26 * scale, 12.92 * scale);
    bodyPath.close();

    canvas.drawPath(leafPath, paint);
    canvas.drawPath(bodyPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A premium, glassmorphic text input field with staggered load compatibility and scale-on-focus.
class PremiumInputField extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final String? prefixText;
  final void Function(String)? onChanged;

  const PremiumInputField({
    super.key,
    required this.labelText,
    this.hintText,
    this.controller,
    this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.prefixText,
    this.onChanged,
  });

  @override
  State<PremiumInputField> createState() => _PremiumInputFieldState();
}

class _PremiumInputFieldState extends State<PremiumInputField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _obscureText = widget.isPassword;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isFocused ? 1.02 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: widget.isPassword && _obscureText,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          style: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF2C2A28),
          ),
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, size: 20, color: const Color(0xFF8A857F))
                : null,
            prefixText: widget.prefixText,
            prefixStyle: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2C2A28),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 20,
                      color: const Color(0xFF8A857F),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.90),
            labelStyle: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _isFocused ? AppColors.primary : const Color(0xFF8A857F),
            ),
            hintStyle: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF8A857F),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFE5DDD2),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFD49494),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFD49494),
                width: 2.0,
              ),
            ),
            errorStyle: GoogleFonts.dmSans(
              color: const Color(0xFFD49494),
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}

/// A premium CTA button with gradient background, teal drop shadow, and horizontal press-scaling.
class PremiumButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? suffixIcon;

  const PremiumButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.suffixIcon,
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: _isPressed ? AppColors.primaryContainer : AppColors.primary,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: _isPressed ? 0.08 : 0.15),
                blurRadius: _isPressed ? 8 : 16,
                offset: Offset(0, _isPressed ? 3 : 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.label,
                      style: GoogleFonts.dmSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    if (widget.suffixIcon != null) ...[
                      const SizedBox(width: 8),
                      Icon(
                        widget.suffixIcon,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
