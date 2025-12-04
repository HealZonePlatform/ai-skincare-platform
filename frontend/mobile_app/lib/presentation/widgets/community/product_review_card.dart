import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/core/utils/haptics.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'package:ai_skincare_platform/presentation/widgets/star_rating.dart';

/// Product review card for community section
class ProductReviewCard extends StatelessWidget {
  const ProductReviewCard({
    super.key,
    required this.review,
    this.onTap,
    this.onHelpful,
    this.onAuthorTap,
    this.compact = false,
  });

  final ProductReview review;
  final VoidCallback? onTap;
  final VoidCallback? onHelpful;
  final VoidCallback? onAuthorTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.l),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                // Avatar
                GestureDetector(
                  onTap: onAuthorTap,
                  child: CircleAvatar(
                    radius: compact ? 16 : 20,
                    backgroundImage: review.authorAvatar != null
                        ? NetworkImage(review.authorAvatar!)
                        : null,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    child: review.authorAvatar == null
                        ? Text(
                            review.authorName[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: compact ? 12 : 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          )
                        : null,
                  ),
                ),
                SizedBox(width: compact ? AppSpacing.s : AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            review.authorName,
                            style: TextStyle(
                              fontSize: compact ? 12 : 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (review.isVerifiedPurchase) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified_rounded,
                                    size: 10,
                                    color: AppColors.success,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    'Verified',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          StarRating(
                            rating: review.rating,
                            size: compact ? 12 : 14,
                            readonly: true,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _timeAgo(review.createdAt),
                            style: TextStyle(
                              fontSize: compact ? 10 : 11,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Skin profile
            if (review.skinType != null || review.skinConcerns.isNotEmpty) ...[
              SizedBox(height: compact ? AppSpacing.s : AppSpacing.m),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  if (review.skinType != null)
                    _ProfileChip(
                      icon: Icons.face_outlined,
                      label: review.skinType!,
                    ),
                  ...review.skinConcerns.take(2).map(
                        (concern) => _ProfileChip(
                          icon: Icons.healing_outlined,
                          label: concern,
                        ),
                      ),
                ],
              ),
            ],
            // Review content
            SizedBox(height: compact ? AppSpacing.s : AppSpacing.m),
            Text(
              review.content,
              style: TextStyle(
                fontSize: compact ? 13 : 14,
                height: 1.5,
                color: AppColors.textPrimary,
              ),
              maxLines: compact ? 3 : null,
              overflow: compact ? TextOverflow.ellipsis : null,
            ),
            // Pros and cons
            if (!compact && (review.pros.isNotEmpty || review.cons.isNotEmpty)) ...[
              const SizedBox(height: AppSpacing.m),
              if (review.pros.isNotEmpty) _ProsCons(items: review.pros, isPros: true),
              if (review.cons.isNotEmpty) ...[
                const SizedBox(height: 8),
                _ProsCons(items: review.cons, isPros: false),
              ],
            ],
            // Images
            if (review.images.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.m),
              SizedBox(
                height: compact ? 60 : 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: review.images.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        review.images[index],
                        height: compact ? 60 : 80,
                        width: compact ? 60 : 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: compact ? 60 : 80,
                          width: compact ? 60 : 80,
                          color: AppColors.chipBg,
                          child: const Icon(Icons.image_outlined,
                              color: AppColors.textTertiary),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            // Helpful button
            if (!compact) ...[
              const SizedBox(height: AppSpacing.m),
              Row(
                children: [
                  const Text(
                    'Was this helpful?',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  _HelpfulButton(
                    count: review.helpfulCount,
                    isHelpful: review.isMarkedHelpful,
                    onTap: () {
                      Haptics.light();
                      onHelpful?.call();
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 30) return '${(diff.inDays / 30).round()}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return 'Just now';
  }
}

/// Product review data
class ProductReview {
  const ProductReview({
    required this.id,
    required this.authorName,
    required this.rating,
    required this.content,
    required this.createdAt,
    this.authorAvatar,
    this.skinType,
    this.skinConcerns = const [],
    this.pros = const [],
    this.cons = const [],
    this.images = const [],
    this.helpfulCount = 0,
    this.isMarkedHelpful = false,
    this.isVerifiedPurchase = false,
  });

  final String id;
  final String authorName;
  final String? authorAvatar;
  final double rating;
  final String content;
  final DateTime createdAt;
  final String? skinType;
  final List<String> skinConcerns;
  final List<String> pros;
  final List<String> cons;
  final List<String> images;
  final int helpfulCount;
  final bool isMarkedHelpful;
  final bool isVerifiedPurchase;
}

class _ProfileChip extends StatelessWidget {
  const _ProfileChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.chipBg,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProsCons extends StatelessWidget {
  const _ProsCons({
    required this.items,
    required this.isPros,
  });

  final List<String> items;
  final bool isPros;

  @override
  Widget build(BuildContext context) {
    final color = isPros ? AppColors.success : AppColors.danger;
    final icon = isPros ? Icons.add_circle_outline : Icons.remove_circle_outline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _HelpfulButton extends StatelessWidget {
  const _HelpfulButton({
    required this.count,
    required this.isHelpful,
    this.onTap,
  });

  final int count;
  final bool isHelpful;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isHelpful
              ? AppColors.success.withValues(alpha: 0.12)
              : AppColors.chipBg,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: isHelpful
              ? Border.all(color: AppColors.success.withValues(alpha: 0.3))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isHelpful ? Icons.thumb_up_rounded : Icons.thumb_up_outlined,
              size: 14,
              color: isHelpful ? AppColors.success : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              count > 0 ? '$count' : 'Yes',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isHelpful ? AppColors.success : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Summary of reviews for a product
class ReviewSummaryHeader extends StatelessWidget {
  const ReviewSummaryHeader({
    super.key,
    required this.rating,
    required this.totalReviews,
    required this.distribution,
    this.onWriteReview,
    this.onSeeAll,
  });

  final double rating;
  final int totalReviews;
  final Map<int, int> distribution;
  final VoidCallback? onWriteReview;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Left: rating
              Column(
                children: [
                  Text(
                    rating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.warning,
                        ),
                  ),
                  StarRating(rating: rating, size: 16, readonly: true),
                  const SizedBox(height: 4),
                  Text(
                    '$totalReviews reviews',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.xl),
              // Right: distribution
              Expanded(
                child: Column(
                  children: [5, 4, 3, 2, 1].map((star) {
                    final count = distribution[star] ?? 0;
                    final percent = totalReviews > 0 ? count / totalReviews : 0.0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Text(
                            '$star',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Icon(Icons.star_rounded,
                              size: 12, color: AppColors.warning),
                          const SizedBox(width: 6),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: percent,
                                backgroundColor: AppColors.chipBg,
                                valueColor: const AlwaysStoppedAnimation(
                                    AppColors.warning),
                                minHeight: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.l),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onSeeAll,
                  child: const Text('See all'),
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onWriteReview,
                  icon: const Icon(Icons.rate_review_outlined, size: 18),
                  label: const Text('Write review'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
