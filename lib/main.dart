import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/germ_smasher_game.dart';
import 'overlays/hud_overlay.dart';
import 'overlays/level_clear_overlay.dart';
import 'overlays/start_overlay.dart';

void main() {
  runApp(const GermSmasherApp());
}

class GermSmasherApp extends StatefulWidget {
  const GermSmasherApp({super.key});

  @override
  State<GermSmasherApp> createState() => _GermSmasherAppState();
}

class _GermSmasherAppState extends State<GermSmasherApp> {
  late final GermSmasherGame _game;

  @override
  void initState() {
    super.initState();
    _game = GermSmasherGame(onStateChanged: () => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (!_game.overlays.isActive('start') && !_game.isPlaying) {
        _game.overlays.add('start');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: GameWidget(
          game: _game,
          overlayBuilderMap: {
            'start': (context, game) =>
                StartOverlay(game: game as GermSmasherGame),
            'hud': (context, game) => HudOverlay(game: game as GermSmasherGame),
            'clear': (context, game) =>
                LevelClearOverlay(game: game as GermSmasherGame),
          },
        ),
      ),
    );
  }
}
