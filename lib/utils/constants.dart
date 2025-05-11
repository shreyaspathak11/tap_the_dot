import 'package:flutter/material.dart';

class GameConstants {
  // Game settings
  static const int initialLives = 3;
  static const double dotDuration = 2.0; // seconds dot stays on screen
  static const double initialSpawnInterval = 2.0; // seconds between dots
  static const double minSpawnInterval =
      0.5; // minimum spawn time as difficulty increases
  static const int scorePerDot = 10;

  // Dot properties
  static const double minDotRadius = 20.0;
  static const double maxDotRadius = 40.0;
  static const List<Color> dotColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];

  // Timer bar
  static const Color timerBarColor = Colors.red;
  static const double timerBarHeight = 10.0;
}
