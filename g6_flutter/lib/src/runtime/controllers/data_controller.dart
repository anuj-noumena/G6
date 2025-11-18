import 'package:g6_flutter/src/runtime/graph.dart';
import 'package:g6_flutter/src/types/combo.dart';
import 'package:g6_flutter/src/types/data.dart';
import 'package:g6_flutter/src/types/edge.dart';
import 'package:g6_flutter/src/types/id.dart';
import 'package:g6_flutter/src/types/node.dart';
import 'package:g6_flutter/src/types/state.dart';

/// Data controller - manages graph data (nodes, edges, combos)
class DataController {
  DataController(this.graph);

  final Graph graph;

  final Map<ElementID, NodeData> _nodes = {};
  final Map<ElementID, EdgeData> _edges = {};
  final Map<ElementID, ComboData> _combos = {};

  // Index for fast edge lookup
  final Map<ElementID, List<EdgeData>> _nodeEdges = {};

  /// Set all graph data at once
  void setData(GraphData data) {
    clear();

    if (data.nodes != null) {
      for (final node in data.nodes!) {
        _nodes[node.id] = node;
      }
    }

    if (data.edges != null) {
      for (final edge in data.edges!) {
        final id = edge.effectiveId;
        _edges[id] = edge;
        _indexEdge(edge);
      }
    }

    if (data.combos != null) {
      for (final combo in data.combos!) {
        _combos[combo.id] = combo;
      }
    }
  }

  /// Get all graph data
  GraphData getData() {
    return GraphData(
      nodes: _nodes.values.toList(),
      edges: _edges.values.toList(),
      combos: _combos.values.toList(),
    );
  }

  /// Add nodes
  void addNodes(List<NodeData> nodes) {
    for (final node in nodes) {
      _nodes[node.id] = node;
    }
  }

  /// Add edges
  void addEdges(List<EdgeData> edges) {
    for (final edge in edges) {
      final id = edge.effectiveId;
      _edges[id] = edge;
      _indexEdge(edge);
    }
  }

  /// Add combos
  void addCombos(List<ComboData> combos) {
    for (final combo in combos) {
      _combos[combo.id] = combo;
    }
  }

  /// Update node
  void updateNode(NodeData node) {
    if (_nodes.containsKey(node.id)) {
      _nodes[node.id] = node;
    }
  }

  /// Update edge
  void updateEdge(EdgeData edge) {
    final id = edge.effectiveId;
    if (_edges.containsKey(id)) {
      _edges[id] = edge;
      _reindexEdge(id, edge);
    }
  }

  /// Update combo
  void updateCombo(ComboData combo) {
    if (_combos.containsKey(combo.id)) {
      _combos[combo.id] = combo;
    }
  }

  /// Remove nodes
  void removeNodes(List<ElementID> nodeIds) {
    for (final id in nodeIds) {
      _nodes.remove(id);
      _removeNodeEdges(id);
    }
  }

  /// Remove edges
  void removeEdges(List<ElementID> edgeIds) {
    for (final id in edgeIds) {
      final edge = _edges.remove(id);
      if (edge != null) {
        _unindexEdge(edge);
      }
    }
  }

  /// Remove combos
  void removeCombos(List<ElementID> comboIds) {
    for (final id in comboIds) {
      _combos.remove(id);
    }
  }

  /// Get node by ID
  NodeData? getNode(ElementID id) {
    return _nodes[id];
  }

  /// Get edge by ID
  EdgeData? getEdge(ElementID id) {
    return _edges[id];
  }

  /// Get combo by ID
  ComboData? getCombo(ElementID id) {
    return _combos[id];
  }

  /// Get all nodes
  List<NodeData> getAllNodes() {
    return _nodes.values.toList();
  }

  /// Get all edges
  List<EdgeData> getAllEdges() {
    return _edges.values.toList();
  }

  /// Get all combos
  List<ComboData> getAllCombos() {
    return _combos.values.toList();
  }

  /// Get neighbors of a node
  List<NodeData> getNeighbors(ElementID nodeId) {
    final neighbors = <NodeData>[];
    final edges = _nodeEdges[nodeId] ?? [];

    for (final edge in edges) {
      final neighborId = edge.source == nodeId ? edge.target : edge.source;
      final neighbor = _nodes[neighborId];
      if (neighbor != null) {
        neighbors.add(neighbor);
      }
    }

    return neighbors;
  }

  /// Get related edges of nodes
  List<EdgeData> getRelatedEdges(List<ElementID> nodeIds) {
    final relatedEdges = <EdgeData>[];
    final nodeIdSet = Set<ElementID>.from(nodeIds);

    for (final nodeId in nodeIds) {
      final edges = _nodeEdges[nodeId] ?? [];
      for (final edge in edges) {
        if (nodeIdSet.contains(edge.source) && nodeIdSet.contains(edge.target)) {
          if (!relatedEdges.contains(edge)) {
            relatedEdges.add(edge);
          }
        }
      }
    }

    return relatedEdges;
  }

  /// Set element state
  void setElementState(ElementID id, State state, bool enabled) {
    // Try to find element in nodes, edges, or combos
    final node = _nodes[id];
    if (node != null) {
      final states = List<State>.from(node.states ?? []);
      if (enabled && !states.contains(state)) {
        states.add(state);
      } else if (!enabled) {
        states.remove(state);
      }
      _nodes[id] = node.copyWith(states: states);
      return;
    }

    final edge = _edges[id];
    if (edge != null) {
      final states = List<State>.from(edge.states ?? []);
      if (enabled && !states.contains(state)) {
        states.add(state);
      } else if (!enabled) {
        states.remove(state);
      }
      _edges[id] = edge.copyWith(states: states);
      return;
    }

    final combo = _combos[id];
    if (combo != null) {
      final states = List<State>.from(combo.states ?? []);
      if (enabled && !states.contains(state)) {
        states.add(state);
      } else if (!enabled) {
        states.remove(state);
      }
      _combos[id] = combo.copyWith(states: states);
    }
  }

  /// Get element states
  List<State>? getElementStates(ElementID id) {
    return _nodes[id]?.states ?? _edges[id]?.states ?? _combos[id]?.states;
  }

  /// Clear all states of an element
  void clearElementStates(ElementID id) {
    final node = _nodes[id];
    if (node != null) {
      _nodes[id] = node.copyWith(states: []);
      return;
    }

    final edge = _edges[id];
    if (edge != null) {
      _edges[id] = edge.copyWith(states: []);
      return;
    }

    final combo = _combos[id];
    if (combo != null) {
      _combos[id] = combo.copyWith(states: []);
    }
  }

  /// Clear all data
  void clear() {
    _nodes.clear();
    _edges.clear();
    _combos.clear();
    _nodeEdges.clear();
  }

  // Private helper methods

  void _indexEdge(EdgeData edge) {
    _nodeEdges.putIfAbsent(edge.source, () => []).add(edge);
    _nodeEdges.putIfAbsent(edge.target, () => []).add(edge);
  }

  void _unindexEdge(EdgeData edge) {
    _nodeEdges[edge.source]?.remove(edge);
    _nodeEdges[edge.target]?.remove(edge);
  }

  void _reindexEdge(ElementID id, EdgeData edge) {
    final oldEdge = _edges[id];
    if (oldEdge != null) {
      _unindexEdge(oldEdge);
    }
    _indexEdge(edge);
  }

  void _removeNodeEdges(ElementID nodeId) {
    final edges = List<EdgeData>.from(_nodeEdges[nodeId] ?? []);
    for (final edge in edges) {
      _edges.remove(edge.effectiveId);
      _unindexEdge(edge);
    }
    _nodeEdges.remove(nodeId);
  }
}
