import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/flame.dart';
import 'package:tap_the_dot/game/overlays/game_over.dart';
import 'package:tap_the_dot/game/overlays/pause_menu.dart';
import 'package:tap_the_dot/game/overlays/score_display.dart';
import 'game/tap_the_dot_game.dart';
import 'package:flame/game.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Flame
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  // Handle application shutdown properly
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    exit(1);
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tap the Dot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<TapTheDotGame>(
        game: TapTheDotGame(),
        overlayBuilderMap: {
          'score': (context, game) => ScoreDisplay(game: game),
          'gameOver': (context, game) => GameOver(game: game),
          'pauseMenu': (context, game) => PauseMenu(game: game),
        },
        initialActiveOverlays: const ['score'],
      ),
    );
  }
}
