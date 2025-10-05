import 'package:flutter/material.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';

class NeonChart extends StatelessWidget {
  const NeonChart({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _NeonPainter(),
      size: const Size(double.infinity, 160),
    );
  }
}

class _NeonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final path = Path();
    // A sample wavy path similar to image
    final steps = 7;
    for (int i = 0; i <= steps; i++) {
      final x = size.width * (i / steps);
      final y =
          size.height * (0.5 + 0.35 * (i % 2 == 0 ? -1 : 1) * (i / steps));
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);

    // draw small dots for days
    final labelPaint = Paint()..color = Colors.white38;
    final dotY = size.height - 4;
    for (int i = 0; i < 7; i++) {
      final dx = size.width * (i / 6);
      canvas.drawCircle(Offset(dx, dotY), 3, labelPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

