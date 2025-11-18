import 'package:flutter/material.dart';
import 'package:g6_flutter/src/runtime/graph.dart';
import 'package:g6_flutter/src/types/size.dart';

/// Custom painter for rendering the graph
class GraphPainter extends CustomPainter {
  GraphPainter({required this.graph});

  final Graph graph;

  @override
  void paint(Canvas canvas, Size size) {
    final viewport = graph.viewportController;

    // Apply viewport transformations
    canvas.save();
    canvas.translate(viewport.offset.dx, viewport.offset.dy);
    canvas.scale(viewport.zoom);

    // Get graph data
    final data = graph.dataController.getData();

    // Draw edges first (so they appear behind nodes)
    if (data.edges != null) {
      for (final edge in data.edges!) {
        _drawEdge(canvas, edge);
      }
    }

    // Draw nodes
    if (data.nodes != null) {
      for (final node in data.nodes!) {
        _drawNode(canvas, node);
      }
    }

    // Draw combos
    if (data.combos != null) {
      for (final combo in data.combos!) {
        _drawCombo(canvas, combo);
      }
    }

    canvas.restore();
  }

  void _drawNode(Canvas canvas, dynamic node) {
    final style = node.style;
    if (style == null) return;

    final x = style.x ?? 0.0;
    final y = style.y ?? 0.0;
    final size = style.size ?? const G6Size(40, 40);

    // Draw node circle (default)
    final paint = Paint()
      ..color = style.fill ?? Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(x, y),
      size.width / 2,
      paint,
    );

    // Draw stroke
    if (style.stroke != null) {
      final strokePaint = Paint()
        ..color = style.stroke!
        ..style = PaintingStyle.stroke
        ..strokeWidth = style.lineWidth ?? 2.0;

      canvas.drawCircle(
        Offset(x, y),
        size.width / 2,
        strokePaint,
      );
    }

    // Draw label
    if (style.labelText != null) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: style.labelText,
          style: TextStyle(
            color: style.label?.fill ?? Colors.black,
            fontSize: style.label?.fontSize ?? 12,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          y + size.height / 2 + 5,
        ),
      );
    }
  }

  void _drawEdge(Canvas canvas, dynamic edge) {
    final style = edge.style;
    final sourceNode = graph.dataController.getNode(edge.source);
    final targetNode = graph.dataController.getNode(edge.target);

    if (sourceNode == null || targetNode == null) return;

    final sourceStyle = sourceNode.style;
    final targetStyle = targetNode.style;

    if (sourceStyle == null || targetStyle == null) return;

    final x1 = sourceStyle.x ?? 0.0;
    final y1 = sourceStyle.y ?? 0.0;
    final x2 = targetStyle.x ?? 0.0;
    final y2 = targetStyle.y ?? 0.0;

    // Draw edge line (default)
    final paint = Paint()
      ..color = style?.stroke ?? Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = style?.lineWidth ?? 1.0;

    canvas.drawLine(
      Offset(x1, y1),
      Offset(x2, y2),
      paint,
    );

    // Draw label
    if (style?.labelText != null) {
      final midX = (x1 + x2) / 2;
      final midY = (y1 + y2) / 2;

      final textPainter = TextPainter(
        text: TextSpan(
          text: style!.labelText,
          style: TextStyle(
            color: style.label?.fill ?? Colors.black,
            fontSize: style.label?.fontSize ?? 10,
            backgroundColor: Colors.white.withOpacity(0.7),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          midX - textPainter.width / 2,
          midY - textPainter.height / 2,
        ),
      );
    }
  }

  void _drawCombo(Canvas canvas, dynamic combo) {
    final style = combo.style;
    if (style == null) return;

    final x = style.x ?? 0.0;
    final y = style.y ?? 0.0;
    final size = style.size ?? const G6Size(100, 100);

    // Draw combo rectangle (default)
    final paint = Paint()
      ..color = style.fill ?? Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x, y),
          width: size.width,
          height: size.height,
        ),
        const Radius.circular(8),
      ),
      paint,
    );

    // Draw stroke
    if (style.stroke != null) {
      final strokePaint = Paint()
        ..color = style.stroke!
        ..style = PaintingStyle.stroke
        ..strokeWidth = style.lineWidth ?? 2.0;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, y),
            width: size.width,
            height: size.height,
          ),
          const Radius.circular(8),
        ),
        strokePaint,
      );
    }

    // Draw label
    if (style.labelText != null) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: style.labelText,
          style: TextStyle(
            color: style.label?.fill ?? Colors.black,
            fontSize: style.label?.fontSize ?? 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          y - size.height / 2 - 20,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(GraphPainter oldDelegate) {
    return true; // Always repaint for now
  }
}
