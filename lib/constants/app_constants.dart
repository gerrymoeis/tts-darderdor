// lib/constants/app_constants.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Warna
class AppColors {
  static const Color primary = Color(0xFF2E3192); // Biru UNESA
  static const Color accent = Color(0xFFFFD600);  // Kuning UNESA
  static const Color correct = Color(0xFF4CAF50); // Hijau
  static const Color wrong = Color(0xFFF44336);   // Merah
}

// Asset
class AppAssets {
  static const String logo = 'assets/images/logo.png';
  static const String mascot = 'assets/images/mascot.png';
  static const String correctSound = 'assets/audio/correct.mp3';
  static const String wrongSound = 'assets/audio/wrong.mp3';
}

// Teks
class AppTextStyles {
  static TextStyle heading(BuildContext context) {
    return GoogleFonts.bangers().copyWith(
      fontSize: 28,
      color: AppColors.primary,
      shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
    );
  }

  static const TextStyle buttonText = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );
}

// Konfigurasi Quiz
class QuizConfig {
  static const int timePerQuestion = 10;
  static const int maxLettersPerAnswer = 8;
}