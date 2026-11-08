import 'dart:math';

import 'package:flame/components.dart';

import '../config/germ_looks.dart';
import '../germ_smasher_game.dart';
import 'crawl_lane.dart';
import 'germ.dart';
import 'soap_bubble.dart';

class GermSpawner extends Component with HasGameReference<GermSmasherGame> {
  GermSpawner({Random? random}) : _random = random ?? Random();

  final Random _random;
  double _timer = 0;

  int get _onScreen =>
      game.children.whereType<Germ>().length +
      game.children.whereType<SoapBubble>().length;

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
    if (_onScreen >= level.maxOnScreen) {
      return;
    }
    if (level.soapChance > 0 && _random.nextDouble() < level.soapChance) {
      _spawnSoap();
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
    final speed = level.minSpeed +
        _random.nextDouble() * (level.maxSpeed - level.minSpeed);
    final lane = CrawlLane.across(_random, size, speed, 90);
    final screenBoost = (min(size.x, size.y) / 720).clamp(0.9, 1.45);
    game.enqueue(
      Germ(
        position: lane.position,
        velocity: lane.velocity,
        look: GermLook.looks[_random.nextInt(GermLook.looks.length)],
        displayScale: level.germScale * screenBoost,
      ),
    );
  }

  void _spawnSoap() {
    final size = game.size;
    if (size.x <= 0 || size.y <= 0) {
      return;
    }
    final lane = CrawlLane.across(_random, size, game.level.minSpeed * 0.75, 70);
    final screenBoost = (min(size.x, size.y) / 720).clamp(0.9, 1.45);
    game.enqueue(
      SoapBubble(
        position: lane.position,
        velocity: lane.velocity,
        spriteName: SoapBubble.sprites[_random.nextInt(SoapBubble.sprites.length)],
        displayScale: game.level.germScale * screenBoost * 0.85,
      ),
    );
  }
}
