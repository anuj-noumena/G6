import 'dart:ui';

/// Palette type
enum PaletteType {
  group,
  value,
}

/// Color palette configuration
class PaletteConfig {
  PaletteConfig({
    required this.type,
    this.field,
    this.colors,
  });

  final PaletteType type;
  final String? field; // Field to map colors to
  final List<Color>? colors;

  /// Default color palettes
  static List<Color> get tableau10 => [
        const Color(0xFF4E79A7),
        const Color(0xFFF28E2B),
        const Color(0xFFE15759),
        const Color(0xFF76B7B2),
        const Color(0xFF59A14F),
        const Color(0xFFEDC948),
        const Color(0xFFB07AA1),
        const Color(0xFFFF9DA7),
        const Color(0xFF9C755F),
        const Color(0xFFBAB0AC),
      ];

  static List<Color> get blues => [
        const Color(0xFFE7F1FA),
        const Color(0xFFBBDEF8),
        const Color(0xFF8AC7F5),
        const Color(0xFF5AACF0),
        const Color(0xFF3592E6),
        const Color(0xFF1678D7),
        const Color(0xFF0961B9),
        const Color(0xFF084B96),
        const Color(0xFF083872),
        const Color(0xFF072751),
      ];

  static List<Color> get greens => [
        const Color(0xFFE8F7E5),
        const Color(0xFFBFEBB9),
        const Color(0xFF8EDC85),
        const Color(0xFF5ECC55),
        const Color(0xFF36BC2D),
        const Color(0xFF1FAD13),
        const Color(0xFF169F0C),
        const Color(0xFF128C0B),
        const Color(0xFF0F780A),
        const Color(0xFF0C6308),
      ];

  static List<Color> get oranges => [
        const Color(0xFFFFF4E6),
        const Color(0xFFFFE0B3),
        const Color(0xFFFFCC80),
        const Color(0xFFFFB84D),
        const Color(0xFFFFA31A),
        const Color(0xFFE68F00),
        const Color(0xFFCC7A00),
        const Color(0xFFB36600),
        const Color(0xFF995200),
        const Color(0xFF803D00),
      ];

  /// Get color for a specific value
  Color getColor(int index) {
    if (colors == null || colors!.isEmpty) {
      return tableau10[index % tableau10.length];
    }
    return colors![index % colors!.length];
  }
}
