import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// Padding representation
class G6Padding extends Equatable {
  const G6Padding.all(double value)
      : top = value,
        right = value,
        bottom = value,
        left = value;

  const G6Padding.symmetric({
    double vertical = 0,
    double horizontal = 0,
  })  : top = vertical,
        right = horizontal,
        bottom = vertical,
        left = horizontal;

  const G6Padding.only({
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
  });

  final double top;
  final double right;
  final double bottom;
  final double left;

  /// Zero padding
  static const zero = G6Padding.all(0);

  /// Convert to Flutter EdgeInsets
  EdgeInsets toEdgeInsets() {
    return EdgeInsets.only(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
    );
  }

  /// Create from Flutter EdgeInsets
  factory G6Padding.fromEdgeInsets(EdgeInsets insets) {
    return G6Padding.only(
      top: insets.top,
      right: insets.right,
      bottom: insets.bottom,
      left: insets.left,
    );
  }

  @override
  List<Object?> get props => [top, right, bottom, left];

  @override
  String toString() => 'G6Padding(top: $top, right: $right, bottom: $bottom, left: $left)';
}
