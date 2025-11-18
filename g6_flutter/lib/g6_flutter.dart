/// G6 Flutter - A powerful graph visualization framework for Flutter
///
/// Ported from AntV G6: https://github.com/antvis/G6
library g6_flutter;

// Core exports
export 'src/runtime/graph.dart';

// Data types
export 'src/types/data.dart';
export 'src/types/node.dart';
export 'src/types/edge.dart';
export 'src/types/combo.dart';
export 'src/types/element.dart';
export 'src/types/style.dart';
export 'src/types/point.dart';
export 'src/types/size.dart';
export 'src/types/padding.dart';
export 'src/types/animation.dart';
export 'src/types/layout.dart';
export 'src/types/behavior.dart';
export 'src/types/plugin.dart';
export 'src/types/event.dart';
export 'src/types/state.dart';
export 'src/types/transform.dart';
export 'src/types/theme.dart';
export 'src/types/palette.dart';

// Elements
export 'src/elements/base/base_shape.dart';
export 'src/elements/base/base_element.dart';
export 'src/elements/base/base_node.dart';
export 'src/elements/base/base_edge.dart';
export 'src/elements/base/base_combo.dart';

// Built-in nodes
export 'src/elements/nodes/circle.dart';
export 'src/elements/nodes/rect.dart';
export 'src/elements/nodes/ellipse.dart';
export 'src/elements/nodes/diamond.dart';
export 'src/elements/nodes/triangle.dart';
export 'src/elements/nodes/hexagon.dart';
export 'src/elements/nodes/star.dart';
export 'src/elements/nodes/image.dart';

// Built-in edges
export 'src/elements/edges/line.dart';
export 'src/elements/edges/polyline.dart';
export 'src/elements/edges/quadratic.dart';
export 'src/elements/edges/cubic.dart';

// Built-in combos
export 'src/elements/combos/circle_combo.dart';
export 'src/elements/combos/rect_combo.dart';

// Behaviors
export 'src/behaviors/base_behavior.dart';
export 'src/behaviors/drag_canvas.dart';
export 'src/behaviors/zoom_canvas.dart';
export 'src/behaviors/drag_element.dart';
export 'src/behaviors/click_select.dart';
export 'src/behaviors/brush_select.dart';

// Plugins
export 'src/plugins/base_plugin.dart';
export 'src/plugins/minimap.dart';
export 'src/plugins/toolbar.dart';
export 'src/plugins/tooltip.dart';
export 'src/plugins/history.dart';

// Layouts
export 'src/layouts/base_layout.dart';
export 'src/layouts/force.dart';
export 'src/layouts/dagre.dart';
export 'src/layouts/circular.dart';
export 'src/layouts/grid.dart';

// Transforms
export 'src/transforms/base_transform.dart';

// Registry
export 'src/registry/registry.dart';
export 'src/registry/extension.dart';

// Utils
export 'src/utils/id.dart';
export 'src/utils/math.dart';
export 'src/utils/color.dart';

// Constants
export 'src/constants/events.dart';
export 'src/constants/enums.dart';

// Themes
export 'src/themes/light_theme.dart';
export 'src/themes/dark_theme.dart';

// Widgets
export 'src/widgets/g6_graph.dart';
