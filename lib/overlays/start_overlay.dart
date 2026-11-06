import 'package:flutter/material.dart';

import '../game/germ_smasher_game.dart';

class StartOverlay extends StatelessWidget {
  const StartOverlay({super.key, required this.game});

  final GermSmasherGame game;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0x88000000),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.coronavirus,
              size: 88,
              color: Colors.green.shade300,
            ),
            const SizedBox(height: 24),
            Semantics(
              button: true,
              label: 'Play',
              child: Material(
                color: Colors.green.shade400,
                shape: const CircleBorder(),
                elevation: 8,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: game.startGame,
                  child: const SizedBox(
                    width: 120,
                    height: 120,
                    child: Icon(Icons.play_arrow, size: 72, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
