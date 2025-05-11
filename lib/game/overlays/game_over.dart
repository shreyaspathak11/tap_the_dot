import 'package:flutter/material.dart';
import '../tap_the_dot_game.dart';

class GameOver extends StatelessWidget {
  final TapTheDotGame game;

  const GameOver({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Game Over',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Your Score: ${game.score}',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'High Score: ${game.highScore}',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                game.resetGame();
                game.overlays.remove('gameOver');
                game.overlays.add('score');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
              ),
              child: const Text('Play Again', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
