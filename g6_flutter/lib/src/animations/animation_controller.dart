import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';
import 'package:g6_flutter/src/runtime/graph.dart';
import 'package:g6_flutter/src/types/animation.dart';
import 'package:g6_flutter/src/types/node.dart';

/// Animation controller for graph animations
class GraphAnimationController {
  GraphAnimationController(this.graph);

  final Graph graph;
  final List<AnimationController> _controllers = [];

  /// Animate node position
  Future<void> animateNodePosition(
    String nodeId,
    Offset targetPosition, {
    AnimationConfig? config,
    required TickerProvider vsync,
  }) async {
    final animConfig = config ?? AnimationConfig();
    final controller = AnimationController(
      duration: animConfig.duration,
      vsync: vsync,
    );

    _controllers.add(controller);

    final node = graph.dataController.getNode(nodeId);
    if (node == null) return;

    final startPosition = Offset(
      node.style?.x ?? 0,
      node.style?.y ?? 0,
    );

    final animation = Tween<Offset>(
      begin: startPosition,
      end: targetPosition,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: animConfig.curve,
    ));

    animation.addListener(() {
      final value = animation.value;
      final style = node.style ?? NodeStyle();
      final updatedStyle = style.copyWith(x: value.dx, y: value.dy);
      graph.dataController.updateNode(node.copyWith(style: updatedStyle));
    });

    await controller.forward();
    controller.dispose();
    _controllers.remove(controller);
  }

  /// Animate multiple nodes
  Future<void> animateNodes(
    Map<String, Offset> nodePositions, {
    AnimationConfig? config,
    required TickerProvider vsync,
  }) async {
    await Future.wait(
      nodePositions.entries.map((entry) =>
          animateNodePosition(entry.key, entry.value, config: config, vsync: vsync)),
    );
  }

  /// Stop all animations
  void stopAll() {
    for (final controller in _controllers) {
      controller.stop();
      controller.dispose();
    }
    _controllers.clear();
  }

  /// Dispose all controllers
  void dispose() {
    stopAll();
  }
}
