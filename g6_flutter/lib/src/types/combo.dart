import 'dart:ui';

import 'package:g6_flutter/src/types/id.dart';
import 'package:g6_flutter/src/types/node.dart';
import 'package:g6_flutter/src/types/size.dart';
import 'package:g6_flutter/src/types/state.dart';
import 'package:g6_flutter/src/types/style.dart';

/// Combo style properties (similar to node style)
class ComboStyle extends BaseStyle {
  ComboStyle({
    this.x,
    this.y,
    this.z,
    this.size,
    this.color,
    this.label,
    this.labelText,
    this.badges,
    this.collapsed,
    this.padding,
    super.fill,
    super.stroke,
    super.lineWidth,
    super.opacity,
  });

  final double? x;
  final double? y;
  final double? z;
  final G6Size? size;
  final Color? color;
  final NodeLabelStyle? label;
  final String? labelText;
  final List<NodeBadgeStyle>? badges;
  final bool? collapsed;
  final double? padding;

  ComboStyle copyWith({
    double? x,
    double? y,
    double? z,
    G6Size? size,
    Color? color,
    NodeLabelStyle? label,
    String? labelText,
    List<NodeBadgeStyle>? badges,
    bool? collapsed,
    double? padding,
    Color? fill,
    Color? stroke,
    double? lineWidth,
    double? opacity,
  }) {
    return ComboStyle(
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      size: size ?? this.size,
      color: color ?? this.color,
      label: label ?? this.label,
      labelText: labelText ?? this.labelText,
      badges: badges ?? this.badges,
      collapsed: collapsed ?? this.collapsed,
      padding: padding ?? this.padding,
      fill: fill ?? this.fill,
      stroke: stroke ?? this.stroke,
      lineWidth: lineWidth ?? this.lineWidth,
      opacity: opacity ?? this.opacity,
    );
  }
}

/// Combo data (group of nodes)
class ComboData {
  ComboData({
    required this.id,
    this.type,
    this.data,
    this.style,
    this.states,
    this.combo,
    this.children,
  });

  final ElementID id;
  final String? type;
  final Map<String, dynamic>? data;
  final ComboStyle? style;
  final List<State>? states;
  final ElementID? combo; // Parent combo
  final List<ElementID>? children; // Child nodes/combos

  ComboData copyWith({
    ElementID? id,
    String? type,
    Map<String, dynamic>? data,
    ComboStyle? style,
    List<State>? states,
    ElementID? combo,
    List<ElementID>? children,
  }) {
    return ComboData(
      id: id ?? this.id,
      type: type ?? this.type,
      data: data ?? this.data,
      style: style ?? this.style,
      states: states ?? this.states,
      combo: combo ?? this.combo,
      children: children ?? this.children,
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
      if (states != null) 'states': states,
    };
  }

  /// Create from JSON
  factory ComboData.fromJson(Map<String, dynamic> json) {
    return ComboData(
      id: json['id'] as String,
      type: json['type'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      combo: json['combo'] as String?,
      children: (json['children'] as List<dynamic>?)?.cast<String>(),
      states: (json['states'] as List<dynamic>?)?.cast<String>(),
    );
  }
}
