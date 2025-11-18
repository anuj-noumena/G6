import 'package:flutter/material.dart';
import 'package:g6_flutter/g6_flutter.dart';
import 'package:g6_flutter/src/behaviors/click_select.dart';
import 'package:g6_flutter/src/behaviors/drag_node.dart';
import 'package:g6_flutter/src/behaviors/hover_activate.dart';
import 'package:g6_flutter/src/layouts/circular.dart';
import 'package:g6_flutter/src/layouts/dagre.dart';
import 'package:g6_flutter/src/layouts/force.dart';
import 'package:g6_flutter/src/layouts/grid.dart';
import 'package:g6_flutter/src/plugins/history.dart';
import 'package:g6_flutter/src/plugins/minimap.dart';
import 'package:g6_flutter/src/plugins/toolbar.dart';
import 'package:g6_flutter/src/plugins/tooltip.dart';
import 'package:g6_flutter/src/widgets/graph_painter_enhanced.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'G6 Flutter - Full Features Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const EnhancedGraphPage(),
    );
  }
}

class EnhancedGraphPage extends StatefulWidget {
  const EnhancedGraphPage({super.key});

  @override
  State<EnhancedGraphPage> createState() => _EnhancedGraphPageState();
}

class _EnhancedGraphPageState extends State<EnhancedGraphPage>
    with TickerProvider {
  late Graph _graph;
  late DragNodeBehavior _dragBehavior;
  late ClickSelectBehavior _selectBehavior;
  late HoverActivateBehavior _hoverBehavior;
  late HistoryPlugin _history;

  String _selectedLayout = 'force';
  String _selectedNodeType = 'circle';
  String _selectedEdgeType = 'line';
  String? _tooltipText;
  Offset _tooltipPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _initGraph();
  }

  void _initGraph() {
    final graphData = _createSampleData();

    _graph = Graph(
      data: graphData,
      config: GraphConfig(
        width: 800,
        height: 600,
        layout: ForceLayoutConfig(),
      ),
    );

    _dragBehavior = DragNodeBehavior(_graph);
    _selectBehavior = ClickSelectBehavior(_graph, multiple: true);
    _hoverBehavior = HoverActivateBehavior(_graph);
    _history = HistoryPlugin(_graph);
    _history.push();

    // Apply initial layout
    _applyLayout(_selectedLayout);
  }

  GraphData _createSampleData() {
    return GraphData(
      nodes: [
        NodeData(
          id: '1',
          type: 'circle',
          style: NodeStyle(
            x: 100,
            y: 100,
            size: const G6Size(50, 50),
            fill: Colors.blue,
            stroke: Colors.blueAccent,
            lineWidth: 2,
            labelText: 'Start',
          ),
        ),
        NodeData(
          id: '2',
          type: 'rect',
          style: NodeStyle(
            x: 300,
            y: 100,
            size: const G6Size(60, 40),
            fill: Colors.green,
            stroke: Colors.greenAccent,
            lineWidth: 2,
            labelText: 'Process',
          ),
        ),
        NodeData(
          id: '3',
          type: 'diamond',
          style: NodeStyle(
            x: 200,
            y: 250,
            size: const G6Size(60, 60),
            fill: Colors.orange,
            stroke: Colors.orangeAccent,
            lineWidth: 2,
            labelText: 'Decision',
          ),
        ),
        NodeData(
          id: '4',
          type: 'ellipse',
          style: NodeStyle(
            x: 400,
            y: 250,
            size: const G6Size(80, 40),
            fill: Colors.purple,
            stroke: Colors.purpleAccent,
            lineWidth: 2,
            labelText: 'Data',
          ),
        ),
        NodeData(
          id: '5',
          type: 'triangle',
          style: NodeStyle(
            x: 100,
            y: 400,
            size: const G6Size(50, 50),
            fill: Colors.red,
            stroke: Colors.redAccent,
            lineWidth: 2,
            labelText: 'Warning',
          ),
        ),
        NodeData(
          id: '6',
          type: 'hexagon',
          style: NodeStyle(
            x: 300,
            y: 400,
            size: const G6Size(50, 50),
            fill: Colors.teal,
            stroke: Colors.tealAccent,
            lineWidth: 2,
            labelText: 'Prepare',
          ),
        ),
        NodeData(
          id: '7',
          type: 'star',
          style: NodeStyle(
            x: 500,
            y: 400,
            size: const G6Size(50, 50),
            fill: Colors.amber,
            stroke: Colors.amberAccent,
            lineWidth: 2,
            labelText: 'Special',
          ),
        ),
      ],
      edges: [
        EdgeData(
          source: '1',
          target: '2',
          type: 'line',
          style: EdgeStyle(stroke: Colors.grey, lineWidth: 2),
        ),
        EdgeData(
          source: '2',
          target: '3',
          type: 'quadratic',
          style: EdgeStyle(
            stroke: Colors.grey,
            lineWidth: 2,
            labelText: 'Check',
          ),
        ),
        EdgeData(
          source: '3',
          target: '4',
          type: 'cubic',
          style: EdgeStyle(stroke: Colors.grey, lineWidth: 2),
        ),
        EdgeData(
          source: '1',
          target: '5',
          type: 'line',
          style: EdgeStyle(
            stroke: Colors.grey,
            lineWidth: 2,
            lineDash: [5, 5],
          ),
        ),
        EdgeData(
          source: '5',
          target: '6',
          type: 'line',
          style: EdgeStyle(stroke: Colors.grey, lineWidth: 2),
        ),
        EdgeData(
          source: '6',
          target: '7',
          type: 'quadratic',
          style: EdgeStyle(stroke: Colors.grey, lineWidth: 2),
        ),
        EdgeData(
          source: '4',
          target: '7',
          type: 'line',
          style: EdgeStyle(stroke: Colors.grey, lineWidth: 2),
        ),
      ],
    );
  }

  void _applyLayout(String layoutType) {
    setState(() {
      _selectedLayout = layoutType;
    });

    switch (layoutType) {
      case 'force':
        _graph.layout(ForceLayoutConfig(
          iterations: 100,
          linkDistance: 100,
        ));
        break;
      case 'circular':
        _graph.layout(CircularLayoutConfig());
        break;
      case 'grid':
        _graph.layout(GridLayoutConfig());
        break;
      case 'dagre':
        _graph.layout(DagreLayoutConfig());
        break;
    }

    _graph.fitView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('G6 Flutter - Full Features Demo'),
        actions: [
          // Layout selector
          DropdownButton<String>(
            value: _selectedLayout,
            items: const [
              DropdownMenuItem(value: 'force', child: Text('Force')),
              DropdownMenuItem(value: 'circular', child: Text('Circular')),
              DropdownMenuItem(value: 'grid', child: Text('Grid')),
              DropdownMenuItem(value: 'dagre', child: Text('Dagre')),
            ],
            onChanged: (value) {
              if (value != null) _applyLayout(value);
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          // Main graph canvas
          GestureDetector(
            onScaleStart: (details) {
              _dragBehavior.onDragStart(details.focalPoint);
            },
            onScaleUpdate: (details) {
              if (_dragBehavior.isDragging) {
                _dragBehavior.onDragUpdate(details.focalPoint - details.localFocalPoint);
                setState(() {});
              } else {
                // Handle pan/zoom
                final scaleDelta = details.scale / (details.previousScale ?? 1.0);
                if ((scaleDelta - 1).abs() > 0.01) {
                  _graph.viewportController.zoomBy(scaleDelta, center: details.focalPoint);
                } else {
                  _graph.viewportController.panBy(details.focalPoint - details.localFocalPoint);
                }
                setState(() {});
              }
            },
            onScaleEnd: (details) {
              _dragBehavior.onDragEnd();
            },
            onTapDown: (details) {
              _selectBehavior.onClick(details.localPosition);
              setState(() {});
            },
            child: MouseRegion(
              onHover: (event) {
                _hoverBehavior.onPointerHover(event.localPosition);
                setState(() {
                  _tooltipPosition = event.localPosition;
                  _tooltipText = 'Hover over elements';
                });
              },
              onExit: (event) {
                _hoverBehavior.clearHover();
                setState(() {
                  _tooltipText = null;
                });
              },
              child: CustomPaint(
                painter: GraphPainterEnhanced(graph: _graph),
                size: Size.infinite,
              ),
            ),
          ),

          // Toolbar
          Positioned(
            top: 16,
            left: 16,
            child: ToolbarPlugin(
              graph: _graph,
              onFitView: () {
                _graph.fitView();
                setState(() {});
              },
              onReset: () {
                _applyLayout(_selectedLayout);
                setState(() {});
              },
            ),
          ),

          // Minimap
          Positioned(
            bottom: 16,
            right: 16,
            child: MinimapPlugin(graph: _graph),
          ),

          // Tooltip
          if (_tooltipText != null)
            TooltipPlugin(
              content: _tooltipText!,
              position: _tooltipPosition,
            ),

          // Control panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _history.push();
                      setState(() {});
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Save State'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _history.canUndo
                        ? () {
                            _history.undo();
                            setState(() {});
                          }
                        : null,
                    icon: const Icon(Icons.undo),
                    label: const Text('Undo'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _history.canRedo
                        ? () {
                            _history.redo();
                            setState(() {});
                          }
                        : null,
                    icon: const Icon(Icons.redo),
                    label: const Text('Redo'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _selectBehavior.clearSelection();
                      setState(() {});
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear Selection'),
                  ),
                  Text(
                    'Selected: ${_selectBehavior.selectedNodes.length} nodes',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _graph.destroy();
    super.dispose();
  }
}
