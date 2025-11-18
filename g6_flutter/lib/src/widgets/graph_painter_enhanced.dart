import 'package:flutter/material.dart';
import 'package:g6_flutter/src/elements/edges/cubic.dart';
import 'package:g6_flutter/src/elements/edges/line.dart';
import 'package:g6_flutter/src/elements/edges/polyline.dart';
import 'package:g6_flutter/src/elements/edges/quadratic.dart';
import 'package:g6_flutter/src/registry/shape_registry.dart';
import 'package:g6_flutter/src/runtime/graph.dart';
import 'package:g6_flutter/src/types/edge.dart';
import 'package:g6_flutter/src/types/size.dart';

/// Enhanced custom painter for rendering the graph with all node/edge types
class GraphPainterEnhanced extends CustomPainter {
  GraphPainterEnhanced({required this.graph});

  final Graph graph;
  final _shapeRegistry = ShapeRegistry();

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
    final center = Offset(x, y);

    // Get node type from data or default to circle
    final nodeType = node.type ?? 'circle';
    final shape = _shapeRegistry.getNodeShape(nodeType);

    // Paint the node using its shape
    shape.paintNode(canvas, center, style);
  }

  void _drawEdge(Canvas canvas, dynamic edge) {
    final style = edge.style;
    final sourceNode = graph.dataController.getNode(edge.source);
    final targetNode = graph.dataController.getNode(edge.target);

    if (sourceNode == null || targetNode == null) return;

    final sourceStyle = sourceNode.style;
    final targetStyle = targetNode.style;

    if (sourceStyle == null || targetStyle == null) return;

    final start = Offset(sourceStyle.x ?? 0.0, sourceStyle.y ?? 0.0);
    final end = Offset(targetStyle.x ?? 0.0, targetStyle.y ?? 0.0);

    // Get edge type from data or default to line
    final edgeType = edge.type ?? 'line';

    // Paint edge based on type
    switch (edgeType) {
      case 'line':
        const LineEdge().paintLine(canvas, start, end, style ?? EdgeStyle());
        break;
      case 'polyline':
        const PolylineEdge().paintPolyline(
          canvas,
          start,
          end,
          style ?? EdgeStyle(),
          null,
        );
        break;
      case 'quadratic':
        const QuadraticEdge().paintQuadratic(
          canvas,
          start,
          end,
          style ?? EdgeStyle(),
        );
        break;
      case 'cubic':
        const CubicEdge().paintCubic(
          canvas,
          start,
          end,
          style ?? EdgeStyle(),
        );
        break;
      default:
        const LineEdge().paintLine(canvas, start, end, style ?? EdgeStyle());
    }

    // Draw label
    if (style?.labelText != null) {
      const LineEdge().paintLabel(canvas, start, end, style!);
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
  bool shouldRepaint(GraphPainterEnhanced oldDelegate) {
    return true; // Always repaint for now
  }
}
