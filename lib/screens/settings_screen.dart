// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../constants/app_constants.dart';
import '../widgets/background_widget.dart';
import '../widgets/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengaturan', 
          style: GoogleFonts.poppins(
            color: Colors.white, 
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: BackgroundWidget(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent.withOpacity(0.8),
                      AppColors.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 24),
                child: Text(
                  'Kustomisasi Pengalaman Quiz Anda',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white.withOpacity(0.9),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(
                        'Musik Latar (BGM)',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                      subtitle: Text(
                        'Mainkan musik latar selama quiz',
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                      value: context.watch<QuizProvider>().bgmEnabled,
                      activeColor: AppColors.primary,
                      activeTrackColor: AppColors.primary.withOpacity(0.5),
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey.withOpacity(0.5),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      onChanged: (value) => context.read<QuizProvider>().toggleBGM(),
                    ),
                    const Divider(height: 1, thickness: 1),
                    SwitchListTile(
                      title: Text(
                        'Suara Efek',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                      subtitle: Text(
                        'Putar suara untuk jawaban benar/salah',
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                      value: context.watch<QuizProvider>().soundEnabled,
                      activeColor: AppColors.primary,
                      activeTrackColor: AppColors.primary.withOpacity(0.5),
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey.withOpacity(0.5),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      onChanged: (value) => context.read<QuizProvider>().toggleSound(),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: CustomButton(
                  text: 'Kembali ke Menu',
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}