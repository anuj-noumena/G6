import 'dart:ui';

import 'package:g6_flutter/src/types/padding.dart';
import 'package:g6_flutter/src/types/size.dart';

/// Base style properties for all elements
class BaseStyle {
  BaseStyle({
    this.fill,
    this.stroke,
    this.lineWidth,
    this.opacity,
    this.shadowColor,
    this.shadowBlur,
    this.shadowOffsetX,
    this.shadowOffsetY,
    this.lineDash,
    this.cursor,
    this.visibility,
    this.zIndex,
  });

  final Color? fill;
  final Color? stroke;
  final double? lineWidth;
  final double? opacity;
  final Color? shadowColor;
  final double? shadowBlur;
  final double? shadowOffsetX;
  final double? shadowOffsetY;
  final List<double>? lineDash;
  final String? cursor;
  final bool? visibility;
  final int? zIndex;

  BaseStyle copyWith({
    Color? fill,
    Color? stroke,
    double? lineWidth,
    double? opacity,
    Color? shadowColor,
    double? shadowBlur,
    double? shadowOffsetX,
    double? shadowOffsetY,
    List<double>? lineDash,
    String? cursor,
    bool? visibility,
    int? zIndex,
  }) {
    return BaseStyle(
      fill: fill ?? this.fill,
      stroke: stroke ?? this.stroke,
      lineWidth: lineWidth ?? this.lineWidth,
      opacity: opacity ?? this.opacity,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowOffsetX: shadowOffsetX ?? this.shadowOffsetX,
      shadowOffsetY: shadowOffsetY ?? this.shadowOffsetY,
      lineDash: lineDash ?? this.lineDash,
      cursor: cursor ?? this.cursor,
      visibility: visibility ?? this.visibility,
      zIndex: zIndex ?? this.zIndex,
    );
  }
}

/// Label style properties
class LabelStyle extends BaseStyle {
  LabelStyle({
    this.text,
    this.fontSize,
    this.fontFamily,
    this.fontWeight,
    this.fontStyle,
    this.textAlign,
    this.textBaseline,
    this.maxWidth,
    this.wordWrap,
    this.wordWrapWidth,
    this.offsetX,
    this.offsetY,
    this.padding,
    this.background,
    this.backgroundOpacity,
    super.fill,
    super.stroke,
    super.lineWidth,
    super.opacity,
  });

  final String? text;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;
  final String? textBaseline;
  final double? maxWidth;
  final bool? wordWrap;
  final double? wordWrapWidth;
  final double? offsetX;
  final double? offsetY;
  final G6Padding? padding;
  final Color? background;
  final double? backgroundOpacity;
}

/// Badge style properties
class BadgeStyle extends BaseStyle {
  BadgeStyle({
    this.text,
    this.fontSize,
    this.fontFamily,
    this.textColor,
    this.size,
    this.offsetX,
    this.offsetY,
    super.fill,
    super.stroke,
    super.lineWidth,
  });

  final String? text;
  final double? fontSize;
  final String? fontFamily;
  final Color? textColor;
  final G6Size? size;
  final double? offsetX;
  final double? offsetY;
}

/// Icon style properties
class IconStyle {
  IconStyle({
    this.text,
    this.fontSize,
    this.fontFamily,
    this.color,
    this.offsetX,
    this.offsetY,
    this.src,
    this.width,
    this.height,
  });

  final String? text;
  final double? fontSize;
  final String? fontFamily;
  final Color? color;
  final double? offsetX;
  final double? offsetY;
  final String? src;
  final double? width;
  final double? height;
}
