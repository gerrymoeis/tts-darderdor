// lib/providers/quiz_provider.dart
import 'package:flutter/foundation.dart';
import '../models/quiz_question.dart';
import '../services/bgm_service.dart';
import '../services/sound_service.dart';

class QuizProvider extends ChangeNotifier {
  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  final List<String> _selectedLetters = [];
  final List<int> _selectedLetterIndices = [];
  int _score = 0;

  // Getter
  List<QuizQuestion> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  List<String> get selectedLetters => _selectedLetters;
  List<int> get selectedLetterIndices => _selectedLetterIndices;
  int get score => _score;
  int get totalQuestions => _questions.length;

  bool _soundEnabled = true;
  bool get soundEnabled => _soundEnabled;
  bool _bgmEnabled = true;
  bool get bgmEnabled => _bgmEnabled;
  
  // Services
  BgmService? _bgmService;
  SoundService? _soundService;
  
  // Set services
  void setBgmService(BgmService service) {
    _bgmService = service;
    if (kDebugMode) {
      print("BGM service set in QuizProvider");
    }
  }
  
  void setSoundService(SoundService service) {
    _soundService = service;
    if (kDebugMode) {
      print("Sound service set in QuizProvider");
    }
  }

  // Reset quiz state completely
  void resetQuiz() {
    if (kDebugMode) {
      print("Resetting quiz state");
    }
    _questions = [];
    _currentQuestionIndex = 0;
    _score = 0;
    _resetSelection();
    notifyListeners();
  }

  // Load questions
  void loadQuestions(List<QuizQuestion> questions) {
    if (kDebugMode) {
      print("Loading ${questions.length} questions");
      for (var i = 0; i < questions.length; i++) {
        print("Question $i: ${questions[i].question}");
        print("Answer $i: ${questions[i].answer}");
      }
    }
    _questions = List.from(questions); // Create a copy to ensure we have a fresh list
    _currentQuestionIndex = 0;
    _score = 0;
    _resetSelection();
    notifyListeners();
  }

  // Select letter
  void selectLetter(String letter, int index) {
    if (_selectedLetters.length < currentQuestion.answer.length &&
        !_selectedLetterIndices.contains(index)) {
      _selectedLetters.add(letter);
      _selectedLetterIndices.add(index);
      notifyListeners();
    }
  }

  // Remove letter
  void removeLetter(int index) {
    if (index >= 0 && index < _selectedLetters.length) {
      _selectedLetters.removeAt(index);
      _selectedLetterIndices.removeAt(index);
      notifyListeners();
    }
  }

  // Reset selected letters
  void _resetSelection() {
    _selectedLetters.clear();
    _selectedLetterIndices.clear();
  }

  // Clear current answer to try again
  void clearCurrentAnswer() {
    _resetSelection();
    notifyListeners();
  }

  // Increment score
  void incrementScore() {
    _score++;
    notifyListeners();
  }

  // Move to next question
  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      if (kDebugMode) {
        print("Moving from question $_currentQuestionIndex to ${_currentQuestionIndex + 1}");
        print("Current question: ${_questions[_currentQuestionIndex].question}");
        print("Next question: ${_questions[_currentQuestionIndex + 1].question}");
      }
      
      // Increment the index first
      _currentQuestionIndex++;
      
      // Then reset the selection
      _resetSelection();
      
      // Force a rebuild by notifying listeners
      notifyListeners();
      
      if (kDebugMode) {
        print("After moving, current question index: $_currentQuestionIndex");
        print("Current question text: ${currentQuestion.question}");
        print("Current answer: ${currentQuestion.answer}");
      }
    } else {
      if (kDebugMode) {
        print("Already at last question");
      }
    }
  }

  // Get current question
  QuizQuestion get currentQuestion {
    if (_questions.isEmpty) {
      throw Exception("No questions loaded");
    }
    
    // Ensure index is within bounds
    if (_currentQuestionIndex < 0 || _currentQuestionIndex >= _questions.length) {
      if (kDebugMode) {
        print("Warning: Question index out of bounds. Resetting to 0.");
      }
      _currentQuestionIndex = 0;
    }
    
    if (kDebugMode) {
      print("Getting question at index $_currentQuestionIndex");
      print("Question text: ${_questions[_currentQuestionIndex].question}");
    }
    
    return _questions[_currentQuestionIndex];
  }

  // Toggle sound
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    
    // Update sound service if available
    if (_soundService != null) {
      _soundService!.setMuted(!_soundEnabled);
      if (kDebugMode) {
        print("Sound effects ${_soundEnabled ? 'enabled' : 'disabled'} in QuizProvider");
      }
    }
    
    notifyListeners();
  }

  // Toggle BGM
  void toggleBGM() {
    _bgmEnabled = !_bgmEnabled;
    
    // Update BGM service if available
    if (_bgmService != null) {
      if (_bgmEnabled) {
        _bgmService!.setMuted(false);
        _bgmService!.play();
        if (kDebugMode) {
          print("BGM enabled and playing in QuizProvider");
        }
      } else {
        _bgmService!.setMuted(true);
        if (kDebugMode) {
          print("BGM muted in QuizProvider");
        }
      }
    }
    
    notifyListeners();
  }
}