import 'dart:math' as math;

import 'package:g6_flutter/src/layouts/base_layout.dart';
import 'package:g6_flutter/src/types/data.dart';
import 'package:g6_flutter/src/types/layout.dart';
import 'package:g6_flutter/src/types/node.dart';
import 'package:g6_flutter/src/types/size.dart';

/// Force-directed layout using simplified force simulation
class ForceLayout extends BaseLayout {
  ForceLayout(ForceLayoutConfig config) : super(config);

  ForceLayoutConfig get forceConfig => config as ForceLayoutConfig;

  @override
  Future<void> execute(GraphData data) async {
    if (data.nodes == null || data.nodes!.isEmpty) return;

    final nodes = data.nodes!;
    final edges = data.edges ?? [];
    final center = getCenter();

    // Initialize random positions if not set
    final random = math.Random();
    final positions = <String, List<double>>{};
    final velocities = <String, List<double>>{};

    for (final node in nodes) {
      if (node.style?.x != null && node.style?.y != null) {
        positions[node.id] = [node.style!.x!, node.style!.y!];
      } else {
        positions[node.id] = [
          center[0] + (random.nextDouble() - 0.5) * 100,
          center[1] + (random.nextDouble() - 0.5) * 100,
        ];
      }
      velocities[node.id] = [0, 0];
    }

    // Build edge lookup
    final edgeMap = <String, List<String>>{};
    for (final edge in edges) {
      edgeMap.putIfAbsent(edge.source, () => []).add(edge.target);
      edgeMap.putIfAbsent(edge.target, () => []).add(edge.source);
    }

    // Force simulation
    var alpha = forceConfig.alpha;
    final alphaMin = forceConfig.alphaMin;
    final alphaDecay = forceConfig.alphaDecay;

    for (var iteration = 0; iteration < forceConfig.iterations && alpha > alphaMin; iteration++) {
      // Apply forces
      _applyRepulsionForces(nodes, positions, velocities, alpha);
      _applyAttractionForces(edges, positions, velocities, alpha);
      _applyCenteringForce(nodes, positions, velocities, center, alpha);

      // Update positions
      for (final node in nodes) {
        final vel = velocities[node.id]!;
        final pos = positions[node.id]!;
        pos[0] += vel[0] * alpha;
        pos[1] += vel[1] * alpha;
        vel[0] *= 0.9; // Damping
        vel[1] *= 0.9;
      }

      alpha *= (1 - alphaDecay);
    }

    // Update node positions
    for (final node in nodes) {
      final pos = positions[node.id]!;
      final style = node.style ?? NodeStyle();
      final updatedStyle = style.copyWith(
        x: pos[0],
        y: pos[1],
      );

      // Update in-place
      final index = nodes.indexOf(node);
      nodes[index] = node.copyWith(style: updatedStyle);
    }
  }

  void _applyRepulsionForces(
    List<NodeData> nodes,
    Map<String, List<double>> positions,
    Map<String, List<double>> velocities,
    double alpha,
  ) {
    final strength = forceConfig.nodeStrength;
    final nodeSize = getNodeSize();

    for (var i = 0; i < nodes.length; i++) {
      for (var j = i + 1; j < nodes.length; j++) {
        final pos1 = positions[nodes[i].id]!;
        final pos2 = positions[nodes[j].id]!;

        final dx = pos2[0] - pos1[0];
        final dy = pos2[1] - pos1[1];
        final distSq = dx * dx + dy * dy + 0.1; // Avoid division by zero
        final dist = math.sqrt(distSq);

        if (dist < nodeSize * 4) {
          final force = strength / distSq;
          final fx = (dx / dist) * force;
          final fy = (dy / dist) * force;

          velocities[nodes[i].id]![0] -= fx;
          velocities[nodes[i].id]![1] -= fy;
          velocities[nodes[j].id]![0] += fx;
          velocities[nodes[j].id]![1] += fy;
        }
      }
    }
  }

  void _applyAttractionForces(
    List<EdgeData> edges,
    Map<String, List<double>> positions,
    Map<String, List<double>> velocities,
    double alpha,
  ) {
    final strength = forceConfig.edgeStrength;
    final distance = forceConfig.linkDistance;

    for (final edge in edges) {
      final pos1 = positions[edge.source];
      final pos2 = positions[edge.target];

      if (pos1 == null || pos2 == null) continue;

      final dx = pos2[0] - pos1[0];
      final dy = pos2[1] - pos1[1];
      final dist = math.sqrt(dx * dx + dy * dy) + 0.1;

      final force = (dist - distance) * strength;
      final fx = (dx / dist) * force;
      final fy = (dy / dist) * force;

      velocities[edge.source]![0] += fx;
      velocities[edge.source]![1] += fy;
      velocities[edge.target]![0] -= fx;
      velocities[edge.target]![1] -= fy;
    }
  }

  void _applyCenteringForce(
    List<NodeData> nodes,
    Map<String, List<double>> positions,
    Map<String, List<double>> velocities,
    List<double> center,
    double alpha,
  ) {
    final strength = 0.1;

    for (final node in nodes) {
      final pos = positions[node.id]!;
      final dx = center[0] - pos[0];
      final dy = center[1] - pos[1];

      velocities[node.id]![0] += dx * strength;
      velocities[node.id]![1] += dy * strength;
    }
  }
}
