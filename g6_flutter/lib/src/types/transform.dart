/// Transform type enumeration
enum TransformType {
  // Arrangement transforms
  arrangeDrawOrder,

  // Collapse/expand transforms
  collapseExpandNode,
  collapseExpandCombo,

  // Edge transforms
  getEdgeActualEnds,
  processParallelEdges,
  updateRelatedEdges,

  // Node transforms
  mapNodeSize,

  // Label transforms
  placeRadialLabels,
}

/// Transform configuration base class
class TransformConfig {
  TransformConfig({
    required this.type,
    this.key,
  });

  final TransformType type;
  final String? key;
}

/// Arrange draw order transform configuration
class ArrangeDrawOrderConfig extends TransformConfig {
  ArrangeDrawOrderConfig({
    this.order = const ['combo', 'edge', 'node'],
    super.key,
  }) : super(type: TransformType.arrangeDrawOrder);

  final List<String> order;
}

/// Process parallel edges transform configuration
class ProcessParallelEdgesConfig extends TransformConfig {
  ProcessParallelEdgesConfig({
    this.offsetDiff = 15,
    this.multiEdgeType = 'quadratic',
    super.key,
  }) : super(type: TransformType.processParallelEdges);

  final double offsetDiff;
  final String multiEdgeType;
}

/// Map node size transform configuration
class MapNodeSizeConfig extends TransformConfig {
  MapNodeSizeConfig({
    this.field,
    this.range = const [16, 60],
    super.key,
  }) : super(type: TransformType.mapNodeSize);

  final String? field;
  final List<double> range;
}
