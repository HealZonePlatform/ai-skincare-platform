import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/core/utils/haptics.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'package:ai_skincare_platform/presentation/widgets/optimized_network_image.dart';

/// A community post card with rich skincare-focused features
class CommunityPostCard extends StatelessWidget {
  const CommunityPostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onBookmark,
    this.onAuthorTap,
  });

  final CommunityPost post;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onBookmark;
  final VoidCallback? onAuthorTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author header
          _AuthorHeader(
            author: post.author,
            postedAt: post.createdAt,
            postType: post.type,
            onTap: onAuthorTap,
          ),
          // Content
          if (post.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: Text(
                post.content,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          // Tags
          if (post.skinConcerns.isNotEmpty || post.ingredients.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.l, AppSpacing.m, AppSpacing.l, 0),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  ...post.skinConcerns.map(
                    (concern) => _Tag(label: concern, color: AppColors.primary),
                  ),
                  ...post.ingredients.map(
                    (ingredient) =>
                        _Tag(label: ingredient, color: const Color(0xFF6BCB77)),
                  ),
                ],
              ),
            ),
          // Media content
          if (post.type == PostType.beforeAfter && post.images.length >= 2)
            _BeforeAfterMedia(
              beforeImage: post.images[0],
              afterImage: post.images[1],
              duration: post.progressDuration,
            )
          else if (post.images.isNotEmpty)
            _ImageGallery(images: post.images),
          // Product reference
          if (post.product != null)
            _ProductReference(product: post.product!),
          // Routine reference
          if (post.routineSteps != null && post.routineSteps!.isNotEmpty)
            _RoutinePreview(steps: post.routineSteps!),
          // Actions
          _PostActions(
            likes: post.likes,
            comments: post.comments,
            isLiked: post.isLiked,
            isBookmarked: post.isBookmarked,
            onLike: onLike,
            onComment: onComment,
            onShare: onShare,
            onBookmark: onBookmark,
          ),
        ],
      ),
    );
  }
}

/// Post data model
class CommunityPost {
  const CommunityPost({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
    this.type = PostType.text,
    this.images = const [],
    this.skinConcerns = const [],
    this.ingredients = const [],
    this.product,
    this.routineSteps,
    this.progressDuration,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
    this.isBookmarked = false,
  });

  final String id;
  final PostAuthor author;
  final String content;
  final DateTime createdAt;
  final PostType type;
  final List<String> images;
  final List<String> skinConcerns;
  final List<String> ingredients;
  final ProductReference? product;
  final List<String>? routineSteps;
  final String? progressDuration;
  final int likes;
  final int comments;
  final bool isLiked;
  final bool isBookmarked;
}

class PostAuthor {
  const PostAuthor({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.skinType,
    this.isVerified = false,
  });

  final String id;
  final String name;
  final String? avatarUrl;
  final String? skinType;
  final bool isVerified;
}

class ProductReference {
  const ProductReference({
    required this.id,
    required this.name,
    this.brand,
    this.imageUrl,
    this.rating,
  });

  final String id;
  final String name;
  final String? brand;
  final String? imageUrl;
  final double? rating;
}

enum PostType { text, image, beforeAfter, routine, review }

class _AuthorHeader extends StatelessWidget {
  const _AuthorHeader({
    required this.author,
    required this.postedAt,
    required this.postType,
    this.onTap,
  });

  final PostAuthor author;
  final DateTime postedAt;
  final PostType postType;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF7EC8E3)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: CircleAvatar(
                  backgroundImage: author.avatarUrl != null
                      ? NetworkImage(author.avatarUrl!)
                      : null,
                  backgroundColor: AppColors.surface,
                  child: author.avatarUrl == null
                      ? Text(
                          author.name[0].toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        author.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      if (author.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (author.skinType != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.chipBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            author.skinType!,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        _timeAgo(postedAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Post type badge
            _PostTypeBadge(type: postType),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}

class _PostTypeBadge extends StatelessWidget {
  const _PostTypeBadge({required this.type});

  final PostType type;

  @override
  Widget build(BuildContext context) {
    final data = _typeData[type]!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(data.icon, size: 14, color: data.color),
          const SizedBox(width: 4),
          Text(
            data.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: data.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeData {
  const _TypeData({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

const _typeData = {
  PostType.text: _TypeData(
    label: 'Post',
    icon: Icons.article_outlined,
    color: Color(0xFF64748B),
  ),
  PostType.image: _TypeData(
    label: 'Photo',
    icon: Icons.photo_outlined,
    color: Color(0xFF3B82F6),
  ),
  PostType.beforeAfter: _TypeData(
    label: 'Progress',
    icon: Icons.compare_rounded,
    color: Color(0xFF10B981),
  ),
  PostType.routine: _TypeData(
    label: 'Routine',
    icon: Icons.spa_outlined,
    color: Color(0xFF8B5CF6),
  ),
  PostType.review: _TypeData(
    label: 'Review',
    icon: Icons.rate_review_outlined,
    color: Color(0xFFF59E0B),
  ),
};

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        '#$label',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _BeforeAfterMedia extends StatelessWidget {
  const _BeforeAfterMedia({
    required this.beforeImage,
    required this.afterImage,
    this.duration,
  });

  final String beforeImage;
  final String afterImage;
  final String? duration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.l, AppSpacing.m, AppSpacing.l, 0),
      child: Column(
        children: [
          // Duration badge
          if (duration != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF10B981),
                      const Color(0xFF10B981).withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.trending_up_rounded,
                        size: 16, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      duration!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Images
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.l),
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 0.8,
                        child: OptimizedNetworkImage(
                          imageUrl: beforeImage,
                          borderRadius: 0,
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Before',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 0.8,
                        child: OptimizedNetworkImage(
                          imageUrl: afterImage,
                          borderRadius: 0,
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'After',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  const _ImageGallery({required this.images});

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.l, AppSpacing.m, AppSpacing.l, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.l),
        child: images.length == 1
            ? AspectRatio(
                aspectRatio: 4 / 3,
                child: OptimizedNetworkImage(
                  imageUrl: images[0],
                  borderRadius: 0,
                ),
              )
            : SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return AspectRatio(
                      aspectRatio: 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.m),
                        child: OptimizedNetworkImage(
                          imageUrl: images[index],
                          borderRadius: 0,
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

class _ProductReference extends StatelessWidget {
  const _ProductReference({required this.product});

  final ProductReference product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.l, AppSpacing.m, AppSpacing.l, 0),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.m),
        decoration: BoxDecoration(
          color: AppColors.chipBg,
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        child: Row(
          children: [
            if (product.imageUrl != null)
              Container(
                width: 48,
                height: 48,
                margin: const EdgeInsets.only(right: AppSpacing.m),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: OptimizedNetworkImage(
                    imageUrl: product.imageUrl!,
                    borderRadius: 0,
                  ),
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.brand != null)
                    Text(
                      product.brand!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (product.rating != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 14, color: AppColors.warning),
                    const SizedBox(width: 2),
                    Text(
                      product.rating!.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RoutinePreview extends StatelessWidget {
  const _RoutinePreview({required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    final displaySteps = steps.take(3).toList();
    final hasMore = steps.length > 3;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.l, AppSpacing.m, AppSpacing.l, 0),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.m),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF8B5CF6).withValues(alpha: 0.08),
              const Color(0xFF8B5CF6).withValues(alpha: 0.03),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.m),
          border: Border.all(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.spa_outlined,
                    size: 16, color: Color(0xFF8B5CF6)),
                const SizedBox(width: 6),
                Text(
                  '${steps.length}-Step Routine',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            ...displaySteps.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.value,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              );
            }),
            if (hasMore)
              Text(
                '+${steps.length - 3} more steps',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PostActions extends StatelessWidget {
  const _PostActions({
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.isBookmarked,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onBookmark,
  });

  final int likes;
  final int comments;
  final bool isLiked;
  final bool isBookmarked;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onBookmark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.m),
      child: Row(
        children: [
          _ActionButton(
            icon: isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            label: _formatCount(likes),
            isActive: isLiked,
            activeColor: const Color(0xFFEF4444),
            onTap: () {
              Haptics.light();
              onLike?.call();
            },
          ),
          const SizedBox(width: AppSpacing.l),
          _ActionButton(
            icon: Icons.chat_bubble_outline_rounded,
            label: _formatCount(comments),
            onTap: onComment,
          ),
          const Spacer(),
          _ActionButton(
            icon: Icons.share_outlined,
            onTap: onShare,
          ),
          const SizedBox(width: AppSpacing.m),
          _ActionButton(
            icon: isBookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            isActive: isBookmarked,
            activeColor: AppColors.primary,
            onTap: () {
              Haptics.light();
              onBookmark?.call();
            },
          ),
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    this.label,
    this.isActive = false,
    this.activeColor,
    this.onTap,
  });

  final IconData icon;
  final String? label;
  final bool isActive;
  final Color? activeColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? (activeColor ?? AppColors.primary)
        : AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 22, color: color),
          if (label != null) ...[
            const SizedBox(width: 4),
            Text(
              label!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
