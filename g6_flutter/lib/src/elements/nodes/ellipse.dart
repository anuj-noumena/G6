import 'package:flutter/material.dart';
import 'package:g6_flutter/src/elements/base/base_node.dart';
import 'package:g6_flutter/src/types/node.dart';

/// Ellipse node shape
class EllipseNode extends BaseNode {
  const EllipseNode();

  @override
  void paint(Canvas canvas, Offset center, dynamic style) {
    final nodeStyle = style as NodeStyle;
    final width = nodeStyle.size?.width ?? 80;
    final height = nodeStyle.size?.height ?? 40;

    final rect = Rect.fromCenter(
      center: center,
      width: width,
      height: height,
    );

    // Draw fill
    if (nodeStyle.fill != null) {
      final fillPaint = Paint()
        ..color = nodeStyle.fill!
        ..style = PaintingStyle.fill;
      canvas.drawOval(rect, fillPaint);
    }

    // Draw stroke
    if (nodeStyle.stroke != null) {
      final strokePaint = Paint()
        ..color = nodeStyle.stroke!
        ..style = PaintingStyle.stroke
        ..strokeWidth = nodeStyle.lineWidth ?? 2;
      canvas.drawOval(rect, strokePaint);
    }
  }

  @override
  bool hitTest(Offset point, Offset center, dynamic style) {
    final nodeStyle = style as NodeStyle;
    final width = nodeStyle.size?.width ?? 80;
    final height = nodeStyle.size?.height ?? 40;

    final dx = (point.dx - center.dx) / (width / 2);
    final dy = (point.dy - center.dy) / (height / 2);

    return (dx * dx + dy * dy) <= 1;
  }

  @override
  Rect getBounds(Offset center, dynamic style) {
    final nodeStyle = style as NodeStyle;
    final width = nodeStyle.size?.width ?? 80;
    final height = nodeStyle.size?.height ?? 40;

    return Rect.fromCenter(
      center: center,
      width: width,
      height: height,
    );
  }
}
