import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:germ_smasher/game/components/germ.dart';
import 'package:germ_smasher/game/config/levels.dart';
import 'package:germ_smasher/game/germ_smasher_game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('spawner respects the current level cap', () async {
    final game = GermSmasherGame(
      onStateChanged: () {},
      showStartOverlayOnLoad: false,
    );
    game.isPlaying = true;
    await game.onLoad();
    game.onGameResize(Vector2(400, 800));

    final level = LevelCatalog.levels.first;
    for (var i = 0; i < level.maxOnScreen + 5; i++) {
      game.update(level.spawnInterval + 0.01);
    }

    expect(
      game.children.whereType<Germ>().length,
      lessThanOrEqualTo(level.maxOnScreen),
    );
  });

  test('reaching the level goal stops play', () {
    final game = GermSmasherGame(
      onStateChanged: () {},
      showStartOverlayOnLoad: false,
    );
    game.isPlaying = true;
    for (var i = 0; i < game.level.goal; i++) {
      game.onGermSmashed(quick: false);
    }
    expect(game.isPlaying, isFalse);
    expect(game.smashedThisLevel, game.level.goal);
    expect(game.score, greaterThan(0));
  });
}
