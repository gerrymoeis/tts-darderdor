// lib/services/sound_service.dart
import 'package:flutter/foundation.dart';

class SoundService {
  bool _isMuted = false;

  SoundService() {
    if (kDebugMode) {
      print("Sound service created (placeholder only)");
    }
  }

  // Placeholder method - doesn't actually play sound
  Future<void> playCorrect() async {
    if (_isMuted) {
      if (kDebugMode) {
        print("Sound effects are muted (placeholder)");
      }
      return;
    }
    
    if (kDebugMode) {
      print("Correct sound effect would play here (placeholder)");
    }
  }

  // Placeholder method - doesn't actually play sound
  Future<void> playWrong() async {
    if (_isMuted) {
      if (kDebugMode) {
        print("Sound effects are muted (placeholder)");
      }
      return;
    }
    
    if (kDebugMode) {
      print("Wrong sound effect would play here (placeholder)");
    }
  }
  
  Future<void> setMuted(bool muted) async {
    _isMuted = muted;
    if (kDebugMode) {
      print("Sound effects ${_isMuted ? 'muted' : 'unmuted'} (placeholder)");
    }
  }
  
  bool get isMuted => _isMuted;

  void dispose() {
    if (kDebugMode) {
      print("Sound service disposed (placeholder)");
    }
  }
}