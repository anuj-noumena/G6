/// Graph event constants
class Events {
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
  static const String nodePointerDown = 'node:pointerdown';
  static const String nodePointerUp = 'node:pointerup';

  // Edge events
  static const String edgeClick = 'edge:click';
  static const String edgeDblClick = 'edge:dblclick';
  static const String edgePointerEnter = 'edge:pointerenter';
  static const String edgePointerMove = 'edge:pointermove';
  static const String edgePointerLeave = 'edge:pointerleave';
  static const String edgePointerDown = 'edge:pointerdown';
  static const String edgePointerUp = 'edge:pointerup';

  // Combo events
  static const String comboClick = 'combo:click';
  static const String comboDblClick = 'combo:dblclick';
  static const String comboDragStart = 'combo:dragstart';
  static const String comboDrag = 'combo:drag';
  static const String comboDragEnd = 'combo:dragend';
  static const String comboPointerEnter = 'combo:pointerenter';
  static const String comboPointerMove = 'combo:pointermove';
  static const String comboPointerLeave = 'combo:pointerleave';

  // Graph lifecycle events
  static const String afterRender = 'afterrender';
  static const String beforeRender = 'beforerender';
  static const String afterLayout = 'afterlayout';
  static const String beforeLayout = 'beforelayout';
  static const String afterElementCreate = 'afterelementcreate';
  static const String afterElementUpdate = 'afterelementupdate';
  static const String afterElementRemove = 'afterelementremove';

  // History events
  static const String historyChange = 'history:change';
  static const String historyUndo = 'history:undo';
  static const String historyRedo = 'history:redo';
}
