import 'package:flutter/gestures.dart';
import 'package:g6_flutter/src/types/element.dart';
import 'package:g6_flutter/src/types/id.dart';
import 'package:g6_flutter/src/types/point.dart';

/// Graph event types
class GraphEventType {
  // Canvas events
  static const String canvasClick = 'canvas:click';
  static const String canvasDblClick = 'canvas:dblclick';
  static const String canvasDragStart = 'canvas:dragstart';
  static const String canvasDrag = 'canvas:drag';
  static const String canvasDragEnd = 'canvas:dragend';
  static const String canvasPointerDown = 'canvas:pointerdown';
  static const String canvasPointerMove = 'canvas:pointermove';
  static const String canvasPointerUp = 'canvas:pointerup';

  // Node events
  static const String nodeClick = 'node:click';
  static const String nodeDblClick = 'node:dblclick';
  static const String nodeDragStart = 'node:dragstart';
  static const String nodeDrag = 'node:drag';
  static const String nodeDragEnd = 'node:dragend';
  static const String nodePointerEnter = 'node:pointerenter';
  static const String nodePointerMove = 'node:pointermove';
  static const String nodePointerLeave = 'node:pointerleave';

  // Edge events
  static const String edgeClick = 'edge:click';
  static const String edgeDblClick = 'edge:dblclick';
  static const String edgePointerEnter = 'edge:pointerenter';
  static const String edgePointerMove = 'edge:pointermove';
  static const String edgePointerLeave = 'edge:pointerleave';

  // Combo events
  static const String comboClick = 'combo:click';
  static const String comboDblClick = 'combo:dblclick';
  static const String comboDragStart = 'combo:dragstart';
  static const String comboDrag = 'combo:drag';
  static const String comboDragEnd = 'combo:dragend';

  // Graph lifecycle events
  static const String afterRender = 'afterrender';
  static const String beforeRender = 'beforerender';
  static const String afterLayout = 'afterlayout';
  static const String beforeLayout = 'beforelayout';
  static const String afterElementCreate = 'afterelementcreate';
  static const String afterElementUpdate = 'afterelementupdate';
  static const String afterElementRemove = 'afterelementremove';
}

/// Base graph event
class GraphEvent {
  GraphEvent({
    required this.type,
    this.target,
    this.targetType,
    this.position,
    this.originalEvent,
  });

  final String type;
  final Element? target;
  final ElementType? targetType;
  final G6Point? position;
  final dynamic originalEvent; // Flutter event

  /// Get element ID if target exists
  ElementID? get targetId => null; // Would need to access target.id
}

/// Node event
class NodeEvent extends GraphEvent {
  NodeEvent({
    required super.type,
    super.target,
    super.position,
    super.originalEvent,
  }) : super(targetType: ElementType.node);
}

/// Edge event
class EdgeEvent extends GraphEvent {
  EdgeEvent({
    required super.type,
    super.target,
    super.position,
    super.originalEvent,
  }) : super(targetType: ElementType.edge);
}

/// Combo event
class ComboEvent extends GraphEvent {
  ComboEvent({
    required super.type,
    super.target,
    super.position,
    super.originalEvent,
  }) : super(targetType: ElementType.combo);
}

/// Canvas event
class CanvasEvent extends GraphEvent {
  CanvasEvent({
    required super.type,
    super.position,
    super.originalEvent,
  });
}

/// Event callback function type
typedef EventCallback = void Function(GraphEvent event);
