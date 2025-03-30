// test/quiz_question_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tts_darderdor/models/quiz_question.dart';

void main() {
  group('QuizQuestion', () {
    test('isCorrect returns true when answer is correct regardless of case', () {
      final question = QuizQuestion(
        question: 'Rektor UNESA saat ini adalah Prof. Dr. H. Nurhasan, M.Kes.?',
        answer: 'BENAR',
        letterPool: ['B', 'E', 'N', 'A', 'R', 'S'],
      );
      
      // Test with uppercase letters
      expect(question.isCorrect(['B', 'E', 'N', 'A', 'R']), isTrue);
      
      // Test with lowercase letters (should still work due to case insensitivity)
      expect(question.isCorrect(['b', 'e', 'n', 'a', 'r']), isTrue);
      
      // Test with mixed case
      expect(question.isCorrect(['B', 'e', 'N', 'a', 'R']), isTrue);
    });
    
    test('isCorrect returns false when answer is incorrect', () {
      final question = QuizQuestion(
        question: 'D4 MI berada di bawah Fakultas Teknik UNESA?',
        answer: 'SALAH',
        letterPool: ['S', 'A', 'L', 'H', 'B', 'E', 'A'],
      );
      
      // Test with incorrect answer
      expect(question.isCorrect(['B', 'E', 'N', 'A', 'R']), isFalse);
    });
    
    test('isCorrect returns false when answer length is incorrect', () {
      final question = QuizQuestion(
        question: 'Jurusan D4 MI berada di bawah Fakultas ______',
        answer: 'VOKASI',
        letterPool: ['V', 'O', 'K', 'A', 'S', 'I', 'L', 'M'],
      );
      
      // Test with too few letters
      expect(question.isCorrect(['V', 'O', 'K', 'A', 'S']), isFalse);
      
      // Test with too many letters
      expect(question.isCorrect(['V', 'O', 'K', 'A', 'S', 'I', 'L']), isFalse);
    });
    
    test('isCorrect handles special characters and spaces correctly', () {
      final question = QuizQuestion(
        question: 'Bahasa pemrograman utama untuk mata kuliah Mobile Programming?',
        answer: 'DART',
        letterPool: ['D', 'A', 'R', 'T', 'F', 'L', 'U'],
      );
      
      // Test with correct answer
      expect(question.isCorrect(['D', 'A', 'R', 'T']), isTrue);
      
      // Test with incorrect answer
      expect(question.isCorrect(['F', 'L', 'U', 'T']), isFalse);
    });
  });
}