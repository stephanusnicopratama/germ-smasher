import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:germ_smasher/game/components/germ.dart';
import 'package:germ_smasher/game/config/game_config.dart';
import 'package:germ_smasher/game/germ_smasher_game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('spawner respects max germs on screen', () async {
    final game = GermSmasherGame(
      onStateChanged: () {},
      showStartOverlayOnLoad: false,
    );
    game.isPlaying = true;
    await game.onLoad();
    game.onGameResize(Vector2(400, 800));

    for (var i = 0; i < GameConfig.maxGermsOnScreen + 5; i++) {
      game.update(GameConfig.spawnIntervalSeconds + 0.01);
    }

    expect(
      game.children.whereType<Germ>().length,
      lessThanOrEqualTo(GameConfig.maxGermsOnScreen),
    );
  });
}
