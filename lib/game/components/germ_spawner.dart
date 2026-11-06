import 'dart:math';

import 'package:flame/components.dart';

import '../config/game_config.dart';
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
    _timer += dt;
    if (_timer < GameConfig.spawnIntervalSeconds) {
      return;
    }
    _timer = 0;
    if (_germCount >= GameConfig.maxGermsOnScreen) {
      return;
    }
    _spawnGerm();
  }

  void _spawnGerm() {
    final size = game.size;
    if (size.x <= 0 || size.y <= 0) {
      return;
    }
    final margin = GameConfig.germRadius + 8;
    final position = Vector2(
      margin + _random.nextDouble() * (size.x - margin * 2),
      margin + _random.nextDouble() * (size.y - margin * 2),
    );
    final angle = _random.nextDouble() * pi * 2;
    final speed = GameConfig.minGermSpeed +
        _random.nextDouble() *
            (GameConfig.maxGermSpeed - GameConfig.minGermSpeed);
    final velocity = Vector2(cos(angle), sin(angle)) * speed;
    game.enqueue(
      Germ(
        position: position,
        velocity: velocity,
        color: randomGermColor(_random),
        game: game,
      ),
    );
  }
}
