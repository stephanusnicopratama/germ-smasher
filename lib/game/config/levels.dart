class LevelDef {
  const LevelDef({
    required this.number,
    required this.goal,
    required this.maxOnScreen,
    required this.spawnInterval,
    required this.minSpeed,
    required this.maxSpeed,
    required this.germScale,
  });

  final int number;
  final int goal;
  final int maxOnScreen;
  final double spawnInterval;
  final double minSpeed;
  final double maxSpeed;
  final double germScale;
}

class LevelCatalog {
  static const levels = <LevelDef>[
    LevelDef(
      number: 1,
      goal: 5,
      maxOnScreen: 4,
      spawnInterval: 1.6,
      minSpeed: 22,
      maxSpeed: 42,
      germScale: 1.05,
    ),
    LevelDef(
      number: 2,
      goal: 8,
      maxOnScreen: 6,
      spawnInterval: 1.3,
      minSpeed: 32,
      maxSpeed: 58,
      germScale: 1.0,
    ),
    LevelDef(
      number: 3,
      goal: 10,
      maxOnScreen: 7,
      spawnInterval: 1.1,
      minSpeed: 42,
      maxSpeed: 74,
      germScale: 0.95,
    ),
    LevelDef(
      number: 4,
      goal: 12,
      maxOnScreen: 8,
      spawnInterval: 0.95,
      minSpeed: 52,
      maxSpeed: 90,
      germScale: 0.9,
    ),
    LevelDef(
      number: 5,
      goal: 15,
      maxOnScreen: 10,
      spawnInterval: 0.8,
      minSpeed: 64,
      maxSpeed: 108,
      germScale: 0.85,
    ),
  ];
}
