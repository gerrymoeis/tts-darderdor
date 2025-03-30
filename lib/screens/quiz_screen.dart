import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/quiz_provider.dart';
import '../services/sound_service.dart';
import '../services/bgm_service.dart';
import '../services/timer_service.dart';
import '../widgets/question_text.dart';
import '../widgets/tts_column.dart';
import '../widgets/answer_circle.dart';
import '../widgets/background_widget.dart';
import '../widgets/custom_button.dart';
import '../constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  late TimerService _timerService;
  Color _answerFeedbackColor = Colors.transparent;
  bool _isProcessingAnswer = false;
  late AnimationController _animationController;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    // Ensure BGM continues playing
    final bgmService = context.read<BgmService>();
    final quizProvider = context.read<QuizProvider>();
    
    if (quizProvider.bgmEnabled) {
      Future.microtask(() => bgmService.play());
    }
    
    _timerService = TimerService(
      onTimerComplete: () {
        if (!_isPaused && !_isProcessingAnswer && mounted) {
          _handleTimeUp();
        }
      },
    );
    
    _timerService.start();
  }

  @override
  void dispose() {
    _timerService.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      
      if (_isPaused) {
        _timerService.pause();
      } else {
        _timerService.resume();
      }
    });
  }

  // Simple method to play sound effects (placeholder only)
  void _playSound(bool isCorrect) {
    final soundService = context.read<SoundService>();
    final quizProvider = context.read<QuizProvider>();
    
    if (quizProvider.soundEnabled) {
      if (isCorrect) {
        soundService.playCorrect();
      } else {
        soundService.playWrong();
      }
    }
  }

  void _handleTimeUp() {
    if (_isProcessingAnswer || !mounted) return;
    
    final quizProvider = context.read<QuizProvider>();
    
    setState(() => _isProcessingAnswer = true);
    
    // Play wrong sound (placeholder)
    _playSound(false);
    
    setState(() => _answerFeedbackColor = AppColors.wrong.withAlpha(100));
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      
      setState(() {
        _answerFeedbackColor = Colors.transparent;
        _isProcessingAnswer = false;
      });
      
      if (quizProvider.currentQuestionIndex < quizProvider.totalQuestions - 1) {
        quizProvider.nextQuestion();
        _timerService.reset();
        
        if (kDebugMode) {
          print("New question: ${quizProvider.currentQuestion.question}");
        }
      } else {
        Navigator.pushReplacementNamed(context, '/result');
      }
    });
  }

  void _handleAnswerSubmission() {
    if (_isProcessingAnswer || !mounted) return;
    
    final quizProvider = context.read<QuizProvider>();
    
    setState(() => _isProcessingAnswer = true);
    
    bool isCorrect = quizProvider.currentQuestion.isCorrect(
        quizProvider.selectedLetters
    );

    // Play appropriate sound (placeholder)
    _playSound(isCorrect);

    setState(() => _answerFeedbackColor = isCorrect
        ? AppColors.correct.withAlpha(100)
        : AppColors.wrong.withAlpha(100)
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      
      setState(() {
        _answerFeedbackColor = Colors.transparent;
        _isProcessingAnswer = false;
      });
      
      if (isCorrect) {
        quizProvider.incrementScore();
        
        if (quizProvider.currentQuestionIndex < quizProvider.totalQuestions - 1) {
          quizProvider.nextQuestion();
          _timerService.reset();
          
          // Force animation to trigger rebuild
          _animationController.reset();
          _animationController.forward();
          
          if (kDebugMode) {
            print("New question: ${quizProvider.currentQuestion.question}");
          }
        } else {
          Navigator.pushReplacementNamed(context, '/result');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Building QuizScreen");
    }
    
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<int>(
          valueListenable: _timerService.remainingTime,
          builder: (context, time, _) {
            return Text(
              'Waktu: $time detik',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            );
          },
        ),
        backgroundColor: AppColors.accent,
        elevation: 4,
        toolbarHeight: 50,
        actions: [
          IconButton(
            icon: const Icon(Icons.pause, color: Colors.white, size: 20),
            onPressed: _togglePause,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
      body: Stack(
        children: [
          Consumer<QuizProvider>(
            builder: (context, quizProvider, _) {
              if (kDebugMode) {
                print("Current question index: ${quizProvider.currentQuestionIndex}");
                print("Total questions: ${quizProvider.totalQuestions}");
                print("Current question text: ${quizProvider.currentQuestion.question}");
              }
              
              // Create a unique key based on the current question index to force rebuild
              final questionKey = ValueKey('question_${quizProvider.currentQuestionIndex}');
              
              return BackgroundWidget(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  color: _answerFeedbackColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      key: questionKey, // Add key to force rebuild when question changes
                      children: [
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: (quizProvider.currentQuestionIndex + 1) /
                              quizProvider.totalQuestions,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                          minHeight: 6,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Soal ${quizProvider.currentQuestionIndex + 1} dari ${quizProvider.totalQuestions}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        QuestionText(
                          key: ValueKey('question_text_${quizProvider.currentQuestionIndex}'),
                          question: quizProvider.currentQuestion.question,
                          fontSize: 18,
                        ),
                        const SizedBox(height: 20),
                        TTSColumn(
                          key: ValueKey('tts_column_${quizProvider.currentQuestionIndex}'),
                          answer: quizProvider.currentQuestion.answer,
                          selectedLetters: quizProvider.selectedLetters,
                          onTapLetter: (index) {
                            if (!_isProcessingAnswer) {
                              quizProvider.removeLetter(index);
                            }
                          },
                          size: 36,
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          key: ValueKey('letter_pool_${quizProvider.currentQuestionIndex}'),
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                            quizProvider.currentQuestion.letterPool.length,
                            (index) {
                              final letter = quizProvider.currentQuestion.letterPool[index];
                              return AnswerCircle(
                                letter: letter,
                                index: index,
                                onTap: (letter, index) {
                                  if (!_isProcessingAnswer) {
                                    quizProvider.selectLetter(letter, index);
                                  }
                                },
                                isSelected: quizProvider.selectedLetterIndices.contains(index),
                                size: 40,
                              );
                            },
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomButton(
                              text: 'Ulangi',
                              onPressed: _isProcessingAnswer ? () {} : () {
                                quizProvider.clearCurrentAnswer();
                              },
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              textStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            CustomButton(
                              text: 'Submit Jawaban',
                              onPressed: _isProcessingAnswer || quizProvider.selectedLetters.isEmpty ? () {} : () {
                                _handleAnswerSubmission();
                              },
                              backgroundColor: _isProcessingAnswer || quizProvider.selectedLetters.isEmpty
                                  ? Colors.grey 
                                  : AppColors.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              textStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Pause overlay
          if (_isPaused)
            _buildPauseOverlay(),
        ],
      ),
    );
  }
  
  Widget _buildPauseOverlay() {
    final quizProvider = context.watch<QuizProvider>();
    
    return Container(
      color: Colors.black.withOpacity(0.85),
      width: double.infinity,
      height: double.infinity,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accent.withOpacity(0.9),
                  AppColors.primary.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Quiz Dijeda',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Settings
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: Text(
                          'Musik Latar (BGM)',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        value: quizProvider.bgmEnabled,
                        activeColor: Colors.white,
                        activeTrackColor: AppColors.primary,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey.withOpacity(0.5),
                        onChanged: (value) => quizProvider.toggleBGM(),
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.white24,
                      ),
                      SwitchListTile(
                        title: Text(
                          'Suara Efek',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        value: quizProvider.soundEnabled,
                        activeColor: Colors.white,
                        activeTrackColor: AppColors.primary,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey.withOpacity(0.5),
                        onChanged: (value) => quizProvider.toggleSound(),
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      text: 'Keluar Quiz',
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      backgroundColor: AppColors.wrong,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      textStyle: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    CustomButton(
                      text: 'Lanjutkan',
                      onPressed: _togglePause,
                      backgroundColor: AppColors.correct,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      textStyle: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}