import 'package:flutter/material.dart';
import 'package:g6_flutter/src/elements/base/base_shape.dart';
import 'package:g6_flutter/src/types/edge.dart';
import 'package:g6_flutter/src/types/point.dart';

/// Base edge class
abstract class BaseEdge extends BaseShape {
  const BaseEdge();

  /// Paint edge with label
  void paintEdge(Canvas canvas, Offset start, Offset end, EdgeStyle style) {
    // Paint main edge
    paint(canvas, start, style);

    // Paint label if present
    if (style.labelText != null) {
      paintLabel(canvas, start, end, style);
    }
  }

  void paintLabel(Canvas canvas, Offset start, Offset end, EdgeStyle style) {
    final label = style.label;
    final text = style.labelText!;

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: label?.fill ?? Colors.black,
          fontSize: label?.fontSize ?? 10,
          backgroundColor: Colors.white.withOpacity(0.8),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Calculate label position
    final placement = label?.placement ?? EdgeLabelPlacement.center;
    double t;

    switch (placement) {
      case EdgeLabelPlacement.start:
        t = 0.2;
        break;
      case EdgeLabelPlacement.center:
        t = 0.5;
        break;
      case EdgeLabelPlacement.end:
        t = 0.8;
        break;
    }

    if (label?.placementRatio != null) {
      t = label!.placementRatio!;
    }

    final labelX = start.dx + (end.dx - start.dx) * t;
    final labelY = start.dy + (end.dy - start.dy) * t;

    final offsetX = label?.offsetX ?? 0;
    final offsetY = label?.offsetY ?? 0;

    textPainter.paint(
      canvas,
      Offset(
        labelX - textPainter.width / 2 + offsetX,
        labelY - textPainter.height / 2 + offsetY,
      ),
    );
  }

  /// Get point along edge at ratio t (0-1)
  Offset getPointAt(Offset start, Offset end, double t);
}
