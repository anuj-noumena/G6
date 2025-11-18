import 'package:flutter/material.dart';
import 'package:g6_flutter/src/elements/base/base_shape.dart';
import 'package:g6_flutter/src/types/node.dart';

/// Base node class
abstract class BaseNode extends BaseShape {
  const BaseNode();

  /// Paint node with label and other decorations
  void paintNode(Canvas canvas, Offset center, NodeStyle style) {
    // Paint main shape
    paint(canvas, center, style);

    // Paint label if present
    if (style.labelText != null) {
      paintLabel(canvas, center, style);
    }

    // Paint badges if present
    if (style.badges != null && style.badges!.isNotEmpty) {
      for (final badge in style.badges!) {
        paintBadge(canvas, center, badge, style);
      }
    }
  }

  void paintLabel(Canvas canvas, Offset center, NodeStyle style) {
    final label = style.label;
    final text = style.labelText!;

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: label?.fill ?? Colors.black,
          fontSize: label?.fontSize ?? 12,
          fontWeight: label?.fontWeight,
          fontStyle: label?.fontStyle,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Position based on placement
    final placement = label?.placement ?? DirectionalPlacement.bottom;
    final offsetX = label?.offsetX ?? 0;
    final offsetY = label?.offsetY ?? 0;

    Offset labelOffset;
    switch (placement) {
      case DirectionalPlacement.top:
        labelOffset = Offset(
          center.dx - textPainter.width / 2 + offsetX,
          center.dy - (style.size?.height ?? 40) / 2 - textPainter.height - 5 + offsetY,
        );
        break;
      case DirectionalPlacement.bottom:
        labelOffset = Offset(
          center.dx - textPainter.width / 2 + offsetX,
          center.dy + (style.size?.height ?? 40) / 2 + 5 + offsetY,
        );
        break;
      case DirectionalPlacement.left:
        labelOffset = Offset(
          center.dx - (style.size?.width ?? 40) / 2 - textPainter.width - 5 + offsetX,
          center.dy - textPainter.height / 2 + offsetY,
        );
        break;
      case DirectionalPlacement.right:
        labelOffset = Offset(
          center.dx + (style.size?.width ?? 40) / 2 + 5 + offsetX,
          center.dy - textPainter.height / 2 + offsetY,
        );
        break;
      case DirectionalPlacement.center:
        labelOffset = Offset(
          center.dx - textPainter.width / 2 + offsetX,
          center.dy - textPainter.height / 2 + offsetY,
        );
        break;
      default:
        labelOffset = Offset(
          center.dx - textPainter.width / 2 + offsetX,
          center.dy + (style.size?.height ?? 40) / 2 + 5 + offsetY,
        );
    }

    textPainter.paint(canvas, labelOffset);
  }

  void paintBadge(Canvas canvas, Offset center, NodeBadgeStyle badge, NodeStyle style) {
    // Simplified badge rendering
    final text = badge.text ?? '';
    if (text.isEmpty) return;

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: badge.textColor ?? Colors.white,
          fontSize: badge.fontSize ?? 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final badgeSize = badge.size?.width ?? 20;
    final placement = badge.placement;

    Offset badgeOffset;
    switch (placement) {
      case DirectionalPlacement.topRight:
        badgeOffset = Offset(
          center.dx + (style.size?.width ?? 40) / 2 - badgeSize / 2,
          center.dy - (style.size?.height ?? 40) / 2 - badgeSize / 2,
        );
        break;
      case DirectionalPlacement.topLeft:
        badgeOffset = Offset(
          center.dx - (style.size?.width ?? 40) / 2 - badgeSize / 2,
          center.dy - (style.size?.height ?? 40) / 2 - badgeSize / 2,
        );
        break;
      case DirectionalPlacement.bottomRight:
        badgeOffset = Offset(
          center.dx + (style.size?.width ?? 40) / 2 - badgeSize / 2,
          center.dy + (style.size?.height ?? 40) / 2 - badgeSize / 2,
        );
        break;
      case DirectionalPlacement.bottomLeft:
        badgeOffset = Offset(
          center.dx - (style.size?.width ?? 40) / 2 - badgeSize / 2,
          center.dy + (style.size?.height ?? 40) / 2 - badgeSize / 2,
        );
        break;
      default:
        badgeOffset = Offset(
          center.dx + (style.size?.width ?? 40) / 2 - badgeSize / 2,
          center.dy - (style.size?.height ?? 40) / 2 - badgeSize / 2,
        );
    }

    // Draw badge circle
    final badgePaint = Paint()
      ..color = badge.fill ?? Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(badgeOffset.dx + badgeSize / 2, badgeOffset.dy + badgeSize / 2),
      badgeSize / 2,
      badgePaint,
    );

    // Draw badge text
    textPainter.paint(
      canvas,
      Offset(
        badgeOffset.dx + badgeSize / 2 - textPainter.width / 2,
        badgeOffset.dy + badgeSize / 2 - textPainter.height / 2,
      ),
    );
  }
}
