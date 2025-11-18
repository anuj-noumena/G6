/// Layout type enumeration
enum LayoutType {
  // Force-directed layouts
  force,
  d3Force,
  forceAtlas2,
  fruchterman,

  // Hierarchical layouts
  dagre,
  compactBox,
  dendrogram,
  mindmap,
  indented,

  // Circular layouts
  circular,
  radial,
  concentric,

  // Grid layouts
  grid,
  snake,

  // Other layouts
  random,
  mds,
}

/// Layout configuration base class
class LayoutConfig {
  LayoutConfig({
    required this.type,
    this.center,
    this.nodeSize,
    this.nodeSpacing,
    this.preventOverlap = false,
    this.workerEnabled = false,
  });

  final LayoutType type;
  final List<double>? center;
  final double? nodeSize;
  final double? nodeSpacing;
  final bool preventOverlap;
  final bool workerEnabled;

  LayoutConfig copyWith({
    LayoutType? type,
    List<double>? center,
    double? nodeSize,
    double? nodeSpacing,
    bool? preventOverlap,
    bool? workerEnabled,
  }) {
    return LayoutConfig(
      type: type ?? this.type,
      center: center ?? this.center,
      nodeSize: nodeSize ?? this.nodeSize,
      nodeSpacing: nodeSpacing ?? this.nodeSpacing,
      preventOverlap: preventOverlap ?? this.preventOverlap,
      workerEnabled: workerEnabled ?? this.workerEnabled,
    );
  }
}

/// Force layout configuration
class ForceLayoutConfig extends LayoutConfig {
  ForceLayoutConfig({
    this.iterations = 300,
    this.linkDistance = 50,
    this.nodeStrength = -30,
    this.edgeStrength = 0.1,
    this.collideStrength = 1,
    this.alpha = 0.9,
    this.alphaMin = 0.001,
    this.alphaDecay = 0.028,
    super.center,
    super.nodeSize,
    super.preventOverlap,
  }) : super(type: LayoutType.force);

  final int iterations;
  final double linkDistance;
  final double nodeStrength;
  final double edgeStrength;
  final double collideStrength;
  final double alpha;
  final double alphaMin;
  final double alphaDecay;
}

/// Circular layout configuration
class CircularLayoutConfig extends LayoutConfig {
  CircularLayoutConfig({
    this.radius,
    this.startAngle = 0,
    this.endAngle = 6.283185307179586, // 2 * PI
    this.clockwise = true,
    this.divisions = 1,
    this.ordering,
    super.center,
  }) : super(type: LayoutType.circular);

  final double? radius;
  final double startAngle;
  final double endAngle;
  final bool clockwise;
  final int divisions;
  final String? ordering;
}

/// Grid layout configuration
class GridLayoutConfig extends LayoutConfig {
  GridLayoutConfig({
    this.rows,
    this.cols,
    this.sortBy,
    super.center,
    super.nodeSpacing,
  }) : super(type: LayoutType.grid);

  final int? rows;
  final int? cols;
  final String? sortBy;
}

/// Dagre (hierarchical) layout configuration
class DagreLayoutConfig extends LayoutConfig {
  DagreLayoutConfig({
    this.rankdir = 'TB', // TB, BT, LR, RL
    this.align,
    this.nodesep = 50,
    this.ranksep = 50,
    this.controlPoints = true,
    super.center,
  }) : super(type: LayoutType.dagre);

  final String rankdir;
  final String? align;
  final double nodesep;
  final double ranksep;
  final bool controlPoints;
}
