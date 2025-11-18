import 'dart:ui';

/// Plugin type enumeration
enum PluginType {
  // Visual plugins
  background,
  gridLine,
  watermark,
  title,

  // Analysis plugins
  hull,
  legend,
  edgeBundling,

  // Navigation plugins
  minimap,
  toolbar,
  contextMenu,

  // Interaction plugins
  fisheye,
  snapline,
  fullscreen,

  // State plugins
  history,
  tooltip,
}

/// Plugin configuration base class
class PluginConfig {
  PluginConfig({
    required this.type,
    this.key,
    this.position,
  });

  final PluginType type;
  final String? key;
  final PluginPosition? position;
}

/// Plugin position
enum PluginPosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  top,
  bottom,
  left,
  right,
}

/// Minimap plugin configuration
class MinimapConfig extends PluginConfig {
  MinimapConfig({
    this.size = const Size(200, 120),
    this.position = PluginPosition.bottomRight,
    this.padding = 10,
    this.className,
    super.key,
  }) : super(
          type: PluginType.minimap,
          position: position,
        );

  final Size size;
  @override
  final PluginPosition position;
  final double padding;
  final String? className;
}

/// Toolbar plugin configuration
class ToolbarConfig extends PluginConfig {
  ToolbarConfig({
    this.position = PluginPosition.top,
    this.items,
    super.key,
  }) : super(
          type: PluginType.toolbar,
          position: position,
        );

  @override
  final PluginPosition position;
  final List<ToolbarItem>? items;
}

/// Toolbar item
class ToolbarItem {
  ToolbarItem({
    required this.id,
    this.name,
    this.icon,
    this.onClick,
  });

  final String id;
  final String? name;
  final dynamic icon;
  final void Function()? onClick;
}

/// Tooltip plugin configuration
class TooltipConfig extends PluginConfig {
  TooltipConfig({
    this.getContent,
    this.offsetX = 0,
    this.offsetY = 0,
    super.key,
  }) : super(type: PluginType.tooltip);

  final String Function(dynamic item)? getContent;
  final double offsetX;
  final double offsetY;
}

/// History plugin configuration (for undo/redo)
class HistoryConfig extends PluginConfig {
  HistoryConfig({
    this.maxStep = 50,
    super.key,
  }) : super(type: PluginType.history);

  final int maxStep;
}
