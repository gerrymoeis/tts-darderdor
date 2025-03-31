// lib/widgets/question_text.dart
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionText extends StatelessWidget {
  final String question;
  final double fontSize;

  const QuestionText({
    super.key, 
    required this.question, 
    this.fontSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TyperAnimatedText(
          question,
          textStyle: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
            letterSpacing: 0.5,
          ),
          speed: const Duration(milliseconds: 50),
        ),
      ],
      totalRepeatCount: 1,
      displayFullTextOnTap: true,
    );
  }
}