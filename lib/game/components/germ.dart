import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart' show Colors;

import '../config/game_config.dart';
import '../germ_smasher_game.dart';

class Germ extends CircleComponent with TapCallbacks {
  Germ({
    required Vector2 position,
    required this.velocity,
    required this.color,
    required this.game,
  }) : super(
          radius: GameConfig.germRadius,
          position: position,
          anchor: Anchor.center,
          paint: Paint()..color = color,
        ) {
    add(
      CircleComponent(
        radius: GameConfig.germRadius * 0.35,
        anchor: Anchor.center,
        position: Vector2(-8, -6),
        paint: Paint()..color = const Color(0xFFFFFFFF).withValues(alpha: 0.35),
      ),
    );
  }

  final Vector2 velocity;
  final Color color;
  final GermSmasherGame game;
  bool _smashed = false;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final bounds = size;
    final minX = radius;
    final maxX = bounds.x - radius;
    final minY = radius;
    final maxY = bounds.y - radius;
    position.x = position.x.clamp(minX, maxX).toDouble();
    position.y = position.y.clamp(minY, maxY).toDouble();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_smashed) {
      return;
    }
    position += velocity * dt;
    final bounds = game.size;
    if (bounds.x <= 0 || bounds.y <= 0) {
      return;
    }
    final minX = radius;
    final maxX = bounds.x - radius;
    final minY = radius;
    final maxY = bounds.y - radius;
    if (position.x <= minX || position.x >= maxX) {
      velocity.x = -velocity.x;
      position.x = position.x.clamp(minX, maxX).toDouble();
    }
    if (position.y <= minY || position.y >= maxY) {
      velocity.y = -velocity.y;
      position.y = position.y.clamp(minY, maxY).toDouble();
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_smashed || !game.isPlaying) {
      return;
    }
    _smash();
  }

  void _smash() {
    _smashed = true;
    game.onGermSmashed();
    add(
      ScaleEffect.to(
        Vector2.all(1.6),
        EffectController(duration: 0.12, curve: Curves.easeOut),
        onComplete: () {
          if (isMounted) {
            removeFromParent();
          }
        },
      ),
    );
    paint.color = Colors.white.withValues(alpha: 0.85);
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return point.length <= radius + GameConfig.tapHitPadding;
  }
}

final _germColors = [
  const Color(0xFF7BC950),
  const Color(0xFF5ADBB5),
  const Color(0xFFB388FF),
  const Color(0xFFFFB74D),
  const Color(0xFF64B5F6),
];

Color randomGermColor(Random random) =>
    _germColors[random.nextInt(_germColors.length)];
