import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioPlayer _effectPlayer = AudioPlayer();
  static final AudioCache _cache = AudioCache();
  static bool _isMuted = false;

  static Future<void> init() async {
    // Fix: Use the correct paths with the 'audio/' subfolder
    await _cache.loadAll([
      'audio/pop.mp3',
      'audio/miss.mp3',
      'audio/game_over.mp3',
    ]);
  }

  static bool get isMuted => _isMuted;

  static void toggleMute() {
    _isMuted = !_isMuted;
  }

  static Future<void> playTapSound() async {
    if (!_isMuted) {
      await _effectPlayer.play(AssetSource('audio/pop.mp3'));
    }
  }

  static Future<void> playMissSound() async {
    if (!_isMuted) {
      await _effectPlayer.play(AssetSource('audio/miss.mp3'));
    }
  }

  static Future<void> playGameOverSound() async {
    if (!_isMuted) {
      await _effectPlayer.play(AssetSource('audio/game_over.mp3'));
    }
  }

  static void dispose() {
    _effectPlayer.dispose();
  }
}
