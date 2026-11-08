import 'dart:math';

import 'package:flame/components.dart';

class CrawlLane {
  CrawlLane({required this.position, required this.velocity});

  final Vector2 position;
  final Vector2 velocity;

  /// Straight path from one edge to the opposite edge.
  static CrawlLane across(
    Random random,
    Vector2 screen,
    double speed,
    double inset,
  ) {
    final laneY = 88 + random.nextDouble() * max(1, screen.y - 140);
    final laneX = 28 + random.nextDouble() * max(1, screen.x - 56);
    switch (random.nextInt(4)) {
      case 0:
        return CrawlLane(
          position: Vector2(-inset, laneY),
          velocity: Vector2(speed, 0),
        );
      case 1:
        return CrawlLane(
          position: Vector2(screen.x + inset, laneY),
          velocity: Vector2(-speed, 0),
        );
      case 2:
        return CrawlLane(
          position: Vector2(laneX, -inset),
          velocity: Vector2(0, speed),
        );
      default:
        return CrawlLane(
          position: Vector2(laneX, screen.y + inset),
          velocity: Vector2(0, -speed),
        );
    }
  }
}

bool hasLeftScreen({
  required Vector2 position,
  required Vector2 velocity,
  required Vector2 screen,
  required double halfW,
  required double halfH,
}) {
  if (velocity.x > 0 && position.x - halfW > screen.x) {
    return true;
  }
  if (velocity.x < 0 && position.x + halfW < 0) {
    return true;
  }
  if (velocity.y > 0 && position.y - halfH > screen.y) {
    return true;
  }
  if (velocity.y < 0 && position.y + halfH < 0) {
    return true;
  }
  return false;
}

/// 0 at the entry edge, 1 at the exit edge.
double crawlProgress(Vector2 position, Vector2 velocity, Vector2 screen) {
  if (screen.x <= 0 || screen.y <= 0) {
    return 0;
  }
  if (velocity.x > 0) {
    return (position.x / screen.x).clamp(0, 1).toDouble();
  }
  if (velocity.x < 0) {
    return (1 - position.x / screen.x).clamp(0, 1).toDouble();
  }
  if (velocity.y > 0) {
    return (position.y / screen.y).clamp(0, 1).toDouble();
  }
  return (1 - position.y / screen.y).clamp(0, 1).toDouble();
}
