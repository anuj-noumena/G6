import 'dart:math' as math;

import 'package:g6_flutter/src/layouts/base_layout.dart';
import 'package:g6_flutter/src/types/data.dart';
import 'package:g6_flutter/src/types/layout.dart';
import 'package:g6_flutter/src/types/node.dart';

/// Circular layout - arranges nodes in a circle
class CircularLayout extends BaseLayout {
  CircularLayout(CircularLayoutConfig config) : super(config);

  CircularLayoutConfig get circularConfig => config as CircularLayoutConfig;

  @override
  Future<void> execute(GraphData data) async {
    if (data.nodes == null || data.nodes!.isEmpty) return;

    final nodes = data.nodes!;
    final center = getCenter();
    final radius = circularConfig.radius ?? _calculateRadius(nodes.length);
    final startAngle = circularConfig.startAngle;
    final endAngle = circularConfig.endAngle;
    final clockwise = circularConfig.clockwise;

    final angleStep = (endAngle - startAngle) / nodes.length;

    for (var i = 0; i < nodes.length; i++) {
      final angle = clockwise
          ? startAngle + i * angleStep
          : startAngle - i * angleStep;

      final x = center[0] + radius * math.cos(angle);
      final y = center[1] + radius * math.sin(angle);

      final style = nodes[i].style ?? NodeStyle();
      final updatedStyle = style.copyWith(x: x, y: y);
      nodes[i] = nodes[i].copyWith(style: updatedStyle);
    }
  }

  double _calculateRadius(int nodeCount) {
    final nodeSize = getNodeSize();
    final spacing = getNodeSpacing();
    final circumference = nodeCount * (nodeSize + spacing);
    return circumference / (2 * math.pi);
  }
}
