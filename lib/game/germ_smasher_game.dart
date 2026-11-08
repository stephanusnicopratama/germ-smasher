import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'audio/game_sfx.dart';
import 'components/germ.dart';
import 'components/germ_spawner.dart';
import 'components/playfield_background.dart';
import 'components/soap_bubble.dart';
import 'config/germ_looks.dart';
import 'config/levels.dart';
import 'config/score_book.dart';

class GermSmasherGame extends FlameGame {
  GermSmasherGame({
    required this.onStateChanged,
    this.showStartOverlayOnLoad = true,
    this.sfx,
  });

  final void Function() onStateChanged;
  final GameSfx? sfx;

  /// When false, skips `overlays.add` in [onLoad] (needed in unit tests without [GameWidget]).
  final bool showStartOverlayOnLoad;

  final ScoreBook rules = ScoreBook();
  int levelIndex = 0;
  int smashedThisLevel = 0;
  int lastPoints = 0;
  double elapsed = 0;
  bool isPlaying = false;
  bool soundEnabled = true;

  int get score => rules.score;
  int get combo => rules.combo;
  int get hearts => rules.hearts;

  LevelDef get level => LevelCatalog.levels[levelIndex];
  bool get isLastLevel => levelIndex >= LevelCatalog.levels.length - 1;

  late final GermSpawner _spawner;
  final List<Component> _pendingAdds = [];
  final List<Component> _pendingRemoves = [];

  /// Queues [child] to be added before the next [update] pass (avoids concurrent modification).
  void enqueue(Component child) {
    _pendingAdds.add(child);
  }

  void retire(Component child) {
    _pendingRemoves.add(child);
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
    if (_pendingRemoves.isNotEmpty) {
      final batch = List<Component>.from(_pendingRemoves);
      _pendingRemoves.clear();
      for (final c in batch) {
        c.removeFromParent();
      }
    }
    if (isPlaying) {
      elapsed += dt;
    }
  }

  @override
  Color backgroundColor() => const Color(0xFFE8F4FC);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await images.loadAll([
      for (final name in GermLook.assetFiles) 'germs/$name',
      for (final name in SoapBubble.sprites) 'bubbles/$name',
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
    rules.reset();
    levelIndex = 0;
    smashedThisLevel = 0;
    lastPoints = 0;
    elapsed = 0;
    isPlaying = true;
    _clearActors();
    overlays.remove('start');
    overlays.remove('clear');
    overlays.remove('fail');
    _tryOverlay('hud');
    sfx?.enabled = soundEnabled;
    sfx?.playPop();
    _notify();
  }

  void nextLevel() {
    if (!isLastLevel) {
      levelIndex += 1;
    }
    smashedThisLevel = 0;
    elapsed = 0;
    isPlaying = true;
    _clearActors();
    overlays.remove('clear');
    _tryOverlay('hud');
    _notify();
  }

  void stopToMenu() {
    isPlaying = false;
    _clearActors();
    overlays.remove('hud');
    overlays.remove('clear');
    overlays.remove('fail');
    _tryOverlay('start');
    _notify();
  }

  void toggleSound() {
    soundEnabled = !soundEnabled;
    sfx?.enabled = soundEnabled;
    if (soundEnabled) {
      sfx?.playPop();
    }
    _notify();
  }

  void onGermSmashed({required bool quick}) {
    if (!isPlaying) {
      return;
    }
    lastPoints = rules.smash(now: elapsed, quick: quick);
    smashedThisLevel += 1;
    sfx?.playPop();
    if (smashedThisLevel >= level.goal) {
      rules.levelClearBonus(level.number);
      isPlaying = false;
      sfx?.playWin();
      _tryOverlay('clear');
    }
    _notify();
  }

  void onGermEscaped() {
    if (!isPlaying) {
      return;
    }
    rules.miss();
    sfx?.playMiss();
    _checkHearts();
    _notify();
  }

  void onSoapHit() {
    if (!isPlaying) {
      return;
    }
    rules.soapHit();
    sfx?.playSoap();
    _checkHearts();
    _notify();
  }

  void onSoapSaved() {
    if (!isPlaying) {
      return;
    }
    rules.soapSaved();
    _notify();
  }

  void _checkHearts() {
    if (rules.hearts > 0) {
      return;
    }
    isPlaying = false;
    _tryOverlay('fail');
  }

  void _clearActors() {
    children.whereType<Germ>().forEach((g) => g.removeFromParent());
    children.whereType<SoapBubble>().forEach((g) => g.removeFromParent());
  }

  void _notify() {
    onStateChanged();
  }
}
