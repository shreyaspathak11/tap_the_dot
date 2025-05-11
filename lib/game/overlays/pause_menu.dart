import 'package:flutter/material.dart';
import '../tap_the_dot_game.dart';
import '../../utils/audio_manager.dart';

class PauseMenu extends StatelessWidget {
  final TapTheDotGame game;

  const PauseMenu({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Paused',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              icon: const Icon(Icons.play_arrow, color: Colors.white),
              onPressed: () {
                game.togglePause();
              },
              label: const Text(
                'Resume',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              icon: Icon(
                AudioManager.isMuted ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
              ),
              onPressed: () {
                AudioManager.toggleMute();
                // This would need a setState in a StatefulWidget, so here we just toggling
              },
              label: Text(
                AudioManager.isMuted ? 'Unmute' : 'Mute',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                game.togglePause(); // Unpause first
                game.reset();
              },
              label: const Text(
                'Restart',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
