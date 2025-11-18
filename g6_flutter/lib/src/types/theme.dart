import 'dart:ui';

/// Theme type
enum ThemeType {
  light,
  dark,
  custom,
}

/// Theme configuration
class ThemeConfig {
  ThemeConfig({
    required this.type,
    this.nodeStyle,
    this.edgeStyle,
    this.comboStyle,
    this.canvasBackground,
  });

  final ThemeType type;
  final Map<String, dynamic>? nodeStyle;
  final Map<String, dynamic>? edgeStyle;
  final Map<String, dynamic>? comboStyle;
  final Color? canvasBackground;

  /// Create light theme
  factory ThemeConfig.light() {
    return ThemeConfig(
      type: ThemeType.light,
      canvasBackground: const Color(0xFFFFFFFF),
      nodeStyle: {
        'fill': const Color(0xFF5B8FF9),
        'stroke': const Color(0xFF5B8FF9),
        'lineWidth': 2.0,
      },
      edgeStyle: {
        'stroke': const Color(0xFFE2E2E2),
        'lineWidth': 1.0,
      },
      comboStyle: {
        'fill': const Color(0xFFF7F9FB),
        'stroke': const Color(0xFFD0D7DE),
        'lineWidth': 1.0,
      },
    );
  }

  /// Create dark theme
  factory ThemeConfig.dark() {
    return ThemeConfig(
      type: ThemeType.dark,
      canvasBackground: const Color(0xFF1F1F1F),
      nodeStyle: {
        'fill': const Color(0xFF4A90E2),
        'stroke': const Color(0xFF4A90E2),
        'lineWidth': 2.0,
      },
      edgeStyle: {
        'stroke': const Color(0xFF404040),
        'lineWidth': 1.0,
      },
      comboStyle: {
        'fill': const Color(0xFF2A2A2A),
        'stroke': const Color(0xFF505050),
        'lineWidth': 1.0,
      },
    );
  }
}
