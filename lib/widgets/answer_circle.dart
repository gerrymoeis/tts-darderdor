// lib/widgets/answer_circle.dart
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';

class AnswerCircle extends StatelessWidget {
  final String letter;
  final int index;
  final Function(String, int) onTap;
  final bool isSelected;
  final double size;

  const AnswerCircle({
    super.key,
    required this.letter,
    required this.index,
    required this.onTap,
    required this.isSelected,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSelected ? null : () => onTap(letter, index),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(150)
              : AppColors.primary,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            letter,
            style: GoogleFonts.poppins(
              color: Colors.white, 
              fontSize: size * 0.4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}