import 'package:g6_flutter/src/runtime/graph.dart';
import 'package:g6_flutter/src/types/data.dart';

/// History plugin - provides undo/redo functionality
class HistoryPlugin {
  HistoryPlugin(this.graph, {this.maxStep = 50});

  final Graph graph;
  final int maxStep;

  final List<GraphData> _history = [];
  int _currentIndex = -1;

  /// Add current state to history
  void push() {
    // Remove any history after current index
    if (_currentIndex < _history.length - 1) {
      _history.removeRange(_currentIndex + 1, _history.length);
    }

    // Add current state
    final currentData = graph.getData();
    _history.add(GraphData(
      nodes: currentData.nodes?.map((n) => n).toList(),
      edges: currentData.edges?.map((e) => e).toList(),
      combos: currentData.combos?.map((c) => c).toList(),
    ));

    _currentIndex++;

    // Limit history size
    if (_history.length > maxStep) {
      _history.removeAt(0);
      _currentIndex--;
    }
  }

  /// Undo to previous state
  bool undo() {
    if (!canUndo) return false;

    _currentIndex--;
    graph.setData(_history[_currentIndex]);
    return true;
  }

  /// Redo to next state
  bool redo() {
    if (!canRedo) return false;

    _currentIndex++;
    graph.setData(_history[_currentIndex]);
    return true;
  }

  /// Check if can undo
  bool get canUndo => _currentIndex > 0;

  /// Check if can redo
  bool get canRedo => _currentIndex < _history.length - 1;

  /// Clear history
  void clear() {
    _history.clear();
    _currentIndex = -1;
  }
}
