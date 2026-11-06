import 'package:flutter/material.dart';

import '../game/germ_smasher_game.dart';

class HudOverlay extends StatelessWidget {
  const HudOverlay({super.key, required this.game});

  final GermSmasherGame game;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ScoreBadge(score: game.score),
            Row(
              children: [
                IconButton.filledTonal(
                  tooltip: game.soundEnabled ? 'Mute' : 'Sound',
                  onPressed: game.toggleSound,
                  icon: Icon(
                    game.soundEnabled ? Icons.volume_up : Icons.volume_off,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: 'Home',
                  onPressed: game.stopToMenu,
                  icon: const Icon(Icons.home),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 2),
            color: Color(0x22000000),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.coronavirus, color: Colors.green.shade600, size: 28),
          const SizedBox(width: 8),
          Text(
            '$score',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
