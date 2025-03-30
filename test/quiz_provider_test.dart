// test/quiz_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tts_darderdor/providers/quiz_provider.dart';
import 'package:tts_darderdor/models/quiz_question.dart';
import 'package:tts_darderdor/services/bgm_service.dart';
import 'package:tts_darderdor/services/sound_service.dart';

// Simple test implementation of BgmService
class TestBgmService extends BgmService {
  bool wasMutedCalled = false;
  bool wasPlayCalled = false;
  bool wasStopCalled = false;
  
  @override
  Future<void> setMuted(bool muted) async {
    wasMutedCalled = true;
    await super.setMuted(muted);
  }
  
  @override
  Future<void> play() async {
    wasPlayCalled = true;
    // Don't call super to avoid actual audio playback
  }
  
  @override
  Future<void> stop() async {
    wasStopCalled = true;
    // Don't call super to avoid actual audio operations
  }
}

// Simple test implementation of SoundService
class TestSoundService extends SoundService {
  bool wasMutedCalled = false;
  bool wasPlayCorrectCalled = false;
  bool wasPlayWrongCalled = false;
  
  @override
  Future<void> setMuted(bool muted) async {
    wasMutedCalled = true;
    await super.setMuted(muted);
  }
  
  @override
  Future<void> playCorrect() async {
    wasPlayCorrectCalled = true;
    // Don't call super to avoid actual audio operations
  }
  
  @override
  Future<void> playWrong() async {
    wasPlayWrongCalled = true;
    // Don't call super to avoid actual audio operations
  }
}

void main() {
  // Initialize Flutter binding for tests
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('QuizProvider', () {
    late QuizProvider provider;
    late TestBgmService testBgmService;
    late TestSoundService testSoundService;
    
    setUp(() {
      testBgmService = TestBgmService();
      testSoundService = TestSoundService();
      provider = QuizProvider();
      provider.setBgmService(testBgmService);
      provider.setSoundService(testSoundService);
      
      // Load test questions
      provider.loadQuestions([
        QuizQuestion(
          question: 'Test Question 1',
          answer: 'ABC',
          letterPool: ['A', 'B', 'C', 'D', 'E'],
        ),
        QuizQuestion(
          question: 'Test Question 2',
          answer: 'DEF',
          letterPool: ['D', 'E', 'F', 'G', 'H'],
        ),
      ]);
    });
    
    test('initializes with default values', () {
      expect(provider.currentQuestionIndex, 0);
      expect(provider.score, 0);
      expect(provider.selectedLetters, isEmpty);
      expect(provider.selectedLetterIndices, isEmpty);
      expect(provider.totalQuestions, 2);
      expect(provider.soundEnabled, true);
      expect(provider.bgmEnabled, true);
    });
    
    test('selectLetter adds letter to selected letters', () {
      provider.selectLetter('A', 0);
      provider.selectLetter('B', 1);
      
      expect(provider.selectedLetters, ['A', 'B']);
      expect(provider.selectedLetterIndices, [0, 1]);
    });
    
    test('selectLetter does not add more letters than answer length', () {
      // Answer length is 3 (ABC)
      provider.selectLetter('A', 0);
      provider.selectLetter('B', 1);
      provider.selectLetter('C', 2);
      provider.selectLetter('D', 3); // Should not be added
      
      expect(provider.selectedLetters.length, 3);
      expect(provider.selectedLetterIndices.length, 3);
    });
    
    test('removeLetter removes letter at specified index', () {
      provider.selectLetter('A', 0);
      provider.selectLetter('B', 1);
      provider.removeLetter(0);
      
      expect(provider.selectedLetters, ['B']);
      expect(provider.selectedLetterIndices, [1]);
    });
    
    test('clearCurrentAnswer resets selected letters', () {
      provider.selectLetter('A', 0);
      provider.selectLetter('B', 1);
      provider.clearCurrentAnswer();
      
      expect(provider.selectedLetters, isEmpty);
      expect(provider.selectedLetterIndices, isEmpty);
    });
    
    test('incrementScore increases score by 1', () {
      expect(provider.score, 0);
      provider.incrementScore();
      expect(provider.score, 1);
    });
    
    test('nextQuestion moves to next question and resets selection', () {
      provider.selectLetter('A', 0);
      expect(provider.currentQuestionIndex, 0);
      
      provider.nextQuestion();
      
      expect(provider.currentQuestionIndex, 1);
      expect(provider.selectedLetters, isEmpty);
      expect(provider.selectedLetterIndices, isEmpty);
    });
    
    test('nextQuestion does not move beyond last question', () {
      provider.nextQuestion(); // Move to question 1
      expect(provider.currentQuestionIndex, 1);
      
      provider.nextQuestion(); // Should not move further
      expect(provider.currentQuestionIndex, 1);
    });
    
    test('resetQuiz resets all state', () {
      provider.selectLetter('A', 0);
      provider.incrementScore();
      provider.nextQuestion();
      
      provider.resetQuiz();
      
      expect(provider.currentQuestionIndex, 0);
      expect(provider.score, 0);
      expect(provider.selectedLetters, isEmpty);
      expect(provider.selectedLetterIndices, isEmpty);
    });
    
    test('toggleBGM changes bgmEnabled and updates service', () {
      expect(provider.bgmEnabled, true);
      
      provider.toggleBGM();
      
      expect(provider.bgmEnabled, false);
      expect(testBgmService.wasMutedCalled, true);
      
      provider.toggleBGM();
      
      expect(provider.bgmEnabled, true);
      expect(testBgmService.wasPlayCalled, true);
    });
    
    test('toggleSound changes soundEnabled and updates service', () {
      expect(provider.soundEnabled, true);
      
      provider.toggleSound();
      
      expect(provider.soundEnabled, false);
      expect(testSoundService.wasMutedCalled, true);
      
      provider.toggleSound();
      
      expect(provider.soundEnabled, true);
    });
  });
}