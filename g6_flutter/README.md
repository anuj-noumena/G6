# G6 Flutter

A powerful graph visualization framework for Flutter, ported from [AntV G6](https://github.com/antvis/G6).

## Overview

G6 Flutter is a comprehensive graph visualization engine that provides rich capabilities for graph visualization and analysis including:

- **Rich Elements**: Built-in node, edge, and combo UI elements with extensive style configurations
- **Controllable Interactions**: Built-in interaction behaviors with rich events
- **High-Performance Layouts**: Common graph layouts including force-directed, hierarchical, circular, and more
- **Flexible Plugins**: Extensible plugin system for custom functionality
- **Multiple Themes**: Light and dark themes with customizable color palettes
- **Flutter-Native**: Built specifically for Flutter with native rendering performance

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  g6_flutter: ^0.1.0
```

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:g6_flutter/g6_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Prepare graph data
    final graphData = GraphData(
      nodes: [
        NodeData(id: '1', style: NodeStyle(x: 100, y: 100)),
        NodeData(id: '2', style: NodeStyle(x: 200, y: 200)),
      ],
      edges: [
        EdgeData(source: '1', target: '2'),
      ],
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('G6 Flutter Demo')),
        body: G6Graph(
          data: graphData,
          config: GraphConfig(
            node: NodeConfig(
              type: 'circle',
              style: NodeStyle(
                fill: Colors.blue,
                stroke: Colors.blueAccent,
              ),
            ),
            edge: EdgeConfig(
              type: 'line',
            ),
            layout: LayoutConfig(
              type: 'force',
            ),
            behaviors: ['drag-canvas', 'zoom-canvas', 'drag-node'],
          ),
        ),
      ),
    );
  }
}
```

## Features

### Elements

- **Nodes**: Circle, Rectangle, Ellipse, Diamond, Triangle, Hexagon, Star, Image, and more
- **Edges**: Line, Polyline, Quadratic, Cubic curves with various routing options
- **Combos**: Group nodes together with circular or rectangular containers

### Layouts

- **Force-Directed**: D3Force, Force, Fruchterman
- **Hierarchical**: Dagre, CompactBox, Dendrogram, Mindmap
- **Circular**: Circular, Radial, Concentric
- **Grid**: Grid, Snake
- **Other**: Random, MDS

### Behaviors

- **Selection**: Click-select, Brush-select, Lasso-select
- **Navigation**: Drag-canvas, Scroll-canvas, Zoom-canvas
- **Manipulation**: Drag-element, Create-edge
- **Visual**: Hover-activate, Focus-element

### Plugins

- **Minimap**: Overview navigator
- **Toolbar**: Action toolbar
- **Tooltip**: Element tooltips
- **ContextMenu**: Right-click menus
- **History**: Undo/redo support
- **And more...**

## Architecture

G6 Flutter follows a modular architecture:

```
lib/
├── src/
│   ├── runtime/          # Core graph engine and controllers
│   ├── elements/         # Nodes, edges, combos, shapes
│   ├── behaviors/        # User interaction behaviors
│   ├── plugins/          # Extensible plugins
│   ├── layouts/          # Graph layout algorithms
│   ├── transforms/       # Data transformation pipeline
│   ├── animations/       # Animation system
│   ├── types/            # Type definitions
│   ├── utils/            # Utility functions
│   ├── constants/        # Constants and enums
│   ├── registry/         # Extension registry system
│   └── themes/           # Theme definitions
└── g6_flutter.dart       # Main export file
```

## Documentation

For detailed documentation, visit [G6 Documentation](https://g6.antv.antgroup.com).

## Contributing

We welcome contributions! Please see our [Contributing Guide](../CONTRIBUTING.md).

## License

MIT License - see [LICENSE](../LICENSE) file for details.

## Credits

This is a Flutter port of the original [AntV G6](https://github.com/antvis/G6) library.
