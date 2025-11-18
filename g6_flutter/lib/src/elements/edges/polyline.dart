import 'package:flutter/material.dart';
import 'package:g6_flutter/src/elements/base/base_edge.dart';
import 'package:g6_flutter/src/types/edge.dart';

/// Polyline edge shape (line with control points)
class PolylineEdge extends BaseEdge {
  const PolylineEdge();

  @override
  void paint(Canvas canvas, Offset center, dynamic style) {
    // Implemented via paintPolyline
  }

  void paintPolyline(
    Canvas canvas,
    Offset start,
    Offset end,
    EdgeStyle style,
    List<Offset>? controlPoints,
  ) {
    final paint = Paint()
      ..color = style.stroke ?? Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = style.lineWidth ?? 1;

    final path = Path()..moveTo(start.dx, start.dy);

    if (controlPoints != null && controlPoints.isNotEmpty) {
      for (final point in controlPoints) {
        path.lineTo(point.dx, point.dy);
      }
    }

    path.lineTo(end.dx, end.dy);

    canvas.drawPath(path, paint);
  }

  @override
  Offset getPointAt(Offset start, Offset end, double t) {
    // For simple polyline, return interpolated point
    return Offset(
      start.dx + (end.dx - start.dx) * t,
      start.dy + (end.dy - start.dy) * t,
    );
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
