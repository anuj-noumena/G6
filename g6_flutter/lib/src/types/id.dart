/// Element ID type (can be string or number)
typedef ElementID = String;

/// Generate a unique ID
String generateID([String prefix = 'element']) {
  return '$prefix-${DateTime.now().microsecondsSinceEpoch}';
}

/// Data ID collection
class DataID {
  DataID({
    this.nodes,
    this.edges,
    this.combos,
  });

  final List<ElementID>? nodes;
  final List<ElementID>? edges;
  final List<ElementID>? combos;
}
