import 'dart:math';

import 'game_config.dart';

class ScoreBook {
  int score = 0;
  int combo = 0;
  int hearts = GameConfig.startingHearts;
  double _lastSmashAt = -999;

  void reset() {
    score = 0;
    combo = 0;
    hearts = GameConfig.startingHearts;
    _lastSmashAt = -999;
  }

  int smash({required double now, required bool quick}) {
    if (now - _lastSmashAt <= GameConfig.comboWindowSeconds) {
      combo += 1;
    } else {
      combo = 1;
    }
    _lastSmashAt = now;
    var points = 10 * combo;
    if (quick) {
      points += 5;
    }
    score += points;
    return points;
  }

  void miss() {
    combo = 0;
    score = max(0, score - 5);
    hearts = max(0, hearts - 1);
  }

  void soapHit() {
    combo = 0;
    score = max(0, score - 10);
    hearts = max(0, hearts - 1);
  }

  void soapSaved() {
    score += 2;
  }

  void levelClearBonus(int levelNumber) {
    score += 20 * levelNumber;
  }
}
