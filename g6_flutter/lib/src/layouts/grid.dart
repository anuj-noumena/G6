import 'dart:math' as math;

import 'package:g6_flutter/src/layouts/base_layout.dart';
import 'package:g6_flutter/src/types/data.dart';
import 'package:g6_flutter/src/types/layout.dart';
import 'package:g6_flutter/src/types/node.dart';

/// Grid layout - arranges nodes in a grid pattern
class GridLayout extends BaseLayout {
  GridLayout(GridLayoutConfig config) : super(config);

  GridLayoutConfig get gridConfig => config as GridLayoutConfig;

  @override
  Future<void> execute(GraphData data) async {
    if (data.nodes == null || data.nodes!.isEmpty) return;

    final nodes = data.nodes!;
    final center = getCenter();
    final spacing = getNodeSpacing();

    // Calculate grid dimensions
    final cols = gridConfig.cols ?? _calculateCols(nodes.length);
    final rows = gridConfig.rows ?? ((nodes.length + cols - 1) ~/ cols);

    // Calculate starting position to center the grid
    final gridWidth = cols * spacing;
    final gridHeight = rows * spacing;
    final startX = center[0] - gridWidth / 2;
    final startY = center[1] - gridHeight / 2;

    for (var i = 0; i < nodes.length; i++) {
      final row = i ~/ cols;
      final col = i % cols;

      final x = startX + col * spacing;
      final y = startY + row * spacing;

      final style = nodes[i].style ?? NodeStyle();
      final updatedStyle = style.copyWith(x: x, y: y);
      nodes[i] = nodes[i].copyWith(style: updatedStyle);
    }
  }

  int _calculateCols(int nodeCount) {
    return math.sqrt(nodeCount).ceil();
  }
}
