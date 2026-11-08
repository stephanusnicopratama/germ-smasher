import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/animation.dart';

import '../config/game_config.dart';
import '../germ_smasher_game.dart';
import 'crawl_lane.dart';

class SoapBubble extends PositionComponent
    with TapCallbacks, HasGameReference<GermSmasherGame> {
  SoapBubble({
    required Vector2 position,
    required this.velocity,
    required this.spriteName,
    required double displayScale,
  }) : super(
          position: position,
          anchor: Anchor.center,
          scale: Vector2.all(displayScale),
        );

  static const sprites = [
    'bubble.png',
    'bubble_a.png',
    'bubble_b.png',
    'bubble_c.png',
  ];

  final Vector2 velocity;
  final String spriteName;
  bool _gone = false;
  double _wobble = 0;

  @override
  Future<void> onLoad() async {
    final sprite = Sprite(game.images.fromCache('bubbles/$spriteName'));
    size = sprite.srcSize;
    add(SpriteComponent(sprite: sprite, anchor: Anchor.center));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_gone) {
      return;
    }
    _wobble += dt;
    final lean = velocity.x == 0 ? 0.0 : (velocity.x > 0 ? 0.2 : -0.2);
    angle = lean + sin(_wobble * 2.2) * 0.06;
    position += velocity * dt;
    if (size.x <= 0) {
      return;
    }
    if (hasLeftScreen(
      position: position,
      velocity: velocity,
      screen: game.size,
      halfW: size.x * scale.x / 2,
      halfH: size.y * scale.y / 2,
    )) {
      _leaveSafely();
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_gone || !game.isPlaying) {
      return;
    }
    _gone = true;
    game.onSoapHit();
    add(
      ScaleEffect.by(
        Vector2.all(0.2),
        EffectController(duration: 0.12, curve: Curves.easeIn),
        onComplete: () {
          if (isMounted) {
            game.retire(this);
          }
        },
      ),
    );
  }

  void _leaveSafely() {
    _gone = true;
    game.onSoapSaved();
    game.retire(this);
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    final pad = GameConfig.tapHitPadding;
    return point.x.abs() <= size.x / 2 + pad &&
        point.y.abs() <= size.y / 2 + pad;
  }
}
