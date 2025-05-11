import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../tap_the_dot_game.dart';

class Dot extends CircleComponent with TapCallbacks, HasGameRef<TapTheDotGame> {
  final VoidCallback onTimeout;
  late TimerComponent lifeTimer;
  bool isTapped = false;

  Dot({
    required Vector2 position,
    required double radius,
    required Color color,
    required this.onTimeout,
  }) : super(
         position: position,
         radius: radius,
         paint: Paint()..color = color,
         anchor: Anchor.center,
       );

  @override
  Future<void> onLoad() async {
    await super.onLoad(); // Make sure we call super.onLoad() first!

    // Set up timer for dot disappearance
    lifeTimer = TimerComponent(
      period: GameConstants.dotDuration,
      onTick: () {
        if (!isTapped) {
          onTimeout();
        }
        removeFromParent();
      },
    );
    add(lifeTimer);

    // Add a scale animation for appearance
    final scale = ScaleEffect.to(
      Vector2.all(1.2),
      EffectController(duration: 0.2, alternate: true),
    );
    add(scale);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!isTapped) {
      isTapped = true;
      gameRef.increaseScore();

      // Add scale down and fade out animation before removing
      final scaleDown = ScaleEffect.to(
        Vector2.zero(),
        EffectController(duration: 0.2),
      );

      add(
        scaleDown
          ..onComplete = () {
            removeFromParent();
          },
      );
    }
  }
}
