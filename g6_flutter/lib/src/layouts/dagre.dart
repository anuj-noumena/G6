import 'dart:math' as math;

import 'package:g6_flutter/src/layouts/base_layout.dart';
import 'package:g6_flutter/src/types/data.dart';
import 'package:g6_flutter/src/types/layout.dart';
import 'package:g6_flutter/src/types/node.dart';

/// Dagre layout - hierarchical layout (simplified implementation)
class DagreLayout extends BaseLayout {
  DagreLayout(DagreLayoutConfig config) : super(config);

  DagreLayoutConfig get dagreConfig => config as DagreLayoutConfig;

  @override
  Future<void> execute(GraphData data) async {
    if (data.nodes == null || data.nodes!.isEmpty) return;

    final nodes = data.nodes!;
    final edges = data.edges ?? [];
    final center = getCenter();

    // Build adjacency map for hierarchy detection
    final outEdges = <String, List<String>>{};
    final inDegree = <String, int>{};

    for (final node in nodes) {
      inDegree[node.id] = 0;
      outEdges[node.id] = [];
    }

    for (final edge in edges) {
      outEdges[edge.source]?.add(edge.target);
      inDegree[edge.target] = (inDegree[edge.target] ?? 0) + 1;
    }

    // Topological sort to assign layers
    final layers = <int, List<String>>{};
    final nodeLayer = <String, int>{};
    final queue = <String>[];

    // Find root nodes (in-degree == 0)
    for (final entry in inDegree.entries) {
      if (entry.value == 0) {
        queue.add(entry.key);
        nodeLayer[entry.key] = 0;
        layers.putIfAbsent(0, () => []).add(entry.key);
      }
    }

    // BFS to assign layers
    final visited = <String>{};
    while (queue.isNotEmpty) {
      final nodeId = queue.removeAt(0);
      if (visited.contains(nodeId)) continue;
      visited.add(nodeId);

      final currentLayer = nodeLayer[nodeId]!;

      for (final targetId in outEdges[nodeId] ?? []) {
        final newLayer = currentLayer + 1;
        if (!nodeLayer.containsKey(targetId) || nodeLayer[targetId]! < newLayer) {
          nodeLayer[targetId] = newLayer;
          layers.putIfAbsent(newLayer, () => []).add(targetId);
          queue.add(targetId);
        }
      }
    }

    // Handle disconnected nodes
    for (final node in nodes) {
      if (!nodeLayer.containsKey(node.id)) {
        nodeLayer[node.id] = 0;
        layers.putIfAbsent(0, () => []).add(node.id);
      }
    }

    // Position nodes based on layout direction
    final isVertical = dagreConfig.rankdir == 'TB' || dagreConfig.rankdir == 'BT';
    final isReversed = dagreConfig.rankdir == 'BT' || dagreConfig.rankdir == 'RL';
    final nodesep = dagreConfig.nodesep;
    final ranksep = dagreConfig.ranksep;

    final maxLayer = layers.keys.isEmpty ? 0 : layers.keys.reduce(math.max);

    for (final layer in layers.keys) {
      final nodesInLayer = layers[layer]!;
      final layerSize = nodesInLayer.length;

      for (var i = 0; i < layerSize; i++) {
        final nodeId = nodesInLayer[i];
        final node = nodes.firstWhere((n) => n.id == nodeId);

        double x, y;

        if (isVertical) {
          final layerY = isReversed
              ? (maxLayer - layer) * ranksep
              : layer * ranksep;
          x = center[0] + (i - layerSize / 2) * nodesep;
          y = center[1] + layerY - (maxLayer * ranksep / 2);
        } else {
          final layerX = isReversed
              ? (maxLayer - layer) * ranksep
              : layer * ranksep;
          x = center[0] + layerX - (maxLayer * ranksep / 2);
          y = center[1] + (i - layerSize / 2) * nodesep;
        }

        final style = node.style ?? NodeStyle();
        final updatedStyle = style.copyWith(x: x, y: y);
        final index = nodes.indexOf(node);
        nodes[index] = node.copyWith(style: updatedStyle);
      }
    }
  }
}
