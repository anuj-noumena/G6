import 'package:flutter/material.dart';
import 'package:g6_flutter/src/runtime/graph.dart';
import 'package:g6_flutter/src/types/data.dart';
import 'package:g6_flutter/src/widgets/graph_painter.dart';

/// G6 Graph Widget - the main Flutter widget for displaying graphs
///
/// This widget renders a graph using the G6 Flutter library.
///
/// Example:
/// ```dart
/// G6Graph(
///   data: GraphData(
///     nodes: [
///       NodeData(id: '1', style: NodeStyle(x: 100, y: 100)),
///       NodeData(id: '2', style: NodeStyle(x: 200, y: 200)),
///     ],
///     edges: [
///       EdgeData(source: '1', target: '2'),
///     ],
///   ),
///   config: GraphConfig(
///     layout: LayoutConfig(type: LayoutType.force),
///   ),
/// )
/// ```
class G6Graph extends StatefulWidget {
  const G6Graph({
    super.key,
    required this.data,
    this.config,
    this.width,
    this.height,
  });

  final GraphData data;
  final GraphConfig? config;
  final double? width;
  final double? height;

  @override
  State<G6Graph> createState() => _G6GraphState();
}

class _G6GraphState extends State<G6Graph> {
  late Graph _graph;

  @override
  void initState() {
    super.initState();
    _initGraph();
  }

  void _initGraph() {
    // Create graph instance with config
    final config = widget.config ??
        GraphConfig(
          width: widget.width,
          height: widget.height,
        );

    _graph = Graph(
      data: widget.data,
      config: config,
    );

    // Fit view to show all elements
    _graph.fitView();
  }

  @override
  void didUpdateWidget(G6Graph oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update graph data if changed
    if (widget.data != oldWidget.data) {
      _graph.setData(widget.data);
      _graph.fitView();
    }
  }

  @override
  void dispose() {
    _graph.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = widget.width ?? constraints.maxWidth;
        final height = widget.height ?? constraints.maxHeight;

        return SizedBox(
          width: width,
          height: height,
          child: GestureDetector(
            onScaleStart: _handleScaleStart,
            onScaleUpdate: _handleScaleUpdate,
            onScaleEnd: _handleScaleEnd,
            onTapDown: _handleTapDown,
            child: CustomPaint(
              painter: GraphPainter(graph: _graph),
              size: Size(width, height),
            ),
          ),
        );
      },
    );
  }

  // Interaction handlers

  Offset? _lastFocalPoint;
  double? _lastScale;

  void _handleScaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.focalPoint;
    _lastScale = 1.0;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    // Handle zoom
    if (details.scale != _lastScale) {
      final scaleDelta = details.scale / (_lastScale ?? 1.0);
      _graph.viewportController.zoomBy(
        scaleDelta,
        center: details.focalPoint,
      );
      _lastScale = details.scale;
    }

    // Handle pan
    if (_lastFocalPoint != null) {
      final delta = details.focalPoint - _lastFocalPoint!;
      _graph.viewportController.panBy(delta);
      _lastFocalPoint = details.focalPoint;
    }

    setState(() {});
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    _lastFocalPoint = null;
    _lastScale = null;
  }

  void _handleTapDown(TapDownDetails details) {
    // Convert tap position to canvas coordinates
    final canvasPoint = _graph.viewportController.viewportToCanvas(
      details.localPosition,
    );

    // TODO: Find element at position and emit click event
    debugPrint('Tapped at canvas position: $canvasPoint');
  }
}
