import 'package:g6_flutter/src/layouts/base_layout.dart';
import 'package:g6_flutter/src/layouts/circular.dart';
import 'package:g6_flutter/src/layouts/dagre.dart';
import 'package:g6_flutter/src/layouts/force.dart';
import 'package:g6_flutter/src/layouts/grid.dart';
import 'package:g6_flutter/src/runtime/graph.dart';
import 'package:g6_flutter/src/types/layout.dart';

/// Layout controller - manages graph layout algorithms
class LayoutController {
  LayoutController(this.graph);

  final Graph graph;
  BaseLayout? _currentLayout;
  bool _isRunning = false;

  /// Check if layout is currently running
  bool get isRunning => _isRunning;

  /// Execute layout with the given configuration
  Future<void> layout(LayoutConfig config) async {
    if (_isRunning) return;

    _isRunning = true;

    try {
      _currentLayout = _createLayout(config);
      final data = graph.dataController.getData();
      await _currentLayout!.execute(data);

      // Data is modified in-place, so we need to notify the graph
      graph.setData(data);
    } finally {
      _isRunning = false;
    }
  }

  /// Stop current layout execution
  void stop() {
    _isRunning = false;
  }

  BaseLayout _createLayout(LayoutConfig config) {
    switch (config.type) {
      case LayoutType.force:
      case LayoutType.d3Force:
        return ForceLayout(config as ForceLayoutConfig);

      case LayoutType.circular:
        return CircularLayout(config as CircularLayoutConfig);

      case LayoutType.grid:
        return GridLayout(config as GridLayoutConfig);

      case LayoutType.dagre:
        return DagreLayout(config as DagreLayoutConfig);

      default:
        // Default to grid layout
        return GridLayout(GridLayoutConfig());
    }
  }
}
