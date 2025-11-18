import 'package:flutter/material.dart';
import 'package:g6_flutter/src/elements/base/base_edge.dart';
import 'package:g6_flutter/src/types/edge.dart';

/// Quadratic bezier edge
class QuadraticEdge extends BaseEdge {
  const QuadraticEdge();

  @override
  void paint(Canvas canvas, Offset center, dynamic style) {
    // Implemented via paintQuadratic
  }

  void paintQuadratic(
    Canvas canvas,
    Offset start,
    Offset end,
    EdgeStyle style,
  ) {
    final paint = Paint()
      ..color = style.stroke ?? Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = style.lineWidth ?? 1;

    // Calculate control point
    final controlPoint = _getControlPoint(start, end, style.curveOffset ?? 30);

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        end.dx,
        end.dy,
      );

    canvas.drawPath(path, paint);
  }

  Offset _getControlPoint(Offset start, Offset end, double offset) {
    final midX = (start.dx + end.dx) / 2;
    final midY = (start.dy + end.dy) / 2;

    // Calculate perpendicular offset
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final len = (dx * dx + dy * dy).abs();

    if (len == 0) return Offset(midX, midY);

    final perpX = -dy / len * offset;
    final perpY = dx / len * offset;

    return Offset(midX + perpX, midY + perpY);
  }

  @override
  Offset getPointAt(Offset start, Offset end, double t) {
    final controlPoint = _getControlPoint(start, end, 30);

    final x = (1 - t) * (1 - t) * start.dx +
        2 * (1 - t) * t * controlPoint.dx +
        t * t * end.dx;

    final y = (1 - t) * (1 - t) * start.dy +
        2 * (1 - t) * t * controlPoint.dy +
        t * t * end.dy;

    return Offset(x, y);
  }

  @override
  bool hitTest(Offset point, Offset center, dynamic style) {
    return false;
  }

  @override
  Rect getBounds(Offset center, dynamic style) {
    return Rect.zero;
  }
}
