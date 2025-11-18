import 'dart:math' as math;

import 'package:g6_flutter/src/types/point.dart';

/// Math utilities for graph calculations
class MathUtils {
  /// Calculate distance between two points
  static double distance(G6Point p1, G6Point p2) {
    return p1.distanceTo(p2);
  }

  /// Calculate angle between two points (in radians)
  static double angle(G6Point p1, G6Point p2) {
    return math.atan2(p2.y - p1.y, p2.x - p1.x);
  }

  /// Calculate point on line at given ratio (0-1)
  static G6Point pointAt(G6Point p1, G6Point p2, double ratio) {
    return G6Point(
      p1.x + (p2.x - p1.x) * ratio,
      p1.y + (p2.y - p1.y) * ratio,
      p1.z + (p2.z - p1.z) * ratio,
    );
  }

  /// Rotate point around center by angle (in radians)
  static G6Point rotatePoint(G6Point point, G6Point center, double angle) {
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    final dx = point.x - center.x;
    final dy = point.y - center.y;

    return G6Point(
      center.x + dx * cos - dy * sin,
      center.y + dx * sin + dy * cos,
      point.z,
    );
  }

  /// Clamp value between min and max
  static double clamp(double value, double min, double max) {
    return math.max(min, math.min(max, value));
  }

  /// Linear interpolation
  static double lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }

  /// Check if two numbers are approximately equal
  static bool approxEqual(double a, double b, {double epsilon = 0.0001}) {
    return (a - b).abs() < epsilon;
  }

  /// Degrees to radians
  static double degToRad(double degrees) {
    return degrees * math.pi / 180;
  }

  /// Radians to degrees
  static double radToDeg(double radians) {
    return radians * 180 / math.pi;
  }

  /// Get bounding box center
  static G6Point getBBoxCenter(List<G6Point> points) {
    if (points.isEmpty) return G6Point.zero;

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final point in points) {
      minX = math.min(minX, point.x);
      minY = math.min(minY, point.y);
      maxX = math.max(maxX, point.x);
      maxY = math.max(maxY, point.y);
    }

    return G6Point((minX + maxX) / 2, (minY + maxY) / 2);
  }
}
