import 'dart:ui';

import 'package:equatable/equatable.dart';

/// Size representation
class G6Size extends Equatable {
  const G6Size(this.width, this.height);

  final double width;
  final double height;

  /// Create from Flutter Size
  factory G6Size.fromSize(Size size) {
    return G6Size(size.width, size.height);
  }

  /// Convert to Flutter Size
  Size toSize() {
    return Size(width, height);
  }

  /// Zero size
  static const zero = G6Size(0, 0);

  /// Check if size is empty
  bool get isEmpty => width <= 0 || height <= 0;

  /// Check if size is not empty
  bool get isNotEmpty => !isEmpty;

  /// Get area
  double get area => width * height;

  @override
  List<Object?> get props => [width, height];

  @override
  String toString() => 'G6Size($width, $height)';
}
