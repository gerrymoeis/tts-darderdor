// lib/services/bgm_service.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class BgmService {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isInitialized = false;
  bool _isMuted = false;

  BgmService() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Set volume
      await _player.setVolume(0.3);
      
      // Set looping mode
      await _player.setReleaseMode(ReleaseMode.loop);
      
      // Set player mode to MediaPlayer for better background playback
      await _player.setPlayerMode(PlayerMode.mediaPlayer);
      
      // Prepare the audio source but don't play yet
      await _player.setSource(AssetSource('audio/bgm.mp3'));
      
      _isInitialized = true;
      
      if (kDebugMode) {
        print("BGM service initialized successfully");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing BGM: $e');
      }
    }
  }

  Future<void> play() async {
    try {
      // If not initialized yet, try again
      if (!_isInitialized) {
        await _initialize();
      }
      
      if (!_isPlaying && !_isMuted) {
        // Play the BGM
        await _player.resume();
        
        _isPlaying = true;
        
        if (kDebugMode) {
          print("BGM started playing");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing BGM: $e');
      }
    }
  }

  Future<void> stop() async {
    try {
      if (_isPlaying) {
        await _player.pause();
        _isPlaying = false;
        
        if (kDebugMode) {
          print("BGM stopped");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error stopping BGM: $e');
      }
    }
  }
  
  Future<void> setMuted(bool muted) async {
    try {
      _isMuted = muted;
      
      if (_isMuted) {
        // If currently playing, stop it
        if (_isPlaying) {
          await _player.pause();
          _isPlaying = false;
        }
        
        if (kDebugMode) {
          print("BGM muted");
        }
      } else {
        // Resume playing
        await _player.resume();
        _isPlaying = true;
        
        if (kDebugMode) {
          print("BGM unmuted");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error setting BGM mute state: $e');
      }
    }
  }

  bool get isPlaying => _isPlaying;
  bool get isMuted => _isMuted;

  void dispose() {
    try {
      _player.dispose();
      if (kDebugMode) {
        print("BGM service disposed");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error disposing BGM: $e');
      }
    }
  }
}