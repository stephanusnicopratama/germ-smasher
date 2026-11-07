import 'dart:math';

import 'package:flame/components.dart';

import '../config/germ_looks.dart';
import '../germ_smasher_game.dart';
import 'germ.dart';

class GermSpawner extends Component with HasGameReference<GermSmasherGame> {
  GermSpawner({Random? random}) : _random = random ?? Random();

  final Random _random;
  double _timer = 0;

  int get _germCount => game.children.whereType<Germ>().length;

  @override
  void update(double dt) {
    super.update(dt);
    if (!game.isPlaying) {
      return;
    }
    final level = game.level;
    _timer += dt;
    if (_timer < level.spawnInterval) {
      return;
    }
    _timer = 0;
    if (_germCount >= level.maxOnScreen) {
      return;
    }
    _spawnGerm();
  }

  void _spawnGerm() {
    final size = game.size;
    if (size.x <= 0 || size.y <= 0) {
      return;
    }
    final level = game.level;
    final margin = 90 * level.germScale;
    final spanX = max(1.0, size.x - margin * 2);
    final spanY = max(1.0, size.y - margin * 2);
    final position = Vector2(
      margin + _random.nextDouble() * spanX,
      margin + _random.nextDouble() * spanY,
    );
    final angle = _random.nextDouble() * pi * 2;
    final speed = level.minSpeed + _random.nextDouble() * (level.maxSpeed - level.minSpeed);
    final velocity = Vector2(cos(angle), sin(angle)) * speed;
    final screenBoost = (min(size.x, size.y) / 720).clamp(0.9, 1.45);
    game.enqueue(
      Germ(
        position: position,
        velocity: velocity,
        look: GermLook.looks[_random.nextInt(GermLook.looks.length)],
        displayScale: level.germScale * screenBoost,
      ),
    );
  }
}
