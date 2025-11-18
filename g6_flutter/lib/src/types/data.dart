import 'package:g6_flutter/src/types/combo.dart';
import 'package:g6_flutter/src/types/edge.dart';
import 'package:g6_flutter/src/types/node.dart';

/// Graph data structure
///
/// Contains collections of nodes, edges, and combos that make up a graph.
///
/// Example:
/// ```dart
/// final graphData = GraphData(
///   nodes: [
///     NodeData(id: 'node1', style: NodeStyle(x: 100, y: 100)),
///     NodeData(id: 'node2', style: NodeStyle(x: 200, y: 200)),
///   ],
///   edges: [
///     EdgeData(source: 'node1', target: 'node2'),
///   ],
/// );
/// ```
class GraphData {
  GraphData({
    this.nodes,
    this.edges,
    this.combos,
  });

  final List<NodeData>? nodes;
  final List<EdgeData>? edges;
  final List<ComboData>? combos;

  /// Check if graph data is empty
  bool get isEmpty =>
      (nodes == null || nodes!.isEmpty) &&
      (edges == null || edges!.isEmpty) &&
      (combos == null || combos!.isEmpty);

  /// Check if graph data is not empty
  bool get isNotEmpty => !isEmpty;

  /// Get total number of elements
  int get totalCount =>
      (nodes?.length ?? 0) + (edges?.length ?? 0) + (combos?.length ?? 0);

  GraphData copyWith({
    List<NodeData>? nodes,
    List<EdgeData>? edges,
    List<ComboData>? combos,
  }) {
    return GraphData(
      nodes: nodes ?? this.nodes,
      edges: edges ?? this.edges,
      combos: combos ?? this.combos,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      if (nodes != null) 'nodes': nodes!.map((n) => n.toJson()).toList(),
      if (edges != null) 'edges': edges!.map((e) => e.toJson()).toList(),
      if (combos != null) 'combos': combos!.map((c) => c.toJson()).toList(),
    };
  }

  /// Create from JSON
  factory GraphData.fromJson(Map<String, dynamic> json) {
    return GraphData(
      nodes: (json['nodes'] as List<dynamic>?)
          ?.map((n) => NodeData.fromJson(n as Map<String, dynamic>))
          .toList(),
      edges: (json['edges'] as List<dynamic>?)
          ?.map((e) => EdgeData.fromJson(e as Map<String, dynamic>))
          .toList(),
      combos: (json['combos'] as List<dynamic>?)
          ?.map((c) => ComboData.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Create empty graph data
  static GraphData empty() => GraphData();
}

/// Union type for node or combo data
typedef NodeLikeData = dynamic; // Can be NodeData or ComboData

/// Union type for any element data
typedef ElementDatum = dynamic; // Can be NodeData, EdgeData, or ComboData

/// Hierarchy key type
enum HierarchyKey {
  tree,
  combo,
}
