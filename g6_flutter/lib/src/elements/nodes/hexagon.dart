import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:g6_flutter/src/elements/base/base_node.dart';
import 'package:g6_flutter/src/types/node.dart';

/// Hexagon node shape
class HexagonNode extends BaseNode {
  const HexagonNode();

  @override
  void paint(Canvas canvas, Offset center, dynamic style) {
    final nodeStyle = style as NodeStyle;
    final size = nodeStyle.size?.width ?? 50;
    final radius = size / 2;

    final path = Path();

    for (var i = 0; i < 6; i++) {
      final angle = (math.pi / 3) * i - math.pi / 2; // Start from top
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // Draw fill
    if (nodeStyle.fill != null) {
      final fillPaint = Paint()
        ..color = nodeStyle.fill!
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
    }

    // Draw stroke
    if (nodeStyle.stroke != null) {
      final strokePaint = Paint()
        ..color = nodeStyle.stroke!
        ..style = PaintingStyle.stroke
        ..strokeWidth = nodeStyle.lineWidth ?? 2;
      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool hitTest(Offset point, Offset center, dynamic style) {
    final nodeStyle = style as NodeStyle;
    final size = nodeStyle.size?.width ?? 50;
    final radius = size / 2;

    final dx = point.dx - center.dx;
    final dy = point.dy - center.dy;

    return (dx * dx + dy * dy) <= (radius * radius);
  }

  @override
  Rect getBounds(Offset center, dynamic style) {
    final nodeStyle = style as NodeStyle;
    final size = nodeStyle.size?.width ?? 50;

    return Rect.fromCircle(center: center, radius: size / 2);
  }
}
