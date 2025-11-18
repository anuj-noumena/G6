import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:g6_flutter/src/elements/base/base_node.dart';
import 'package:g6_flutter/src/types/node.dart';

/// Triangle node shape
class TriangleNode extends BaseNode {
  const TriangleNode();

  @override
  void paint(Canvas canvas, Offset center, dynamic style) {
    final nodeStyle = style as NodeStyle;
    final size = nodeStyle.size?.width ?? 50;

    final height = size * math.sqrt(3) / 2;

    final path = Path()
      ..moveTo(center.dx, center.dy - height * 2 / 3) // Top
      ..lineTo(center.dx + size / 2, center.dy + height / 3) // Bottom right
      ..lineTo(center.dx - size / 2, center.dy + height / 3) // Bottom left
      ..close();

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
    final height = size * math.sqrt(3) / 2;

    // Simple bounding box check
    final bounds = Rect.fromCenter(
      center: center,
      width: size,
      height: height,
    );

    return bounds.contains(point);
  }

  @override
  Rect getBounds(Offset center, dynamic style) {
    final nodeStyle = style as NodeStyle;
    final size = nodeStyle.size?.width ?? 50;
    final height = size * math.sqrt(3) / 2;

    return Rect.fromCenter(
      center: center,
      width: size,
      height: height,
    );
  }
}
