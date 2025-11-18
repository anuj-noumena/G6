import 'package:flutter/material.dart';
import 'package:g6_flutter/src/elements/base/base_node.dart';
import 'package:g6_flutter/src/types/node.dart';

/// Rectangle node shape
class RectNode extends BaseNode {
  const RectNode();

  @override
  void paint(Canvas canvas, Offset center, dynamic style) {
    final nodeStyle = style as NodeStyle;
    final width = nodeStyle.size?.width ?? 60;
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
      canvas.drawRect(rect, fillPaint);
    }

    // Draw stroke
    if (nodeStyle.stroke != null) {
      final strokePaint = Paint()
        ..color = nodeStyle.stroke!
        ..style = PaintingStyle.stroke
        ..strokeWidth = nodeStyle.lineWidth ?? 2;
      canvas.drawRect(rect, strokePaint);
    }
  }

  @override
  bool hitTest(Offset point, Offset center, dynamic style) {
    final nodeStyle = style as NodeStyle;
    final width = nodeStyle.size?.width ?? 60;
    final height = nodeStyle.size?.height ?? 40;

    final rect = Rect.fromCenter(
      center: center,
      width: width,
      height: height,
    );

    return rect.contains(point);
  }

  @override
  Rect getBounds(Offset center, dynamic style) {
    final nodeStyle = style as NodeStyle;
    final width = nodeStyle.size?.width ?? 60;
    final height = nodeStyle.size?.height ?? 40;

    return Rect.fromCenter(
      center: center,
      width: width,
      height: height,
    );
  }
}
