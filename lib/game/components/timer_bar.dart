import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class TimerBar extends PositionComponent with HasGameReference {
  late final RectangleComponent bar;
  late final Paint barPaint;
  double maxWidth = 0;

  TimerBar() : super(anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    // Make sure to call super.onLoad() first to properly initialize
    await super.onLoad();

    // Now it's safe to access game properties
    maxWidth = game.size.x;
    size = Vector2(maxWidth, GameConstants.timerBarHeight);
    position = Vector2(0, 0);

    barPaint = Paint()..color = GameConstants.timerBarColor;

    bar = RectangleComponent(
      size: Vector2(maxWidth, GameConstants.timerBarHeight),
      paint: barPaint,
    );

    add(bar);
  }

  void reset() {
    bar.size.x = maxWidth;
  }
}
