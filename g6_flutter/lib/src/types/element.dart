import 'package:g6_flutter/src/types/id.dart';
import 'package:g6_flutter/src/types/state.dart';

/// Element type enumeration
enum ElementType {
  node,
  edge,
  combo,
}

/// Base element interface
abstract class Element {
  ElementID get id;
  ElementType get type;
  Map<String, dynamic>? get data;
  List<State>? get states;

  /// Check if element has a specific state
  bool hasState(State state) {
    return states?.contains(state) ?? false;
  }

  /// Add a state to element
  void addState(State state);

  /// Remove a state from element
  void removeState(State state);

  /// Clear all states
  void clearStates();

  /// Update element data
  void update(Map<String, dynamic> data);

  /// Destroy element
  void destroy();
}
