import 'package:flutter/material.dart';
import 'package:g6_flutter/src/runtime/graph.dart';

/// Minimap plugin - shows overview of the graph
class MinimapPlugin extends StatelessWidget {
  const MinimapPlugin({
    super.key,
    required this.graph,
    this.width = 200,
    this.height = 150,
    this.backgroundColor = Colors.white,
  });

  final Graph graph;
  final double width;
  final double height;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _MinimapPainter(graph: graph),
      ),
    );
  }
}

class _MinimapPainter extends CustomPainter {
  _MinimapPainter({required this.graph});

  final Graph graph;

  @override
  void paint(Canvas canvas, Size size) {
    final data = graph.dataController.getData();
    if (data.nodes == null || data.nodes!.isEmpty) return;

    // Calculate bounds of all nodes
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final node in data.nodes!) {
      final style = node.style;
      if (style != null) {
        final x = style.x ?? 0;
        final y = style.y ?? 0;
        minX = minX < x ? minX : x;
        minY = minY < y ? minY : y;
        maxX = maxX > x ? maxX : x;
        maxY = maxY > y ? maxY : y;
      }
    }

    if (minX == double.infinity) return;

    final contentWidth = maxX - minX;
    final contentHeight = maxY - minY;

    // Calculate scale to fit in minimap
    final scaleX = size.width / contentWidth * 0.8;
    final scaleY = size.height / contentHeight * 0.8;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    // Center the minimap
    final offsetX = (size.width - contentWidth * scale) / 2 - minX * scale;
    final offsetY = (size.height - contentHeight * scale) / 2 - minY * scale;

    canvas.save();
    canvas.translate(offsetX, offsetY);
    canvas.scale(scale);

    // Draw edges (thin lines)
    if (data.edges != null) {
      final edgePaint = Paint()
        ..color = Colors.grey.withOpacity(0.3)
        ..strokeWidth = 0.5 / scale;

      for (final edge in data.edges!) {
        final sourceNode = graph.dataController.getNode(edge.source);
        final targetNode = graph.dataController.getNode(edge.target);

        if (sourceNode?.style != null && targetNode?.style != null) {
          canvas.drawLine(
            Offset(sourceNode!.style!.x!, sourceNode.style!.y!),
            Offset(targetNode!.style!.x!, targetNode.style!.y!),
            edgePaint,
          );
        }
      }
    }

    // Draw nodes (small circles)
    final nodePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (final node in data.nodes!) {
      final style = node.style;
      if (style != null) {
        canvas.drawCircle(
          Offset(style.x!, style.y!),
          2 / scale,
          nodePaint,
        );
      }
    }

    canvas.restore();

    // Draw viewport indicator
    _drawViewportIndicator(canvas, size, minX, minY, contentWidth, contentHeight, scale, offsetX, offsetY);
  }

  void _drawViewportIndicator(
    Canvas canvas,
    Size size,
    double minX,
    double minY,
    double contentWidth,
    double contentHeight,
    double scale,
    double offsetX,
    double offsetY,
  ) {
    final viewport = graph.viewportController;
    final viewportWidth = (graph.config.width ?? 800) / viewport.zoom;
    final viewportHeight = (graph.config.height ?? 600) / viewport.zoom;
    final viewportX = -viewport.offset.dx / viewport.zoom;
    final viewportY = -viewport.offset.dy / viewport.zoom;

    final rect = Rect.fromLTWH(
      offsetX + viewportX * scale,
      offsetY + viewportY * scale,
      viewportWidth * scale,
      viewportHeight * scale,
    );

    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawRect(rect, paint);

    final borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(_MinimapPainter oldDelegate) {
    return true;
  }
}
