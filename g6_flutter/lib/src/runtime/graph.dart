import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';
import 'package:g6_flutter/src/runtime/controllers/data_controller.dart';
import 'package:g6_flutter/src/runtime/controllers/element_controller.dart';
import 'package:g6_flutter/src/runtime/controllers/layout_controller.dart';
import 'package:g6_flutter/src/runtime/controllers/viewport_controller.dart';
import 'package:g6_flutter/src/types/behavior.dart';
import 'package:g6_flutter/src/types/combo.dart';
import 'package:g6_flutter/src/types/data.dart';
import 'package:g6_flutter/src/types/edge.dart';
import 'package:g6_flutter/src/types/event.dart';
import 'package:g6_flutter/src/types/id.dart';
import 'package:g6_flutter/src/types/layout.dart';
import 'package:g6_flutter/src/types/node.dart';
import 'package:g6_flutter/src/types/plugin.dart';
import 'package:g6_flutter/src/types/state.dart';
import 'package:g6_flutter/src/types/theme.dart';

/// Main Graph class - the entry point for G6 Flutter
///
/// Manages graph data, rendering, interactions, layouts, and plugins.
///
/// Example:
/// ```dart
/// final graph = Graph(
///   data: GraphData(
///     nodes: [NodeData(id: '1'), NodeData(id: '2')],
///     edges: [EdgeData(source: '1', target: '2')],
///   ),
///   config: GraphConfig(
///     layout: LayoutConfig(type: LayoutType.force),
///   ),
/// );
/// ```
class Graph {
  Graph({
    GraphData? data,
    GraphConfig? config,
  })  : _config = config ?? GraphConfig(),
        _eventBus = EventBus() {
    _dataController = DataController(this);
    _elementController = ElementController(this);
    _viewportController = ViewportController(this);
    _layoutController = LayoutController(this);

    if (data != null) {
      setData(data);
    }

    // Apply initial layout if configured
    if (_config.layout != null) {
      Future.microtask(() => layout(_config.layout!));
    }
  }

  final GraphConfig _config;
  final EventBus _eventBus;

  late final DataController _dataController;
  late final ElementController _elementController;
  late final ViewportController _viewportController;
  late final LayoutController _layoutController;

  bool _rendered = false;
  bool _destroyed = false;

  /// Whether the graph has been rendered
  bool get rendered => _rendered;

  /// Whether the graph has been destroyed
  bool get destroyed => _destroyed;

  /// Get current graph configuration
  GraphConfig get config => _config;

  /// Get data controller
  DataController get dataController => _dataController;

  /// Get element controller
  ElementController get elementController => _elementController;

  /// Get viewport controller
  ViewportController get viewportController => _viewportController;

  /// Get layout controller
  LayoutController get layoutController => _layoutController;

  // ==================== Data Methods ====================

  /// Set graph data
  void setData(GraphData data) {
    _dataController.setData(data);
    _emit(GraphEventType.afterElementUpdate);
  }

  /// Get current graph data
  GraphData getData() {
    return _dataController.getData();
  }

  /// Add nodes to the graph
  void addNodeData(List<NodeData> nodes) {
    _dataController.addNodes(nodes);
    _emit(GraphEventType.afterElementCreate);
  }

  /// Add edges to the graph
  void addEdgeData(List<EdgeData> edges) {
    _dataController.addEdges(edges);
    _emit(GraphEventType.afterElementCreate);
  }

  /// Add combos to the graph
  void addComboData(List<ComboData> combos) {
    _dataController.addCombos(combos);
    _emit(GraphEventType.afterElementCreate);
  }

  /// Update node data
  void updateNodeData(NodeData node) {
    _dataController.updateNode(node);
    _emit(GraphEventType.afterElementUpdate);
  }

  /// Update edge data
  void updateEdgeData(EdgeData edge) {
    _dataController.updateEdge(edge);
    _emit(GraphEventType.afterElementUpdate);
  }

  /// Remove nodes from the graph
  void removeNodeData(List<ElementID> nodeIds) {
    _dataController.removeNodes(nodeIds);
    _emit(GraphEventType.afterElementRemove);
  }

  /// Remove edges from the graph
  void removeEdgeData(List<ElementID> edgeIds) {
    _dataController.removeEdges(edgeIds);
    _emit(GraphEventType.afterElementRemove);
  }

  /// Get node data by ID
  NodeData? getNodeData(ElementID id) {
    return _dataController.getNode(id);
  }

  /// Get edge data by ID
  EdgeData? getEdgeData(ElementID id) {
    return _dataController.getEdge(id);
  }

  /// Get all neighbors of a node
  List<NodeData> getNeighbors(ElementID nodeId) {
    return _dataController.getNeighbors(nodeId);
  }

  /// Get related edges of nodes
  List<EdgeData> getRelatedEdges(List<ElementID> nodeIds) {
    return _dataController.getRelatedEdges(nodeIds);
  }

  // ==================== Element State Methods ====================

  /// Set element state
  void setElementState(ElementID id, State state, bool enabled) {
    _dataController.setElementState(id, state, enabled);
    _emit(GraphEventType.afterElementUpdate);
  }

  /// Get element states
  List<State>? getElementStates(ElementID id) {
    return _dataController.getElementStates(id);
  }

  /// Clear all states of an element
  void clearElementStates(ElementID id) {
    _dataController.clearElementStates(id);
    _emit(GraphEventType.afterElementUpdate);
  }

  // ==================== Event Methods ====================

  /// Listen to graph events
  void on(String eventType, EventCallback callback) {
    _eventBus.on<GraphEvent>().listen((event) {
      if (event.type == eventType) {
        callback(event);
      }
    });
  }

  /// Emit an event
  void _emit(String eventType, [GraphEvent? event]) {
    _eventBus.fire(event ?? GraphEvent(type: eventType));
  }

  // ==================== Layout Methods ====================

  /// Execute layout algorithm
  Future<void> layout(LayoutConfig config) async {
    _emit(GraphEventType.beforeLayout);
    await _layoutController.layout(config);
    _emit(GraphEventType.afterLayout);
  }

  /// Stop current layout
  void stopLayout() {
    _layoutController.stop();
  }

  // ==================== Viewport Methods ====================

  /// Fit view to show all elements
  void fitView({EdgeInsets padding = EdgeInsets.zero}) {
    _viewportController.fitView(padding: padding);
  }

  /// Zoom to specific level
  void zoomTo(double zoom, {Offset? center}) {
    _viewportController.zoomTo(zoom, center: center);
  }

  /// Get current zoom level
  double getZoom() {
    return _viewportController.zoom;
  }

  /// Pan the viewport
  void panTo(Offset offset) {
    _viewportController.panTo(offset);
  }

  /// Get current pan offset
  Offset getPan() {
    return _viewportController.offset;
  }

  // ==================== Lifecycle Methods ====================

  /// Render the graph
  void render() {
    _emit(GraphEventType.beforeRender);
    _elementController.render();
    _rendered = true;
    _emit(GraphEventType.afterRender);
  }

  /// Clear the graph (remove all data)
  void clear() {
    _dataController.clear();
    _emit(GraphEventType.afterElementRemove);
  }

  /// Destroy the graph instance
  void destroy() {
    if (_destroyed) return;

    clear();
    _eventBus.destroy();
    _destroyed = true;
  }
}

/// Graph configuration
class GraphConfig {
  GraphConfig({
    this.width,
    this.height,
    this.node,
    this.edge,
    this.combo,
    this.layout,
    this.theme,
    this.behaviors,
    this.plugins,
    this.zoomRange = const [0.1, 10],
  });

  final double? width;
  final double? height;
  final NodeConfig? node;
  final EdgeConfig? edge;
  final ComboConfig? combo;
  final LayoutConfig? layout;
  final ThemeConfig? theme;
  final List<BehaviorConfig>? behaviors;
  final List<PluginConfig>? plugins;
  final List<double> zoomRange;
}

/// Node configuration
class NodeConfig {
  NodeConfig({
    this.type = 'circle',
    this.style,
    this.state,
  });

  final String type;
  final NodeStyle? style;
  final Map<State, NodeStyle>? state;
}

/// Edge configuration
class EdgeConfig {
  EdgeConfig({
    this.type = 'line',
    this.style,
    this.state,
  });

  final String type;
  final EdgeStyle? style;
  final Map<State, EdgeStyle>? state;
}

/// Combo configuration
class ComboConfig {
  ComboConfig({
    this.type = 'circle',
    this.style,
    this.state,
  });

  final String type;
  final ComboStyle? style;
  final Map<State, ComboStyle>? state;
}
