import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'components/germ.dart';
import 'components/germ_spawner.dart';
import 'components/playfield_background.dart';
import 'config/germ_looks.dart';
import 'config/levels.dart';

class GermSmasherGame extends FlameGame {
  GermSmasherGame({
    required this.onStateChanged,
    this.showStartOverlayOnLoad = true,
  });

  final void Function() onStateChanged;

  /// When false, skips `overlays.add` in [onLoad] (needed in unit tests without [GameWidget]).
  final bool showStartOverlayOnLoad;

  int score = 0;
  int levelIndex = 0;
  int smashedThisLevel = 0;
  bool isPlaying = false;
  bool soundEnabled = false;

  LevelDef get level => LevelCatalog.levels[levelIndex];
  bool get isLastLevel => levelIndex >= LevelCatalog.levels.length - 1;

  late final GermSpawner _spawner;
  final List<Component> _pendingAdds = [];

  /// Queues [child] to be added before the next [update] pass (avoids concurrent modification).
  void enqueue(Component child) {
    _pendingAdds.add(child);
  }

  @override
  void update(double dt) {
    if (_pendingAdds.isNotEmpty) {
      final batch = List<Component>.from(_pendingAdds);
      _pendingAdds.clear();
      for (final c in batch) {
        add(c);
      }
    }
    super.update(dt);
  }

  @override
  Color backgroundColor() => const Color(0xFFE8F4FC);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await images.loadAll([
      for (final name in GermLook.assetFiles) 'germs/$name',
    ]);
    add(PlayfieldBackground());
    _spawner = GermSpawner();
    add(_spawner);
    if (showStartOverlayOnLoad) {
      _tryOverlay('start');
    }
  }

  void _tryOverlay(String name) {
    try {
      overlays.add(name);
    } catch (_) {
      // Unit tests construct the game without a GameWidget overlay map.
    }
  }

  void startGame() {
    score = 0;
    levelIndex = 0;
    smashedThisLevel = 0;
    isPlaying = true;
    children.whereType<Germ>().forEach((g) => g.removeFromParent());
    overlays.remove('start');
    overlays.remove('clear');
    _tryOverlay('hud');
    _notify();
  }

  void nextLevel() {
    if (!isLastLevel) {
      levelIndex += 1;
    }
    smashedThisLevel = 0;
    isPlaying = true;
    children.whereType<Germ>().forEach((g) => g.removeFromParent());
    overlays.remove('clear');
    _tryOverlay('hud');
    _notify();
  }

  void stopToMenu() {
    isPlaying = false;
    children.whereType<Germ>().forEach((g) => g.removeFromParent());
    overlays.remove('hud');
    overlays.remove('clear');
    _tryOverlay('start');
    _notify();
  }

  void toggleSound() {
    soundEnabled = !soundEnabled;
    _notify();
  }

  void onGermSmashed() {
    score += 1;
    smashedThisLevel += 1;
    if (smashedThisLevel >= level.goal) {
      isPlaying = false;
      _tryOverlay('clear');
    }
    _notify();
  }

  void _notify() {
    onStateChanged();
  }
}
