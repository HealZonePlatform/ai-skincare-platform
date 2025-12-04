import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/core/utils/haptics.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

/// Interactive star rating widget with animations
class StarRating extends StatefulWidget {
  const StarRating({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 24,
    this.spacing = 4,
    this.onRatingChanged,
    this.readonly = false,
    this.allowHalfRating = true,
    this.filledColor,
    this.emptyColor,
    this.showValue = false,
  });

  final double rating;
  final int maxRating;
  final double size;
  final double spacing;
  final ValueChanged<double>? onRatingChanged;
  final bool readonly;
  final bool allowHalfRating;
  final Color? filledColor;
  final Color? emptyColor;
  final bool showValue;

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  @override
  void didUpdateWidget(StarRating oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rating != widget.rating) {
      _currentRating = widget.rating;
    }
  }

  void _updateRating(double localX) {
    final starWidth = widget.size + widget.spacing;
    final newRating =
        (localX / starWidth).clamp(0.0, widget.maxRating.toDouble());

    final adjustedRating = widget.allowHalfRating
        ? (newRating * 2).round() / 2
        : newRating.round().toDouble();

    if (adjustedRating != _currentRating) {
      Haptics.selection();
      setState(() => _currentRating = adjustedRating);
      widget.onRatingChanged?.call(adjustedRating);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filledColor = widget.filledColor ?? AppColors.warning;
    final emptyColor =
        widget.emptyColor ?? AppColors.textTertiary.withValues(alpha: 0.3);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onHorizontalDragUpdate: widget.readonly
              ? null
              : (details) => _updateRating(details.localPosition.dx),
          onTapDown: widget.readonly
              ? null
              : (details) => _updateRating(details.localPosition.dx),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(widget.maxRating, (index) {
                final fillLevel = (_currentRating - index).clamp(0.0, 1.0);

              return Padding(
                padding: EdgeInsets.only(
                  right: index < widget.maxRating - 1 ? widget.spacing : 0,
                ),
                child: _AnimatedStar(
                  size: widget.size,
                  fillLevel: fillLevel,
                  filledColor: filledColor,
                  emptyColor: emptyColor,
                  interactive: !widget.readonly,
                ),
              );
            }),
          ),
        ),
        if (widget.showValue) ...[
          SizedBox(width: widget.spacing * 2),
          Text(
            _currentRating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: widget.size * 0.7,
              fontWeight: FontWeight.w700,
              color: filledColor,
            ),
          ),
        ],
      ],
    );
  }
}

class _AnimatedStar extends StatelessWidget {
  const _AnimatedStar({
    required this.size,
    required this.fillLevel,
    required this.filledColor,
    required this.emptyColor,
    required this.interactive,
  });

  final double size;
  final double fillLevel;
  final Color filledColor;
  final Color emptyColor;
  final bool interactive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Empty star background
          Icon(
            Icons.star_rounded,
            size: size,
            color: emptyColor,
          ),
          // Filled portion with clipping
          ClipRect(
            clipper: _StarClipper(fillLevel),
            child: Icon(
              Icons.star_rounded,
              size: size,
              color: filledColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _StarClipper extends CustomClipper<Rect> {
  _StarClipper(this.fillLevel);

  final double fillLevel;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * fillLevel, size.height);
  }

  @override
  bool shouldReclip(_StarClipper oldClipper) {
    return oldClipper.fillLevel != fillLevel;
  }
}

/// Compact rating display for lists
class RatingBadge extends StatelessWidget {
  const RatingBadge({
    super.key,
    required this.rating,
    this.reviewCount,
    this.size = BadgeSize.medium,
  });

  final double rating;
  final int? reviewCount;
  final BadgeSize size;

  @override
  Widget build(BuildContext context) {
    final dimensions = _badgeDimensions[size]!;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dimensions.horizontalPadding,
        vertical: dimensions.verticalPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: dimensions.iconSize,
            color: AppColors.warning,
          ),
          SizedBox(width: dimensions.spacing),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: dimensions.fontSize,
              fontWeight: FontWeight.w700,
              color: AppColors.warning,
            ),
          ),
          if (reviewCount != null) ...[
            SizedBox(width: dimensions.spacing),
            Text(
              '(${_formatCount(reviewCount!)})',
              style: TextStyle(
                fontSize: dimensions.fontSize - 1,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}

enum BadgeSize { small, medium, large }

class _BadgeDimensions {
  const _BadgeDimensions({
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.iconSize,
    required this.fontSize,
    required this.spacing,
  });

  final double horizontalPadding;
  final double verticalPadding;
  final double iconSize;
  final double fontSize;
  final double spacing;
}

const _badgeDimensions = <BadgeSize, _BadgeDimensions>{
  BadgeSize.small: _BadgeDimensions(
    horizontalPadding: 6,
    verticalPadding: 3,
    iconSize: 12,
    fontSize: 11,
    spacing: 3,
  ),
  BadgeSize.medium: _BadgeDimensions(
    horizontalPadding: 10,
    verticalPadding: 5,
    iconSize: 16,
    fontSize: 13,
    spacing: 4,
  ),
  BadgeSize.large: _BadgeDimensions(
    horizontalPadding: 14,
    verticalPadding: 7,
    iconSize: 20,
    fontSize: 15,
    spacing: 5,
  ),
};

/// Product rating summary with distribution bars
class RatingSummary extends StatelessWidget {
  const RatingSummary({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    required this.distribution,
  });

  final double averageRating;
  final int totalReviews;
  final Map<int, int> distribution; // star -> count

  @override
  Widget build(BuildContext context) {
    final maxCount = distribution.values.fold(0, (a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - overall rating
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.warning,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                StarRating(
                  rating: averageRating,
                  size: 18,
                  readonly: true,
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  '$totalReviews reviews',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.l),
          // Right side - distribution bars
          Expanded(
            child: Column(
              children: List.generate(5, (index) {
                final stars = 5 - index;
                final count = distribution[stars] ?? 0;
                final percentage = maxCount > 0 ? count / maxCount : 0.0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        '$stars',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.star_rounded,
                          size: 12, color: AppColors.warning),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          child: LinearProgressIndicator(
                            value: percentage,
                            backgroundColor: AppColors.chipBg,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.warning),
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 32,
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
