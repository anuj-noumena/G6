import 'package:flutter/material.dart';
import 'package:g6_flutter/src/runtime/graph.dart';

/// Toolbar plugin - provides common graph actions
class ToolbarPlugin extends StatelessWidget {
  const ToolbarPlugin({
    super.key,
    required this.graph,
    this.onZoomIn,
    this.onZoomOut,
    this.onFitView,
    this.onReset,
  });

  final Graph graph;
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onFitView;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.zoom_in),
            tooltip: 'Zoom In',
            onPressed: onZoomIn ?? () => graph.zoomTo(graph.getZoom() * 1.2),
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            tooltip: 'Zoom Out',
            onPressed: onZoomOut ?? () => graph.zoomTo(graph.getZoom() * 0.8),
          ),
          IconButton(
            icon: const Icon(Icons.fit_screen),
            tooltip: 'Fit View',
            onPressed: onFitView ?? () => graph.fitView(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
            onPressed: onReset ??
                () {
                  graph.viewportController.reset();
                  graph.fitView();
                },
          ),
        ],
      ),
    );
  }
}
