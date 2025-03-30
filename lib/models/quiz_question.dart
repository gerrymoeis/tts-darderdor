// lib/models/quiz_question.dart

class QuizQuestion {
  final String question;
  final String answer;
  final List<String> letterPool;

  const QuizQuestion({
    required this.question,
    required this.answer,
    required this.letterPool,
  });

  // Validasi jawaban
  bool isCorrect(List<String> selectedLetters) {
    if (selectedLetters.length != answer.length) {
      return false;
    }
    
    // Membandingkan jawaban tanpa memperhatikan case sensitivity
    final userAnswer = selectedLetters.join('').toUpperCase();
    final correctAnswer = answer.toUpperCase();
    
    return userAnswer == correctAnswer;
  }
}