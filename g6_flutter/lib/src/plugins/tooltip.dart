import 'package:flutter/material.dart';

/// Tooltip plugin - shows information about elements on hover
class TooltipPlugin extends StatelessWidget {
  const TooltipPlugin({
    super.key,
    required this.content,
    required this.position,
    this.visible = true,
  });

  final String content;
  final Offset position;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible || content.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: position.dx + 10,
      top: position.dy + 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          content,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
