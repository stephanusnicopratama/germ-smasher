import 'dart:ui';

import 'package:flame/components.dart';

import '../germ_smasher_game.dart';

class PlayfieldBackground extends Component with HasGameReference<GermSmasherGame> {
  @override
  void render(Canvas canvas) {
    final size = game.size;
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final paint = Paint()
      ..shader = Gradient.linear(
        const Offset(0, 0),
        Offset(0, size.y),
        const [
          Color(0xFFB7E4F8),
          Color(0xFFE8FFF4),
          Color(0xFFFFF6D8),
        ],
        const [0, 0.55, 1],
      );
    canvas.drawRect(rect, paint);

    final bubble = Paint()..color = const Color(0x55FFFFFF);
    canvas.drawCircle(Offset(size.x * 0.18, size.y * 0.22), 28, bubble);
    canvas.drawCircle(Offset(size.x * 0.78, size.y * 0.16), 18, bubble);
    canvas.drawCircle(Offset(size.x * 0.62, size.y * 0.72), 36, bubble);
    canvas.drawCircle(Offset(size.x * 0.12, size.y * 0.78), 14, bubble);
  }
}
