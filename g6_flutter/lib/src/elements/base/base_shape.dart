import 'package:flutter/material.dart';
import 'package:g6_flutter/src/types/node.dart';
import 'package:g6_flutter/src/types/edge.dart';

/// Base shape class for all renderable elements
abstract class BaseShape {
  const BaseShape();

  /// Paint the shape on the canvas
  void paint(Canvas canvas, Offset center, dynamic style);

  /// Check if a point is inside the shape
  bool hitTest(Offset point, Offset center, dynamic style);

  /// Get the bounding box of the shape
  Rect getBounds(Offset center, dynamic style);
}
