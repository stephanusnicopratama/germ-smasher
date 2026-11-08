import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/animation.dart';

import '../germ_smasher_game.dart';

class SoapBubble extends CircleComponent
    with TapCallbacks, HasGameReference<GermSmasherGame> {
  SoapBubble({
    required Vector2 position,
    required this.velocity,
    required this.lifetime,
  }) : super(
          radius: 34,
          position: position,
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFF9AD7FF),
        );

  final Vector2 velocity;
  final double lifetime;
  double age = 0;
  bool _gone = false;

  @override
  Future<void> onLoad() async {
    add(
      CircleComponent(
        radius: 12,
        anchor: Anchor.center,
        position: Vector2(-8, -8),
        paint: Paint()..color = const Color(0xCCFFFFFF),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_gone) {
      return;
    }
    age += dt;
    position += velocity * dt;
    if (age >= lifetime) {
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
}
