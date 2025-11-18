## 0.1.0 - Initial Release

### Features

- **Core Graph System**: Complete graph data model with nodes, edges, and combos
- **Data Management**: Full CRUD operations for graph elements
- **Viewport Control**: Pan, zoom, and fit-view functionality
- **Event System**: Comprehensive event handling for user interactions
- **Type System**: Complete Dart type definitions for all G6 concepts
- **Flutter Widget**: Native Flutter widget (G6Graph) for graph visualization
- **Custom Painter**: Efficient rendering using Flutter's CustomPaint
- **Interactive Example**: Full-featured example app demonstrating library capabilities

### Components Implemented

#### Type System (15 files)
- GraphData, NodeData, EdgeData, ComboData
- Style configurations (NodeStyle, EdgeStyle, ComboStyle)
- Animation, Layout, Behavior, Plugin configurations
- Theme and Palette support
- Complete event types

#### Runtime System
- Graph class - main API entry point
- DataController - manages graph data
- ElementController - manages element lifecycle
- ViewportController - handles pan/zoom/rotation

#### Rendering
- GraphPainter - custom painter for graph visualization
- G6Graph widget - main Flutter widget
- Basic node rendering (circles)
- Basic edge rendering (lines)
- Label rendering for nodes and edges

#### Utilities
- Math utilities (distance, angle, rotation, interpolation)
- Color utilities (hex parsing, lighten/darken, mixing)
- ID generation

### Known Limitations

This is an initial release with core functionality. The following features from the original G6 library are planned for future releases:

- Advanced node types (rectangle, ellipse, diamond, etc.)
- Advanced edge types (polyline, cubic, quadratic)
- Layout algorithms (force, dagre, circular, etc.)
- Behaviors (drag-node, brush-select, etc.)
- Plugins (minimap, toolbar, tooltip, etc.)
- Animations
- Transform pipeline
- 3D support
- React-style custom nodes

### Breaking Changes

N/A - Initial release

### Migration Guide

N/A - Initial release
