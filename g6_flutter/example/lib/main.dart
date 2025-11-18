import 'package:flutter/material.dart';
import 'package:g6_flutter/g6_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'G6 Flutter Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const GraphExamplePage(),
    );
  }
}

class GraphExamplePage extends StatefulWidget {
  const GraphExamplePage({super.key});

  @override
  State<GraphExamplePage> createState() => _GraphExamplePageState();
}

class _GraphExamplePageState extends State<GraphExamplePage> {
  late GraphData _graphData;

  @override
  void initState() {
    super.initState();
    _graphData = _createSampleGraphData();
  }

  GraphData _createSampleGraphData() {
    return GraphData(
      nodes: [
        NodeData(
          id: '1',
          style: NodeStyle(
            x: 100,
            y: 100,
            size: const G6Size(50, 50),
            fill: Colors.blue,
            stroke: Colors.blueAccent,
            lineWidth: 2,
            labelText: 'Node 1',
          ),
        ),
        NodeData(
          id: '2',
          style: NodeStyle(
            x: 300,
            y: 100,
            size: const G6Size(50, 50),
            fill: Colors.green,
            stroke: Colors.greenAccent,
            lineWidth: 2,
            labelText: 'Node 2',
          ),
        ),
        NodeData(
          id: '3',
          style: NodeStyle(
            x: 200,
            y: 250,
            size: const G6Size(50, 50),
            fill: Colors.orange,
            stroke: Colors.orangeAccent,
            lineWidth: 2,
            labelText: 'Node 3',
          ),
        ),
        NodeData(
          id: '4',
          style: NodeStyle(
            x: 400,
            y: 250,
            size: const G6Size(50, 50),
            fill: Colors.purple,
            stroke: Colors.purpleAccent,
            lineWidth: 2,
            labelText: 'Node 4',
          ),
        ),
        NodeData(
          id: '5',
          style: NodeStyle(
            x: 300,
            y: 400,
            size: const G6Size(50, 50),
            fill: Colors.red,
            stroke: Colors.redAccent,
            lineWidth: 2,
            labelText: 'Node 5',
          ),
        ),
      ],
      edges: [
        EdgeData(
          source: '1',
          target: '2',
          style: EdgeStyle(
            stroke: Colors.grey,
            lineWidth: 2,
          ),
        ),
        EdgeData(
          source: '1',
          target: '3',
          style: EdgeStyle(
            stroke: Colors.grey,
            lineWidth: 2,
          ),
        ),
        EdgeData(
          source: '2',
          target: '4',
          style: EdgeStyle(
            stroke: Colors.grey,
            lineWidth: 2,
            labelText: 'Edge 2-4',
          ),
        ),
        EdgeData(
          source: '3',
          target: '5',
          style: EdgeStyle(
            stroke: Colors.grey,
            lineWidth: 2,
          ),
        ),
        EdgeData(
          source: '4',
          target: '5',
          style: EdgeStyle(
            stroke: Colors.grey,
            lineWidth: 2,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('G6 Flutter Example'),
        elevation: 2,
      ),
      body: Column(
        children: [
          // Info banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: const Text(
              'Pan and zoom the graph with touch gestures. Tap on elements to interact.',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          // Graph visualization
          Expanded(
            child: Container(
              color: Colors.white,
              child: G6Graph(
                data: _graphData,
                config: GraphConfig(
                  theme: ThemeConfig.light(),
                ),
              ),
            ),
          ),
          // Control panel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _addNode,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Node'),
                ),
                ElevatedButton.icon(
                  onPressed: _removeNode,
                  icon: const Icon(Icons.remove),
                  label: const Text('Remove Node'),
                ),
                ElevatedButton.icon(
                  onPressed: _randomLayout,
                  icon: const Icon(Icons.shuffle),
                  label: const Text('Random'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addNode() {
    setState(() {
      final nodeCount = _graphData.nodes?.length ?? 0;
      final newNode = NodeData(
        id: '${nodeCount + 1}',
        style: NodeStyle(
          x: 200 + (nodeCount * 50).toDouble(),
          y: 200 + (nodeCount * 30).toDouble(),
          size: const G6Size(50, 50),
          fill: Colors.primaries[nodeCount % Colors.primaries.length],
          stroke: Colors.primaries[nodeCount % Colors.primaries.length].shade700,
          lineWidth: 2,
          labelText: 'Node ${nodeCount + 1}',
        ),
      );

      final nodes = List<NodeData>.from(_graphData.nodes ?? [])..add(newNode);

      // Add edge from last node to new node
      final edges = List<EdgeData>.from(_graphData.edges ?? []);
      if (nodeCount > 0) {
        edges.add(EdgeData(
          source: '$nodeCount',
          target: '${nodeCount + 1}',
          style: EdgeStyle(
            stroke: Colors.grey,
            lineWidth: 2,
          ),
        ));
      }

      _graphData = GraphData(nodes: nodes, edges: edges);
    });
  }

  void _removeNode() {
    setState(() {
      final nodes = List<NodeData>.from(_graphData.nodes ?? []);
      if (nodes.isNotEmpty) {
        final removedNode = nodes.removeLast();

        // Remove related edges
        final edges = List<EdgeData>.from(_graphData.edges ?? [])
          ..removeWhere((edge) =>
              edge.source == removedNode.id || edge.target == removedNode.id);

        _graphData = GraphData(nodes: nodes, edges: edges);
      }
    });
  }

  void _randomLayout() {
    setState(() {
      final nodes = _graphData.nodes?.map((node) {
        return node.copyWith(
          style: node.style?.copyWith(
            x: 100 + (400 * (node.id.hashCode % 100) / 100),
            y: 100 + (400 * ((node.id.hashCode * 13) % 100) / 100),
          ),
        );
      }).toList();

      _graphData = GraphData(
        nodes: nodes,
        edges: _graphData.edges,
      );
    });
  }
}
