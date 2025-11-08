// lib/presentation/widgets/hz_skeleton.dart

import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';

/// Lightweight shimmering skeleton used while data is loading.
class HzSkeleton extends StatefulWidget {
  const HzSkeleton.rect({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppRadius.m,
    this.margin = EdgeInsets.zero,
  }) : shape = BoxShape.rectangle;

  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsets margin;
  final BoxShape shape;

  @override
  State<HzSkeleton> createState() => _HzSkeletonState();
}

class _HzSkeletonState extends State<HzSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).colorScheme.surface.withValues(alpha: 0.45);
    final highlight = Colors.white.withValues(alpha: 0.85);

    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        borderRadius: widget.shape == BoxShape.rectangle ? BorderRadius.circular(widget.borderRadius) : null,
        shape: widget.shape,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            baseColor,
            highlight,
            baseColor,
          ],
          stops: [
            (_controller.value * 0.2).clamp(0.0, 1.0),
            (_controller.value * 0.2 + 0.4).clamp(0.0, 1.0),
            (_controller.value * 0.2 + 0.8).clamp(0.0, 1.0),
          ],
        ),
      ),
    );
  }
}
