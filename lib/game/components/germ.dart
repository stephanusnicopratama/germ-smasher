import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/animation.dart';

import '../config/game_config.dart';
import '../config/germ_looks.dart';
import '../germ_smasher_game.dart';

class Germ extends PositionComponent with TapCallbacks, HasGameReference<GermSmasherGame> {
  Germ({
    required Vector2 position,
    required this.velocity,
    required this.look,
    required this.lifetime,
    required double displayScale,
  })  : _baseScale = displayScale,
        super(
          position: position,
          anchor: Anchor.center,
          scale: Vector2.all(displayScale),
        );

  final Vector2 velocity;
  final GermLook look;
  final double lifetime;
  final double _baseScale;
  bool _smashed = false;
  bool _escaped = false;
  double age = 0;
  double _wobble = 0;

  @override
  Future<void> onLoad() async {
    final body = Sprite(game.images.fromCache('germs/${look.body}'));
    size = body.srcSize;
    add(SpriteComponent(sprite: body, anchor: Anchor.center));
    final eye = Sprite(game.images.fromCache('germs/${look.eye}'));
    add(
      SpriteComponent(
        sprite: eye,
        anchor: Anchor.center,
        position: Vector2(-size.x * 0.16, -size.y * 0.06),
      ),
    );
    add(
      SpriteComponent(
        sprite: eye,
        anchor: Anchor.center,
        position: Vector2(size.x * 0.16, -size.y * 0.06),
      ),
    );
    add(
      SpriteComponent(
        sprite: Sprite(game.images.fromCache('germs/${look.mouth}')),
        anchor: Anchor.center,
        position: Vector2(0, size.y * 0.2),
      ),
    );
    final extra = look.extra;
    if (extra != null) {
      add(
        SpriteComponent(
          sprite: Sprite(game.images.fromCache('germs/$extra')),
          anchor: Anchor.center,
          position: Vector2(0, size.y * look.extraY),
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_smashed || _escaped) {
      return;
    }
    age += dt;
    _wobble += dt;
    angle = sin(_wobble * 3) * 0.08;
    if (age > lifetime * 0.7) {
      final pulse = 1 + sin(_wobble * 16) * 0.08;
      scale = Vector2.all(_baseScale * pulse);
    }
    if (age >= lifetime) {
      _escape();
      return;
    }
    position += velocity * dt;
    final bounds = game.size;
    if (bounds.x <= 0 || bounds.y <= 0 || size.x <= 0) {
      return;
    }
    final halfW = size.x * scale.x / 2;
    final halfH = size.y * scale.y / 2;
    if (position.x <= halfW || position.x >= bounds.x - halfW) {
      velocity.x = -velocity.x;
      position.x = position.x.clamp(halfW, bounds.x - halfW).toDouble();
    }
    if (position.y <= halfH || position.y >= bounds.y - halfH) {
      velocity.y = -velocity.y;
      position.y = position.y.clamp(halfH, bounds.y - halfH).toDouble();
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_smashed || !game.isPlaying) {
      return;
    }
    _smash();
  }

  void _escape() {
    _escaped = true;
    game.onGermEscaped();
    game.retire(this);
  }

  void _smash() {
    _smashed = true;
    final quick = age < lifetime * 0.45;
    game.onGermSmashed(quick: quick);
    add(
      ScaleEffect.by(
        Vector2.all(1.28),
        EffectController(duration: 0.12, curve: Curves.easeOut),
        onComplete: () {
          if (isMounted) {
            game.retire(this);
          }
        },
      ),
    );
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    final pad = GameConfig.tapHitPadding;
    return point.x.abs() <= size.x / 2 + pad && point.y.abs() <= size.y / 2 + pad;
  }
}
