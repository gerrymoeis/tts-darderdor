// lib/services/timer_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerService {
  final int _duration = 10;
  final VoidCallback onTimerComplete;
  Timer? _timer;
  final ValueNotifier<int> remainingTime;
  bool _isPaused = false;
  int _pausedTime = 0;

  TimerService({required this.onTimerComplete})
      : remainingTime = ValueNotifier(10);

  void start() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    if (_isPaused) {
      remainingTime.value = _pausedTime;
      _isPaused = false;
    } else {
      remainingTime.value = _duration;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
        if (kDebugMode) {
          print("Timer: ${remainingTime.value}");
        }
      } else {
        _timer?.cancel();
        onTimerComplete();
      }
    });
  }

  void pause() {
    if (_timer != null && _timer!.isActive) {
      _pausedTime = remainingTime.value;
      _timer!.cancel();
      _isPaused = true;
      if (kDebugMode) {
        print("Timer paused at: $_pausedTime");
      }
    }
  }
  
  void resume() {
    if (_isPaused) {
      if (kDebugMode) {
        print("Resuming timer from: $_pausedTime");
      }
      start();
    }
  }

  void reset() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    remainingTime.value = _duration;
    _isPaused = false;
    start();
    if (kDebugMode) {
      print("Timer reset to: $_duration");
    }
  }

  void dispose() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    remainingTime.dispose();
    if (kDebugMode) {
      print("Timer service disposed");
    }
  }
}