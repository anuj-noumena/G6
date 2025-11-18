import 'dart:ui';

import 'package:g6_flutter/src/types/id.dart';
import 'package:g6_flutter/src/types/point.dart';
import 'package:g6_flutter/src/types/size.dart';
import 'package:g6_flutter/src/types/state.dart';
import 'package:g6_flutter/src/types/style.dart';

/// Directional placement for labels
enum DirectionalPlacement {
  top,
  bottom,
  left,
  right,
  center,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

/// Node label style properties
class NodeLabelStyle extends LabelStyle {
  NodeLabelStyle({
    this.placement = DirectionalPlacement.bottom,
    super.text,
    super.fontSize,
    super.maxWidth,
    super.offsetX,
    super.offsetY,
    super.wordWrap,
    super.fill,
  });

  final DirectionalPlacement placement;
}

/// Node badge style properties
class NodeBadgeStyle extends BadgeStyle {
  NodeBadgeStyle({
    this.placement = DirectionalPlacement.topRight,
    super.text,
    super.size,
    super.offsetX,
    super.offsetY,
    super.fill,
  });

  final DirectionalPlacement placement;
}

/// Port style properties
class PortStyle extends BaseStyle {
  PortStyle({
    this.key,
    this.placement,
    this.r,
    this.linkToCenter = false,
    super.fill,
    super.stroke,
    super.lineWidth,
  });

  final String? key;
  final dynamic placement; // Can be DirectionalPlacement or [double, double]
  final double? r;
  final bool linkToCenter;
}

/// Node style properties
class NodeStyle extends BaseStyle {
  NodeStyle({
    this.x,
    this.y,
    this.z,
    this.size,
    this.color,
    this.label,
    this.labelText,
    this.badges,
    this.icon,
    this.ports,
    this.halo,
    this.haloOpacity,
    this.haloLineWidth,
    super.fill,
    super.stroke,
    super.lineWidth,
    super.opacity,
    super.shadowColor,
    super.shadowBlur,
    super.cursor,
  });

  final double? x;
  final double? y;
  final double? z;
  final G6Size? size;
  final Color? color;
  final NodeLabelStyle? label;
  final String? labelText;
  final List<NodeBadgeStyle>? badges;
  final IconStyle? icon;
  final List<PortStyle>? ports;
  final Color? halo;
  final double? haloOpacity;
  final double? haloLineWidth;

  /// Get position as G6Point
  G6Point get position => G6Point(x ?? 0, y ?? 0, z ?? 0);

  NodeStyle copyWith({
    double? x,
    double? y,
    double? z,
    G6Size? size,
    Color? color,
    NodeLabelStyle? label,
    String? labelText,
    List<NodeBadgeStyle>? badges,
    IconStyle? icon,
    List<PortStyle>? ports,
    Color? halo,
    double? haloOpacity,
    double? haloLineWidth,
    Color? fill,
    Color? stroke,
    double? lineWidth,
    double? opacity,
  }) {
    return NodeStyle(
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      size: size ?? this.size,
      color: color ?? this.color,
      label: label ?? this.label,
      labelText: labelText ?? this.labelText,
      badges: badges ?? this.badges,
      icon: icon ?? this.icon,
      ports: ports ?? this.ports,
      halo: halo ?? this.halo,
      haloOpacity: haloOpacity ?? this.haloOpacity,
      haloLineWidth: haloLineWidth ?? this.haloLineWidth,
      fill: fill ?? this.fill,
      stroke: stroke ?? this.stroke,
      lineWidth: lineWidth ?? this.lineWidth,
      opacity: opacity ?? this.opacity,
    );
  }
}

/// Node data
class NodeData {
  NodeData({
    required this.id,
    this.type,
    this.data,
    this.style,
    this.states,
    this.combo,
    this.children,
    this.parent,
  });

  final ElementID id;
  final String? type;
  final Map<String, dynamic>? data;
  final NodeStyle? style;
  final List<State>? states;
  final ElementID? combo;
  final List<ElementID>? children;
  final ElementID? parent;

  NodeData copyWith({
    ElementID? id,
    String? type,
    Map<String, dynamic>? data,
    NodeStyle? style,
    List<State>? states,
    ElementID? combo,
    List<ElementID>? children,
    ElementID? parent,
  }) {
    return NodeData(
      id: id ?? this.id,
      type: type ?? this.type,
      data: data ?? this.data,
      style: style ?? this.style,
      states: states ?? this.states,
      combo: combo ?? this.combo,
      children: children ?? this.children,
      parent: parent ?? this.parent,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (type != null) 'type': type,
      if (data != null) 'data': data,
      if (combo != null) 'combo': combo,
      if (children != null) 'children': children,
      if (parent != null) 'parent': parent,
      if (states != null) 'states': states,
      // Style is not included as it's complex
    };
  }

  /// Create from JSON
  factory NodeData.fromJson(Map<String, dynamic> json) {
    return NodeData(
      id: json['id'] as String,
      type: json['type'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      combo: json['combo'] as String?,
      children: (json['children'] as List<dynamic>?)?.cast<String>(),
      parent: json['parent'] as String?,
      states: (json['states'] as List<dynamic>?)?.cast<String>(),
    );
  }
}
