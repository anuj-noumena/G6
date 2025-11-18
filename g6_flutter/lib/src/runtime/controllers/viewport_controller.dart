import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:g6_flutter/src/runtime/graph.dart';
import 'package:g6_flutter/src/types/point.dart';

/// Viewport controller - manages pan, zoom, and rotation
class ViewportController {
  ViewportController(this.graph);

  final Graph graph;

  Offset _offset = Offset.zero;
  double _zoom = 1.0;
  double _rotation = 0.0;

  /// Current pan offset
  Offset get offset => _offset;

  /// Current zoom level
  double get zoom => _zoom;

  /// Current rotation (in radians)
  double get rotation => _rotation;

  /// Pan to specific offset
  void panTo(Offset newOffset) {
    _offset = newOffset;
  }

  /// Pan by delta
  void panBy(Offset delta) {
    _offset += delta;
  }

  /// Zoom to specific level
  void zoomTo(double newZoom, {Offset? center}) {
    final zoomRange = graph.config.zoomRange;
    _zoom = newZoom.clamp(zoomRange[0], zoomRange[1]);

    // If center is provided, adjust pan to zoom around that point
    if (center != null) {
      final ratio = newZoom / _zoom;
      final dx = (center.dx - _offset.dx) * (1 - ratio);
      final dy = (center.dy - _offset.dy) * (1 - ratio);
      _offset = Offset(_offset.dx + dx, _offset.dy + dy);
    }
  }

  /// Zoom by factor
  void zoomBy(double factor, {Offset? center}) {
    zoomTo(_zoom * factor, center: center);
  }

  /// Rotate to specific angle (in radians)
  void rotateTo(double angle) {
    _rotation = angle;
  }

  /// Rotate by delta (in radians)
  void rotateBy(double delta) {
    _rotation += delta;
  }

  /// Fit view to show all elements
  void fitView({EdgeInsets padding = EdgeInsets.zero}) {
    final data = graph.dataController.getData();
    if (data.nodes == null || data.nodes!.isEmpty) {
      return;
    }

    // Calculate bounding box of all nodes
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final node in data.nodes!) {
      final style = node.style;
      if (style != null) {
        final x = style.x ?? 0;
        final y = style.y ?? 0;

        minX = math.min(minX, x);
        minY = math.min(minY, y);
        maxX = math.max(maxX, x);
        maxY = math.max(maxY, y);
      }
    }

    if (minX == double.infinity) return;

    // Calculate viewport size (from config or default)
    final viewportWidth = graph.config.width ?? 800;
    final viewportHeight = graph.config.height ?? 600;

    // Calculate content size
    final contentWidth = maxX - minX;
    final contentHeight = maxY - minY;

    // Calculate zoom to fit
    final zoomX = (viewportWidth - padding.left - padding.right) / contentWidth;
    final zoomY = (viewportHeight - padding.top - padding.bottom) / contentHeight;
    final fitZoom = math.min(zoomX, zoomY);

    // Apply zoom constraints
    final zoomRange = graph.config.zoomRange;
    final constrainedZoom = fitZoom.clamp(zoomRange[0], zoomRange[1]);

    // Calculate pan to center content
    final centerX = (minX + maxX) / 2;
    final centerY = (minY + maxY) / 2;

    _zoom = constrainedZoom;
    _offset = Offset(
      (viewportWidth / 2) - centerX * constrainedZoom,
      (viewportHeight / 2) - centerY * constrainedZoom,
    );
  }

  /// Convert viewport coordinates to canvas coordinates
  G6Point viewportToCanvas(Offset viewportPoint) {
    final x = (viewportPoint.dx - _offset.dx) / _zoom;
    final y = (viewportPoint.dy - _offset.dy) / _zoom;
    return G6Point(x, y);
  }

  /// Convert canvas coordinates to viewport coordinates
  Offset canvasToViewport(G6Point canvasPoint) {
    final x = canvasPoint.x * _zoom + _offset.dx;
    final y = canvasPoint.y * _zoom + _offset.dy;
    return Offset(x, y);
  }

  /// Reset viewport to default state
  void reset() {
    _offset = Offset.zero;
    _zoom = 1.0;
    _rotation = 0.0;
  }
}
