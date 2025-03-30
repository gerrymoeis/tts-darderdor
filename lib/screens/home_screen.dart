// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/quiz_provider.dart';
import '../widgets/background_widget.dart';
import '../widgets/custom_button.dart';
import '../data/quiz_config.dart';
import 'package:flutter/foundation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: BackgroundWidget(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppAssets.logo, width: 250),
              const SizedBox(height: 40),
              CustomButton(
                text: 'MULAI QUIZ',
                onPressed: () {
                  final quizProvider = context.read<QuizProvider>();
                  // Reset quiz state and load questions
                  quizProvider.resetQuiz();
                  quizProvider.loadQuestions(quizQuestions);
                  
                  if (kDebugMode) {
                    print("Starting quiz with ${quizQuestions.length} questions");
                    print("Current question index: ${quizProvider.currentQuestionIndex}");
                  }
                  
                  Navigator.pushNamed(context, '/quiz');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}