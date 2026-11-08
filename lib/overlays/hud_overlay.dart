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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Hearts(hearts: game.hearts),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _Pill(
                      icon: Icons.star_rounded,
                      label: '${game.score}',
                    ),
                    const SizedBox(width: 8),
                    _Pill(
                      icon: Icons.flag_rounded,
                      label: '${game.level.number}',
                    ),
                    const SizedBox(width: 8),
                    _Pill(
                      icon: Icons.coronavirus,
                      label: '${game.smashedThisLevel}/${game.level.goal}',
                    ),
                    if (game.combo > 1) ...[
                      const SizedBox(width: 8),
                      _Pill(
                        icon: Icons.bolt,
                        label: 'x${game.combo}',
                      ),
                    ],
                  ],
                ),
              ],
            ),
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

class _Hearts extends StatelessWidget {
  const _Hearts({required this.hearts});

  final int hearts;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 4; i++)
          Icon(
            i < hearts ? Icons.favorite : Icons.favorite_border,
            color: Colors.red.shade400,
            size: 26,
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
          Icon(icon, color: Colors.green.shade700, size: 26),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
