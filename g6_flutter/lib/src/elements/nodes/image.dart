import 'package:flutter/material.dart';
import 'package:g6_flutter/src/elements/base/base_node.dart';
import 'package:g6_flutter/src/types/node.dart';

/// Image node shape (placeholder - requires image loading)
class ImageNode extends BaseNode {
  const ImageNode();

  @override
  void paint(Canvas canvas, Offset center, dynamic style) {
    final nodeStyle = style as NodeStyle;
    final width = nodeStyle.size?.width ?? 60;
    final height = nodeStyle.size?.height ?? 60;

    final rect = Rect.fromCenter(
      center: center,
      width: width,
      height: height,
    );

    // Draw placeholder rectangle
    final fillPaint = Paint()
      ..color = nodeStyle.fill ?? Colors.grey.shade300
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, fillPaint);

    // Draw border
    final strokePaint = Paint()
      ..color = nodeStyle.stroke ?? Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = nodeStyle.lineWidth ?? 2;
    canvas.drawRect(rect, strokePaint);

    // Draw placeholder icon (camera icon)
    final iconPainter = TextPainter(
      text: const TextSpan(
        text: '📷',
        style: TextStyle(fontSize: 24),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    iconPainter.paint(
      canvas,
      Offset(
        center.dx - iconPainter.width / 2,
        center.dy - iconPainter.height / 2,
      ),
    );
  }

  @override
  bool hitTest(Offset point, Offset center, dynamic style) {
    final nodeStyle = style as NodeStyle;
    final width = nodeStyle.size?.width ?? 60;
    final height = nodeStyle.size?.height ?? 60;

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
    final height = nodeStyle.size?.height ?? 60;

    return Rect.fromCenter(
      center: center,
      width: width,
      height: height,
    );
  }
}
