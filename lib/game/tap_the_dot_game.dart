import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../utils/audio_manager.dart';
import 'components/dot.dart';
import 'components/timer_bar.dart';

class TapTheDotGame extends FlameGame with TapCallbacks, HasGameReference {
  // Game state
  int score = 0;
  int lives = GameConstants.initialLives;
  bool isGameOver = false;
  bool isPaused = false;

  // Game configuration
  late double spawnInterval;
  final Random random = Random();
  late TimerComponent dotSpawnTimer;
  late TimerBar timerBar;

  // Add background sprite
  late SpriteComponent background;

  // Add this to your class fields
  final List<VoidCallback> _scoreListeners = [];

  // Add high score field
  int highScore = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await AudioManager.init();

    // Load and add background image
    background = SpriteComponent(
      sprite: await Sprite.load(
        'background.png',
      ), // Make sure to add this image to your assets
      size: size,
      priority: -1, // Lower priority ensures it's drawn behind other components
    );
    add(background);

    spawnInterval = GameConstants.initialSpawnInterval;

    // Timer bar at the top of the screen
    timerBar = TimerBar();
    add(timerBar);

    // Set up dot spawn timer
    dotSpawnTimer = TimerComponent(
      period: spawnInterval,
      repeat: true,
      onTick: spawnDot,
    );
    add(dotSpawnTimer);

    // Add the score overlay
    overlays.add('score');

    // Load the high score when the game starts
    await loadHighScore();
  }

  void spawnDot() {
    if (isPaused || isGameOver) return;

    try {
      // Random position that ensures the dot is fully visible
      final radius =
          GameConstants.minDotRadius +
          random.nextDouble() *
              (GameConstants.maxDotRadius - GameConstants.minDotRadius);
      final x = radius + random.nextDouble() * (size.x - 2 * radius);
      final y = radius + random.nextDouble() * (size.y - 2 * radius);

      // Random color
      final color =
          GameConstants.dotColors[random.nextInt(
            GameConstants.dotColors.length,
          )];

      // Create and add the dot
      final dot = Dot(
        position: Vector2(x, y),
        radius: radius,
        color: color,
        onTimeout: onDotTimeout,
      );

      add(dot);
    } catch (e) {
      // Handle any errors that occur during dot spawning
      if (kDebugMode) {
        print('Error spawning dot: $e');
      }
    }
  }

  void onDotTimeout() {
    // Player missed a dot
    lives--;
    AudioManager.playMissSound();

    if (lives <= 0) {
      gameOver();
    }

    // Notify listeners about the lives change
    _notifyScoreListeners();
  }

  void increaseScore() {
    score += GameConstants.scorePerDot;
    AudioManager.playTapSound();

    // Increase difficulty every 50 points by reducing spawn interval
    if (score % 50 == 0 && spawnInterval > GameConstants.minSpawnInterval) {
      spawnInterval = max(spawnInterval - 0.1, GameConstants.minSpawnInterval);
      dotSpawnTimer.timer.limit = spawnInterval;
    }

    // Notify listeners about the score change
    _notifyScoreListeners();
  }

  void gameOver() {
    isGameOver = true;
    AudioManager.playGameOverSound();
    dotSpawnTimer.timer.stop();
    overlays.add('gameOver');

    // Check if current score is higher than high score
    if (score > highScore) {
      highScore = score;
      saveHighScore();
    }
  }

  void reset() {
    score = 0;
    lives = GameConstants.initialLives;
    isGameOver = false;
    spawnInterval = GameConstants.initialSpawnInterval;

    // Replace the old timer with a new one
    dotSpawnTimer.removeFromParent();
    dotSpawnTimer = TimerComponent(
      period: spawnInterval,
      repeat: true,
      onTick: spawnDot,
    );
    add(dotSpawnTimer);

    // Remove all dots
    children.whereType<Dot>().forEach((dot) {
      dot.removeFromParent();
    });

    // Reset timer bar
    timerBar.reset();

    // Remove game over overlay and ensure score overlay is active
    overlays.remove('gameOver');
    overlays.add('score');

    // Restart the dot spawn timer
    dotSpawnTimer.timer.start();
  }

  void togglePause() {
    isPaused = !isPaused;
    if (isPaused) {
      dotSpawnTimer.timer.pause();
      overlays.add('pauseMenu');
    } else {
      dotSpawnTimer.timer.resume();
      overlays.remove('pauseMenu');
    }
  }

  // Add these methods to manage listeners
  void addScoreListener(VoidCallback listener) {
    _scoreListeners.add(listener);
  }

  void removeScoreListener(VoidCallback listener) {
    _scoreListeners.remove(listener);
  }

  // Notify listeners when score changes
  void _notifyScoreListeners() {
    for (final listener in _scoreListeners) {
      listener();
    }
  }

  // Method to load high score from SharedPreferences
  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;
    _notifyScoreListeners(); // Update UI
  }

  // Method to save high score to SharedPreferences
  Future<void> saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore', highScore);
  }

  // Method to reset the game
  void resetGame() {
    score = 0;
    lives = GameConstants.initialLives;
    spawnInterval = GameConstants.initialSpawnInterval;
    isPaused = false;
    // Remove all dots
    removeAll(children.query<Dot>());
    // Reset timers
    dotSpawnTimer.timer.limit = spawnInterval;
    _notifyScoreListeners();
  }

  // When game size changes, update background size
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (hasLayout) {
      background.size = size;
    }
  }
}
