import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:g6_flutter/src/elements/base/base_node.dart';
import 'package:g6_flutter/src/types/node.dart';

/// Star node shape (5-pointed star)
class StarNode extends BaseNode {
  const StarNode();

  @override
  void paint(Canvas canvas, Offset center, dynamic style) {
    final nodeStyle = style as NodeStyle;
    final size = nodeStyle.size?.width ?? 50;
    final outerRadius = size / 2;
    final innerRadius = outerRadius * 0.4;

    final path = Path();
    const points = 5;

    for (var i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (math.pi / points) * i - math.pi / 2;
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
