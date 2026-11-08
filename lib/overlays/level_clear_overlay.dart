import 'package:flutter/material.dart';

import '../game/germ_smasher_game.dart';

class LevelClearOverlay extends StatelessWidget {
  const LevelClearOverlay({super.key, required this.game});

  final GermSmasherGame game;

  @override
  Widget build(BuildContext context) {
    final finishedAll = game.isLastLevel;
    return ColoredBox(
      color: const Color(0x66000000),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              finishedAll ? Icons.emoji_events : Icons.star_rounded,
              size: 96,
              color: Colors.amber.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              '${game.score}',
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Semantics(
              button: true,
              label: finishedAll ? 'Play again' : 'Next level',
              child: Material(
                color: Colors.green.shade400,
                shape: const CircleBorder(),
                elevation: 8,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: finishedAll ? game.startGame : game.nextLevel,
                  child: SizedBox(
                    width: 110,
                    height: 110,
                    child: Icon(
                      finishedAll ? Icons.replay : Icons.arrow_forward,
                      size: 64,
                      color: Colors.white,
                    ),
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
