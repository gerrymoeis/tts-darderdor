// lib/widgets/tts_column.dart
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';

class TTSColumn extends StatelessWidget {
  final String answer;
  final List<String> selectedLetters;
  final Function(int) onTapLetter;
  final double size;

  const TTSColumn({
    super.key, 
    required this.answer,
    required this.selectedLetters,
    required this.onTapLetter,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        answer.length,
            (index) => GestureDetector(
          onTap: index < selectedLetters.length ? () => onTapLetter(index) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size,
            height: size,
            margin: EdgeInsets.symmetric(horizontal: size * 0.1),
            decoration: BoxDecoration(
              color: index < selectedLetters.length
                  ? AppColors.accent.withAlpha(77)
                  : Colors.transparent,
              border: Border.all(
                color: index < selectedLetters.length
                    ? AppColors.primary
                    : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(child: Text(
              index < selectedLetters.length ? selectedLetters[index] : '',
              style: GoogleFonts.poppins(
                fontSize: size * 0.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )),
          ),
        ),
      ),
    );
  }
}