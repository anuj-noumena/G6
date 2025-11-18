import 'dart:ui';

import 'package:g6_flutter/src/types/id.dart';
import 'package:g6_flutter/src/types/size.dart';
import 'package:g6_flutter/src/types/state.dart';
import 'package:g6_flutter/src/types/style.dart';

/// Edge direction
enum EdgeDirection {
  /// Inbound edge
  inbound('in'),

  /// Outbound edge
  outbound('out'),

  /// Bidirectional edge
  both('both');

  const EdgeDirection(this.value);
  final String value;
}

/// Edge label placement
enum EdgeLabelPlacement {
  start,
  center,
  end,
}

/// Edge label style properties
class EdgeLabelStyle extends LabelStyle {
  EdgeLabelStyle({
    this.placement = EdgeLabelPlacement.center,
    this.placementRatio,
    this.autoRotate = true,
    super.text,
    super.fontSize,
    super.maxWidth,
    super.offsetX,
    super.offsetY,
    super.fill,
  });

  final EdgeLabelPlacement placement;
  final double? placementRatio; // 0-1 for specific position
  final bool autoRotate;
}

/// Edge badge placement
enum EdgeBadgePlacement {
  prefix,
  suffix,
}

/// Edge badge style properties
class EdgeBadgeStyle extends BadgeStyle {
  EdgeBadgeStyle({
    this.placement = EdgeBadgePlacement.prefix,
    super.text,
    super.size,
    super.offsetX,
    super.offsetY,
    super.fill,
  });

  final EdgeBadgePlacement placement;
}

/// Arrow type
enum ArrowType {
  triangle,
  circle,
  diamond,
  vee,
  rect,
  triangleRect,
  simple,
}

/// Arrow style properties
class ArrowStyle extends BaseStyle {
  ArrowStyle({
    this.type = ArrowType.triangle,
    this.size,
    super.fill,
    super.stroke,
    super.lineWidth,
  });

  final ArrowType type;
  final G6Size? size;
}

/// Loop placement
enum LoopPlacement {
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

/// Loop style properties
class LoopStyle {
  LoopStyle({
    this.placement = LoopPlacement.top,
    this.clockwise = true,
    this.dist,
  });

  final LoopPlacement placement;
  final bool clockwise;
  final double? dist;
}

/// Edge style properties
class EdgeStyle extends BaseStyle {
  EdgeStyle({
    this.color,
    this.label,
    this.labelText,
    this.badges,
    this.startArrow,
    this.endArrow,
    this.loop,
    this.controlPoints,
    this.curveOffset,
    this.curvePosition,
    super.stroke,
    super.lineWidth,
    super.opacity,
    super.lineDash,
    super.shadowColor,
    super.shadowBlur,
  });

  final Color? color;
  final EdgeLabelStyle? label;
  final String? labelText;
  final List<EdgeBadgeStyle>? badges;
  final ArrowStyle? startArrow;
  final ArrowStyle? endArrow;
  final LoopStyle? loop;
  final List<List<double>>? controlPoints;
  final double? curveOffset;
  final double? curvePosition;

  EdgeStyle copyWith({
    Color? color,
    EdgeLabelStyle? label,
    String? labelText,
    List<EdgeBadgeStyle>? badges,
    ArrowStyle? startArrow,
    ArrowStyle? endArrow,
    LoopStyle? loop,
    Color? stroke,
    double? lineWidth,
    double? opacity,
  }) {
    return EdgeStyle(
      color: color ?? this.color,
      label: label ?? this.label,
      labelText: labelText ?? this.labelText,
      badges: badges ?? this.badges,
      startArrow: startArrow ?? this.startArrow,
      endArrow: endArrow ?? this.endArrow,
      loop: loop ?? this.loop,
      stroke: stroke ?? this.stroke,
      lineWidth: lineWidth ?? this.lineWidth,
      opacity: opacity ?? this.opacity,
    );
  }
}

/// Edge data
class EdgeData {
  EdgeData({
    this.id,
    required this.source,
    required this.target,
    this.type,
    this.data,
    this.style,
    this.states,
  });

  final ElementID? id;
  final ElementID source;
  final ElementID target;
  final String? type;
  final Map<String, dynamic>? data;
  final EdgeStyle? style;
  final List<State>? states;

  /// Get effective ID (generated if not provided)
  ElementID get effectiveId => id ?? '${source}-${target}';

  EdgeData copyWith({
    ElementID? id,
    ElementID? source,
    ElementID? target,
    String? type,
    Map<String, dynamic>? data,
    EdgeStyle? style,
    List<State>? states,
  }) {
    return EdgeData(
      id: id ?? this.id,
      source: source ?? this.source,
      target: target ?? this.target,
      type: type ?? this.type,
      data: data ?? this.data,
      style: style ?? this.style,
      states: states ?? this.states,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'source': source,
      'target': target,
      if (type != null) 'type': type,
      if (data != null) 'data': data,
      if (states != null) 'states': states,
    };
  }

  /// Create from JSON
  factory EdgeData.fromJson(Map<String, dynamic> json) {
    return EdgeData(
      id: json['id'] as String?,
      source: json['source'] as String,
      target: json['target'] as String,
      type: json['type'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      states: (json['states'] as List<dynamic>?)?.cast<String>(),
    );
  }
}
