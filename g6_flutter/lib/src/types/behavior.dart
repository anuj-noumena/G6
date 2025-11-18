/// Behavior type enumeration
enum BehaviorType {
  // Selection behaviors
  clickSelect,
  brushSelect,
  lassoSelect,

  // Navigation behaviors
  dragCanvas,
  scrollCanvas,
  zoomCanvas,

  // Element manipulation
  dragElement,
  dragNode,
  dragCombo,
  createEdge,

  // Visual behaviors
  hoverActivate,
  focusElement,
  autoAdaptLabel,

  // Other behaviors
  collapseExpand,
}

/// Behavior configuration base class
class BehaviorConfig {
  BehaviorConfig({
    required this.type,
    this.enable = true,
  });

  final BehaviorType type;
  final bool enable;
}

/// Drag canvas behavior configuration
class DragCanvasBehaviorConfig extends BehaviorConfig {
  DragCanvasBehaviorConfig({
    this.direction = DragDirection.both,
    this.scalableRange = const [0.1, 10],
    super.enable,
  }) : super(type: BehaviorType.dragCanvas);

  final DragDirection direction;
  final List<double> scalableRange;
}

/// Zoom canvas behavior configuration
class ZoomCanvasBehaviorConfig extends BehaviorConfig {
  ZoomCanvasBehaviorConfig({
    this.sensitivity = 1,
    this.minZoom = 0.1,
    this.maxZoom = 10,
    this.enableOptimize = true,
    super.enable,
  }) : super(type: BehaviorType.zoomCanvas);

  final double sensitivity;
  final double minZoom;
  final double maxZoom;
  final bool enableOptimize;
}

/// Click select behavior configuration
class ClickSelectBehaviorConfig extends BehaviorConfig {
  ClickSelectBehaviorConfig({
    this.multiple = false,
    this.trigger = SelectTrigger.click,
    super.enable,
  }) : super(type: BehaviorType.clickSelect);

  final bool multiple;
  final SelectTrigger trigger;
}

/// Brush select behavior configuration
class BrushSelectBehaviorConfig extends BehaviorConfig {
  BrushSelectBehaviorConfig({
    this.trigger = SelectTrigger.drag,
    this.brushStyle,
    this.onSelect,
    super.enable,
  }) : super(type: BehaviorType.brushSelect);

  final SelectTrigger trigger;
  final Map<String, dynamic>? brushStyle;
  final void Function(List<String> selectedIds)? onSelect;
}

/// Drag direction
enum DragDirection {
  x,
  y,
  both,
}

/// Select trigger
enum SelectTrigger {
  click,
  dblclick,
  drag,
}
