import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'components/germ.dart';
import 'components/germ_spawner.dart';

class GermSmasherGame extends FlameGame {
  GermSmasherGame({
    required this.onStateChanged,
    this.showStartOverlayOnLoad = true,
  });

  final void Function() onStateChanged;

  /// When false, skips `overlays.add` in [onLoad] (needed in unit tests without [GameWidget]).
  final bool showStartOverlayOnLoad;

  int score = 0;
  bool isPlaying = false;
  bool soundEnabled = false;

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
    _spawner = GermSpawner();
    add(_spawner);
    if (showStartOverlayOnLoad) {
      overlays.add('start');
    }
  }

  void startGame() {
    score = 0;
    isPlaying = true;
    children.whereType<Germ>().forEach((g) => g.removeFromParent());
    overlays.remove('start');
    overlays.add('hud');
    _notify();
  }

  void stopToMenu() {
    isPlaying = false;
    children.whereType<Germ>().forEach((g) => g.removeFromParent());
    overlays.remove('hud');
    overlays.add('start');
    _notify();
  }

  void toggleSound() {
    soundEnabled = !soundEnabled;
    _notify();
  }

  void onGermSmashed() {
    score += 1;
    _notify();
  }

  void _notify() {
    onStateChanged();
  }
}
