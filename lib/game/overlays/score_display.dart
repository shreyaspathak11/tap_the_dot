import 'package:flutter/material.dart';
import '../tap_the_dot_game.dart';

class ScoreDisplay extends StatefulWidget {
  final TapTheDotGame game;

  const ScoreDisplay({super.key, required this.game});

  @override
  State<ScoreDisplay> createState() => _ScoreDisplayState();
}

class _ScoreDisplayState extends State<ScoreDisplay> {
  @override
  void initState() {
    super.initState();
    // Add a listener to update the UI whenever the score changes
    widget.game.addScoreListener(_onScoreChanged);
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    widget.game.removeScoreListener(_onScoreChanged);
    super.dispose();
  }

  void _onScoreChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Score: ${widget.game.score}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 5,
                  color: Colors.black,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          Row(
            children: List.generate(
              widget.game.lives,
              (index) =>
                  const Icon(Icons.favorite, color: Colors.red, size: 30),
            ),
          ),
          IconButton(
            icon: Icon(
              widget.game.isPaused ? Icons.play_arrow : Icons.pause,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              widget.game.togglePause();
              setState(() {}); // Update pause button icon
            },
          ),
        ],
      ),
    );
  }
}
