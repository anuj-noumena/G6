import 'package:flutter/animation.dart';

/// Animation timing function
enum AnimationTiming {
  linear,
  easeIn,
  easeOut,
  easeInOut,
  bounceIn,
  bounceOut,
  elasticIn,
  elasticOut,
}

/// Animation configuration
class AnimationConfig {
  AnimationConfig({
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.timing = AnimationTiming.easeInOut,
    this.iterations = 1,
    this.direction = AnimationDirection.forward,
  });

  final Duration duration;
  final Duration delay;
  final AnimationTiming timing;
  final int iterations; // -1 for infinite
  final AnimationDirection direction;

  /// Get Flutter curve from timing
  Curve get curve {
    switch (timing) {
      case AnimationTiming.linear:
        return Curves.linear;
      case AnimationTiming.easeIn:
        return Curves.easeIn;
      case AnimationTiming.easeOut:
        return Curves.easeOut;
      case AnimationTiming.easeInOut:
        return Curves.easeInOut;
      case AnimationTiming.bounceIn:
        return Curves.bounceIn;
      case AnimationTiming.bounceOut:
        return Curves.bounceOut;
      case AnimationTiming.elasticIn:
        return Curves.elasticIn;
      case AnimationTiming.elasticOut:
        return Curves.elasticOut;
    }
  }

  AnimationConfig copyWith({
    Duration? duration,
    Duration? delay,
    AnimationTiming? timing,
    int? iterations,
    AnimationDirection? direction,
  }) {
    return AnimationConfig(
      duration: duration ?? this.duration,
      delay: delay ?? this.delay,
      timing: timing ?? this.timing,
      iterations: iterations ?? this.iterations,
      direction: direction ?? this.direction,
    );
  }
}

/// Animation direction
enum AnimationDirection {
  forward,
  reverse,
  alternate,
}

/// Animation executor function type
typedef AnimationExecutor = void Function(double progress);
