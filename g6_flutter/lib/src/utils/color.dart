import 'dart:ui';

/// Color utilities
class ColorUtils {
  /// Parse hex color string to Color
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Convert Color to hex string
  static String toHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  /// Lighten color by amount (0-1)
  static Color lighten(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// Darken color by amount (0-1)
  static Color darken(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// Set opacity of color
  static Color withOpacity(Color color, double opacity) {
    assert(opacity >= 0 && opacity <= 1);
    return color.withOpacity(opacity);
  }

  /// Mix two colors with ratio (0-1, 0=color1, 1=color2)
  static Color mix(Color color1, Color color2, double ratio) {
    assert(ratio >= 0 && ratio <= 1);

    return Color.fromARGB(
      (color1.alpha + (color2.alpha - color1.alpha) * ratio).round(),
      (color1.red + (color2.red - color1.red) * ratio).round(),
      (color1.green + (color2.green - color1.green) * ratio).round(),
      (color1.blue + (color2.blue - color1.blue) * ratio).round(),
    );
  }

  /// Get contrasting color (black or white) for text
  static Color getContrastColor(Color color) {
    // Calculate relative luminance
    final luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;

    return luminance > 0.5 ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  }
}
