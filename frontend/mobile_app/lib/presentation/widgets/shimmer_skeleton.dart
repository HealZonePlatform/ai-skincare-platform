import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';

/// A shimmer skeleton widget for loading states.
/// Provides smooth shimmer animation with customizable shape and size.
class ShimmerSkeleton extends StatefulWidget {
  const ShimmerSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.baseColor,
    this.highlightColor,
  });

  /// Creates a circular shimmer skeleton
  const ShimmerSkeleton.circle({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = null,
        shape = BoxShape.circle,
        baseColor = null,
        highlightColor = null;

  /// Creates a rectangular shimmer skeleton
  const ShimmerSkeleton.rectangle({
    super.key,
    this.width,
    this.height = 16,
    double radius = 4,
  })  : borderRadius = radius,
        shape = BoxShape.rectangle,
        baseColor = null,
        highlightColor = null;

  final double? width;
  final double height;
  final double? borderRadius;
  final BoxShape shape;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  State<ShimmerSkeleton> createState() => _ShimmerSkeletonState();
}

class _ShimmerSkeletonState extends State<ShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.baseColor ?? Colors.grey.shade200;
    final highlight = widget.highlightColor ?? Colors.grey.shade50;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.shape,
            borderRadius: widget.shape == BoxShape.rectangle
                ? BorderRadius.circular(widget.borderRadius ?? AppRadius.s)
                : null,
            gradient: LinearGradient(
              colors: [base, highlight, base],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(_animation.value, 0),
              end: Alignment(_animation.value + 1, 0),
            ),
          ),
        );
      },
    );
  }
}

/// A pre-built skeleton layout for cards
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerSkeleton.circle(size: 48),
              SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerSkeleton.rectangle(width: 120, height: 14),
                    SizedBox(height: AppSpacing.s),
                    ShimmerSkeleton.rectangle(width: 80, height: 10),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.m),
          ShimmerSkeleton.rectangle(height: 12),
          SizedBox(height: AppSpacing.s),
          ShimmerSkeleton.rectangle(height: 12, width: 200),
        ],
      ),
    );
  }
}

/// A pre-built skeleton layout for list items
class SkeletonListItem extends StatelessWidget {
  const SkeletonListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: Row(
        children: [
          const ShimmerSkeleton.circle(size: 40),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerSkeleton.rectangle(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 14,
                ),
                const SizedBox(height: AppSpacing.xs),
                const ShimmerSkeleton.rectangle(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A skeleton layout for product grid items
class SkeletonProductCard extends StatelessWidget {
  const SkeletonProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerSkeleton(
            height: 140,
            borderRadius: AppRadius.l,
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerSkeleton.rectangle(height: 14),
                SizedBox(height: AppSpacing.s),
                ShimmerSkeleton.rectangle(height: 10, width: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
