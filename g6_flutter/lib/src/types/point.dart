import 'dart:ui';

import 'package:equatable/equatable.dart';

/// Point representation in 2D or 3D space
class G6Point extends Equatable {
  const G6Point(this.x, this.y, [this.z = 0]);

  final double x;
  final double y;
  final double z;

  /// Create a point from an Offset (2D)
  factory G6Point.fromOffset(Offset offset) {
    return G6Point(offset.dx, offset.dy);
  }

  /// Convert to Flutter Offset
  Offset toOffset() {
    return Offset(x, y);
  }

  /// Create a point from a list [x, y] or [x, y, z]
  factory G6Point.fromList(List<double> coords) {
    if (coords.length < 2) {
      throw ArgumentError('Point requires at least 2 coordinates');
    }
    return G6Point(
      coords[0],
      coords[1],
      coords.length > 2 ? coords[2] : 0,
    );
  }

  /// Convert to list [x, y, z]
  List<double> toList() => [x, y, z];

  /// Zero point
  static const zero = G6Point(0, 0, 0);

  /// Add two points
  G6Point operator +(G6Point other) {
    return G6Point(x + other.x, y + other.y, z + other.z);
  }

  /// Subtract two points
  G6Point operator -(G6Point other) {
    return G6Point(x - other.x, y - other.y, z - other.z);
  }

  /// Multiply point by scalar
  G6Point operator *(double scalar) {
    return G6Point(x * scalar, y * scalar, z * scalar);
  }

  /// Divide point by scalar
  G6Point operator /(double scalar) {
    return G6Point(x / scalar, y / scalar, z / scalar);
  }

  /// Calculate distance to another point
  double distanceTo(G6Point other) {
    final dx = x - other.x;
    final dy = y - other.y;
    final dz = z - other.z;
    return (dx * dx + dy * dy + dz * dz).abs();
  }

  @override
  List<Object?> get props => [x, y, z];

  @override
  String toString() => 'G6Point($x, $y, $z)';
}
