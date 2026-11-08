import 'package:flutter/material.dart';

import '../game/germ_smasher_game.dart';

class FailOverlay extends StatelessWidget {
  const FailOverlay({super.key, required this.game});

  final GermSmasherGame game;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0x88000000),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.heart_broken, size: 88, color: Colors.red.shade300),
            const SizedBox(height: 8),
            Text(
              '${game.score}',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Semantics(
              button: true,
              label: 'Try again',
              child: Material(
                color: Colors.orange.shade400,
                shape: const CircleBorder(),
                elevation: 8,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: game.startGame,
                  child: const SizedBox(
                    width: 110,
                    height: 110,
                    child: Icon(Icons.replay, size: 64, color: Colors.white),
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
