class LevelDef {
  const LevelDef({
    required this.number,
    required this.goal,
    required this.maxOnScreen,
    required this.spawnInterval,
    required this.minSpeed,
    required this.maxSpeed,
    required this.germScale,
    required this.lifetime,
    required this.soapChance,
  });

  final int number;
  final int goal;
  final int maxOnScreen;
  final double spawnInterval;
  final double minSpeed;
  final double maxSpeed;
  final double germScale;
  final double lifetime;
  final double soapChance;
}

class LevelCatalog {
  static const levels = <LevelDef>[
    LevelDef(
      number: 1,
      goal: 8,
      maxOnScreen: 5,
      spawnInterval: 1.15,
      minSpeed: 55,
      maxSpeed: 95,
      germScale: 0.95,
      lifetime: 5.2,
      soapChance: 0,
    ),
    LevelDef(
      number: 2,
      goal: 10,
      maxOnScreen: 6,
      spawnInterval: 0.95,
      minSpeed: 75,
      maxSpeed: 125,
      germScale: 0.9,
      lifetime: 4.4,
      soapChance: 0.16,
    ),
    LevelDef(
      number: 3,
      goal: 12,
      maxOnScreen: 7,
      spawnInterval: 0.8,
      minSpeed: 95,
      maxSpeed: 155,
      germScale: 0.84,
      lifetime: 3.6,
      soapChance: 0.22,
    ),
    LevelDef(
      number: 4,
      goal: 14,
      maxOnScreen: 8,
      spawnInterval: 0.68,
      minSpeed: 115,
      maxSpeed: 185,
      germScale: 0.78,
      lifetime: 3.1,
      soapChance: 0.28,
    ),
    LevelDef(
      number: 5,
      goal: 18,
      maxOnScreen: 9,
      spawnInterval: 0.55,
      minSpeed: 135,
      maxSpeed: 220,
      germScale: 0.72,
      lifetime: 2.6,
      soapChance: 0.32,
    ),
  ];
}
