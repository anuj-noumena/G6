import 'package:flutter/material.dart';
import 'package:g6_flutter/src/elements/base/base_edge.dart';
import 'package:g6_flutter/src/types/edge.dart';

/// Cubic bezier edge
class CubicEdge extends BaseEdge {
  const CubicEdge();

  @override
  void paint(Canvas canvas, Offset center, dynamic style) {
    // Implemented via paintCubic
  }

  void paintCubic(
    Canvas canvas,
    Offset start,
    Offset end,
    EdgeStyle style,
  ) {
    final paint = Paint()
      ..color = style.stroke ?? Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = style.lineWidth ?? 1;

    // Calculate control points
    final controlPoints = _getControlPoints(start, end, style.curveOffset ?? 30);

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        controlPoints[0].dx,
        controlPoints[0].dy,
        controlPoints[1].dx,
        controlPoints[1].dy,
        end.dx,
        end.dy,
      );

    canvas.drawPath(path, paint);
  }

  List<Offset> _getControlPoints(Offset start, Offset end, double offset) {
    final midX = (start.dx + end.dx) / 2;
    final midY = (start.dy + end.dy) / 2;

    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;

    // First control point
    final cp1X = start.dx + dx * 0.3;
    final cp1Y = start.dy + dy * 0.3 - offset;

    // Second control point
    final cp2X = start.dx + dx * 0.7;
    final cp2Y = start.dy + dy * 0.7 + offset;

    return [
      Offset(cp1X, cp1Y),
      Offset(cp2X, cp2Y),
    ];
  }

  @override
  Offset getPointAt(Offset start, Offset end, double t) {
    final controlPoints = _getControlPoints(start, end, 30);
    final cp1 = controlPoints[0];
    final cp2 = controlPoints[1];

    final x = (1 - t) * (1 - t) * (1 - t) * start.dx +
        3 * (1 - t) * (1 - t) * t * cp1.dx +
        3 * (1 - t) * t * t * cp2.dx +
        t * t * t * end.dx;

    final y = (1 - t) * (1 - t) * (1 - t) * start.dy +
        3 * (1 - t) * (1 - t) * t * cp1.dy +
        3 * (1 - t) * t * t * cp2.dy +
        t * t * t * end.dy;

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
