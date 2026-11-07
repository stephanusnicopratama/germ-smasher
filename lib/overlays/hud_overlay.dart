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
            Row(
              children: [
                _Pill(
                  icon: Icons.flag_rounded,
                  label: '${game.level.number}',
                ),
                const SizedBox(width: 8),
                _Pill(
                  icon: Icons.coronavirus,
                  label: '${game.smashedThisLevel}/${game.level.goal}',
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
