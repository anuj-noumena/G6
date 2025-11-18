import 'package:g6_flutter/src/elements/base/base_edge.dart';
import 'package:g6_flutter/src/elements/base/base_node.dart';
import 'package:g6_flutter/src/elements/edges/cubic.dart';
import 'package:g6_flutter/src/elements/edges/line.dart';
import 'package:g6_flutter/src/elements/edges/polyline.dart';
import 'package:g6_flutter/src/elements/edges/quadratic.dart';
import 'package:g6_flutter/src/elements/nodes/circle.dart';
import 'package:g6_flutter/src/elements/nodes/diamond.dart';
import 'package:g6_flutter/src/elements/nodes/ellipse.dart';
import 'package:g6_flutter/src/elements/nodes/hexagon.dart';
import 'package:g6_flutter/src/elements/nodes/image.dart';
import 'package:g6_flutter/src/elements/nodes/rect.dart';
import 'package:g6_flutter/src/elements/nodes/star.dart';
import 'package:g6_flutter/src/elements/nodes/triangle.dart';

/// Shape registry for managing node and edge shapes
class ShapeRegistry {
  static final ShapeRegistry _instance = ShapeRegistry._internal();

  factory ShapeRegistry() => _instance;

  ShapeRegistry._internal() {
    _registerBuiltInShapes();
  }

  final Map<String, BaseNode> _nodeShapes = {};
  final Map<String, BaseEdge> _edgeShapes = {};

  void _registerBuiltInShapes() {
    // Register built-in node shapes
    _nodeShapes['circle'] = const CircleNode();
    _nodeShapes['rect'] = const RectNode();
    _nodeShapes['ellipse'] = const EllipseNode();
    _nodeShapes['diamond'] = const DiamondNode();
    _nodeShapes['triangle'] = const TriangleNode();
    _nodeShapes['hexagon'] = const HexagonNode();
    _nodeShapes['star'] = const StarNode();
    _nodeShapes['image'] = const ImageNode();

    // Register built-in edge shapes
    _edgeShapes['line'] = const LineEdge();
    _edgeShapes['polyline'] = const PolylineEdge();
    _edgeShapes['quadratic'] = const QuadraticEdge();
    _edgeShapes['cubic'] = const CubicEdge();
  }

  /// Get node shape by type
  BaseNode getNodeShape(String type) {
    return _nodeShapes[type] ?? const CircleNode();
  }

  /// Get edge shape by type
  BaseEdge getEdgeShape(String type) {
    return _edgeShapes[type] ?? const LineEdge();
  }

  /// Register custom node shape
  void registerNodeShape(String type, BaseNode shape) {
    _nodeShapes[type] = shape;
  }

  /// Register custom edge shape
  void registerEdgeShape(String type, BaseEdge shape) {
    _edgeShapes[type] = shape;
  }
}
