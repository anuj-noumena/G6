import 'package:flutter/material.dart';
import 'package:g6_flutter/src/elements/base/base_edge.dart';
import 'package:g6_flutter/src/types/edge.dart';

/// Line edge shape (straight line)
class LineEdge extends BaseEdge {
  const LineEdge();

  @override
  void paint(Canvas canvas, Offset center, dynamic style) {
    // Center is start point for edges
    // End point should be passed via style or separate parameter
    final edgeStyle = style as EdgeStyle;

    // This will be called from a higher level with proper start/end
  }

  void paintLine(Canvas canvas, Offset start, Offset end, EdgeStyle style) {
    final paint = Paint()
      ..color = style.stroke ?? Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = style.lineWidth ?? 1;

    if (style.lineDash != null && style.lineDash!.isNotEmpty) {
      _drawDashedLine(canvas, start, end, paint, style.lineDash!);
    } else {
      canvas.drawLine(start, end, paint);
    }
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
    List<double> dash,
  ) {
    final path = Path()..moveTo(start.dx, start.dy);

    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final length = (dx * dx + dy * dy).abs();

    final dashOn = dash[0];
    final dashOff = dash.length > 1 ? dash[1] : dash[0];

    var distance = 0.0;
    var draw = true;

    while (distance < length) {
      final dashLength = draw ? dashOn : dashOff;
      final nextDistance = distance + dashLength;

      if (nextDistance > length) {
        if (draw) {
          path.lineTo(end.dx, end.dy);
        }
        break;
      }

      final t = nextDistance / length;
      final x = start.dx + dx * t;
      final y = start.dy + dy * t;

      if (draw) {
        path.lineTo(x, y);
      } else {
        path.moveTo(x, y);
      }

      distance = nextDistance;
      draw = !draw;
    }

    canvas.drawPath(path, paint);
  }

  @override
  Offset getPointAt(Offset start, Offset end, double t) {
    return Offset(
      start.dx + (end.dx - start.dx) * t,
      start.dy + (end.dy - start.dy) * t,
    );
  }

  @override
  bool hitTest(Offset point, Offset center, dynamic style) {
    // Hit test for edge would need start and end points
    return false;
  }

  @override
  Rect getBounds(Offset center, dynamic style) {
    return Rect.zero;
  }
}
