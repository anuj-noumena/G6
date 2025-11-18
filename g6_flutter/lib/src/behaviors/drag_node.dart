import 'package:flutter/material.dart';
import 'package:g6_flutter/src/runtime/graph.dart';
import 'package:g6_flutter/src/types/id.dart';
import 'package:g6_flutter/src/types/node.dart';

/// Behavior for dragging nodes
class DragNodeBehavior {
  DragNodeBehavior(this.graph);

  final Graph graph;
  ElementID? _draggingNodeId;
  Offset? _dragStartPosition;

  /// Handle drag start
  void onDragStart(Offset position) {
    // Find node at position
    final nodeId = _findNodeAtPosition(position);
    if (nodeId != null) {
      _draggingNodeId = nodeId;
      _dragStartPosition = position;
    }
  }

  /// Handle drag update
  void onDragUpdate(Offset delta) {
    if (_draggingNodeId == null) return;

    final node = graph.dataController.getNode(_draggingNodeId!);
    if (node == null) return;

    // Update node position
    final style = node.style ?? NodeStyle();
    final currentX = style.x ?? 0;
    final currentY = style.y ?? 0;

    final updatedStyle = style.copyWith(
      x: currentX + delta.dx / graph.viewportController.zoom,
      y: currentY + delta.dy / graph.viewportController.zoom,
    );

    graph.dataController.updateNode(node.copyWith(style: updatedStyle));
  }

  /// Handle drag end
  void onDragEnd() {
    _draggingNodeId = null;
    _dragStartPosition = null;
  }

  ElementID? _findNodeAtPosition(Offset position) {
    // Convert viewport position to canvas position
    final canvasPoint = graph.viewportController.viewportToCanvas(position);

    final nodes = graph.dataController.getAllNodes();

    for (final node in nodes) {
      final style = node.style;
      if (style == null) continue;

      final nodeX = style.x ?? 0;
      final nodeY = style.y ?? 0;
      final nodeSize = style.size?.width ?? 40;

      final dx = canvasPoint.x - nodeX;
      final dy = canvasPoint.y - nodeY;
      final distance = (dx * dx + dy * dy).abs();

      if (distance <= (nodeSize / 2) * (nodeSize / 2)) {
        return node.id;
      }
    }

    return null;
  }

  /// Check if currently dragging
  bool get isDragging => _draggingNodeId != null;

  /// Get ID of node being dragged
  ElementID? get draggingNodeId => _draggingNodeId;
}
