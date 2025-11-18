import 'package:g6_flutter/src/types/data.dart';
import 'package:g6_flutter/src/types/layout.dart';
import 'package:g6_flutter/src/types/node.dart';

/// Base class for all layout algorithms
abstract class BaseLayout {
  BaseLayout(this.config);

  final LayoutConfig config;

  /// Execute the layout algorithm on the given data
  Future<void> execute(GraphData data);

  /// Get the center point for the layout
  List<double> getCenter() {
    return config.center ?? [0, 0];
  }

  /// Get default node size
  double getNodeSize() {
    return config.nodeSize ?? 40;
  }

  /// Get node spacing
  double getNodeSpacing() {
    return config.nodeSpacing ?? 50;
  }
}
