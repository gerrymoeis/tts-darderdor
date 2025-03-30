// lib/widgets/custom_button.dart
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double elevation;
  final BorderRadius? borderRadius;
  final bool showGradient;
  final List<Color>? gradientColors;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.primary,
    this.padding = const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    this.textStyle,
    this.elevation = 5.0,
    this.borderRadius,
    this.showGradient = false,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = GoogleFonts.poppins(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.8,
    );

    final buttonBorderRadius = borderRadius ?? BorderRadius.circular(12);

    if (showGradient) {
      final colors = gradientColors ?? [
        const Color(0xFF4F46E5),
        const Color(0xFFEC4899),
      ];
      
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: buttonBorderRadius,
          boxShadow: [
            BoxShadow(
              color: colors[0].withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: buttonBorderRadius,
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: textStyle ?? defaultTextStyle,
          ),
        ),
      );
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
        elevation: elevation,
        shadowColor: backgroundColor?.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: buttonBorderRadius,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle ?? defaultTextStyle,
      ),
    );
  }
}