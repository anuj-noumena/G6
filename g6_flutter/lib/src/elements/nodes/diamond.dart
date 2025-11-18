import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:g6_flutter/src/elements/base/base_node.dart';
import 'package:g6_flutter/src/types/node.dart';

/// Diamond node shape
class DiamondNode extends BaseNode {
  const DiamondNode();

  @override
  void paint(Canvas canvas, Offset center, dynamic style) {
    final nodeStyle = style as NodeStyle;
    final width = nodeStyle.size?.width ?? 60;
    final height = nodeStyle.size?.height ?? 60;

    final path = Path()
      ..moveTo(center.dx, center.dy - height / 2) // Top
      ..lineTo(center.dx + width / 2, center.dy) // Right
      ..lineTo(center.dx, center.dy + height / 2) // Bottom
      ..lineTo(center.dx - width / 2, center.dy) // Left
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
    final width = nodeStyle.size?.width ?? 60;
    final height = nodeStyle.size?.height ?? 60;

    // Check if point is within diamond bounds
    final dx = (point.dx - center.dx).abs();
    final dy = (point.dy - center.dy).abs();

    return (dx / (width / 2) + dy / (height / 2)) <= 1;
  }

  @override
  Rect getBounds(Offset center, dynamic style) {
    final nodeStyle = style as NodeStyle;
    final width = nodeStyle.size?.width ?? 60;
    final height = nodeStyle.size?.height ?? 60;

    return Rect.fromCenter(
      center: center,
      width: width,
      height: height,
    );
  }
}
