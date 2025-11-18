import 'package:flutter/material.dart';
import 'package:g6_flutter/src/runtime/graph.dart';
import 'package:g6_flutter/src/types/id.dart';
import 'package:g6_flutter/src/types/state.dart';

/// Behavior for hover activation
class HoverActivateBehavior {
  HoverActivateBehavior(this.graph);

  final Graph graph;
  ElementID? _hoveredNodeId;

  /// Handle pointer hover
  void onPointerHover(Offset position) {
    final nodeId = _findNodeAtPosition(position);

    if (nodeId != _hoveredNodeId) {
      // Clear previous hover state
      if (_hoveredNodeId != null) {
        graph.setElementState(_hoveredNodeId!, States.hover, false);
      }

      // Set new hover state
      if (nodeId != null) {
        graph.setElementState(nodeId, States.hover, true);
      }

      _hoveredNodeId = nodeId;
    }
  }

  /// Clear hover state
  void clearHover() {
    if (_hoveredNodeId != null) {
      graph.setElementState(_hoveredNodeId!, States.hover, false);
      _hoveredNodeId = null;
    }
  }

  ElementID? _findNodeAtPosition(Offset position) {
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
}
