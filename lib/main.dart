// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
import 'providers/quiz_provider.dart';
import 'services/bgm_service.dart';
import 'services/sound_service.dart';
import 'screens/home_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';
import 'screens/settings_screen.dart';
import 'constants/app_constants.dart';
import 'data/quiz_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final quizProvider = QuizProvider();
  final bgmService = BgmService();
  final soundService = SoundService();
  
  // Connect services with provider
  quizProvider.setBgmService(bgmService);
  quizProvider.setSoundService(soundService);

  // Preload questions
  quizProvider.loadQuestions(quizQuestions);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: quizProvider),
        Provider.value(value: bgmService),
        Provider.value(value: soundService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    
    // Play BGM after a short delay to ensure everything is initialized
    Future.delayed(const Duration(milliseconds: 500), () {
      final bgmService = Provider.of<BgmService>(context, listen: false);
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      
      if (quizProvider.bgmEnabled) {
        bgmService.play();
        if (kDebugMode) {
          print("Starting BGM from MyApp");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TTS DarDerDor',
      theme: ThemeData(
        textTheme: GoogleFonts.bangersTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.accent,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/result': (context) => const ResultScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}