import 'package:flutter/material.dart';
import 'package:g6_flutter/src/runtime/graph.dart';
import 'package:g6_flutter/src/types/id.dart';
import 'package:g6_flutter/src/types/state.dart';

/// Behavior for click selection
class ClickSelectBehavior {
  ClickSelectBehavior(this.graph, {this.multiple = false});

  final Graph graph;
  final bool multiple;

  final Set<ElementID> _selectedNodes = {};

  /// Handle click on position
  void onClick(Offset position) {
    final nodeId = _findNodeAtPosition(position);

    if (nodeId != null) {
      if (multiple) {
        // Toggle selection in multiple mode
        if (_selectedNodes.contains(nodeId)) {
          _selectedNodes.remove(nodeId);
          graph.setElementState(nodeId, States.selected, false);
        } else {
          _selectedNodes.add(nodeId);
          graph.setElementState(nodeId, States.selected, true);
        }
      } else {
        // Single selection mode
        // Clear previous selection
        for (final id in _selectedNodes) {
          graph.setElementState(id, States.selected, false);
        }
        _selectedNodes.clear();

        // Select new node
        _selectedNodes.add(nodeId);
        graph.setElementState(nodeId, States.selected, true);
      }
    } else {
      // Clicked on empty space - clear selection
      clearSelection();
    }
  }

  /// Clear all selections
  void clearSelection() {
    for (final id in _selectedNodes) {
      graph.setElementState(id, States.selected, false);
    }
    _selectedNodes.clear();
  }

  /// Get selected node IDs
  Set<ElementID> get selectedNodes => Set.from(_selectedNodes);

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
