import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/core/utils/haptics.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

/// Educational skincare tip card
class SkincareTipCard extends StatelessWidget {
  const SkincareTipCard({
    super.key,
    required this.tip,
    this.onTap,
    this.onBookmark,
    this.onShare,
    this.compact = false,
  });

  final SkincareTip tip;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final categoryData = _categoryData[tip.category]!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(compact ? AppSpacing.m : AppSpacing.l),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              categoryData.color.withValues(alpha: 0.1),
              categoryData.color.withValues(alpha: 0.03),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: categoryData.color.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: categoryData.color.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                // Category icon
                Container(
                  width: compact ? 36 : 44,
                  height: compact ? 36 : 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        categoryData.color,
                        categoryData.color.withValues(alpha: 0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: categoryData.color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    categoryData.icon,
                    size: compact ? 18 : 22,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: categoryData.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          categoryData.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: categoryData.color,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tip.title,
                        style: TextStyle(
                          fontSize: compact ? 14 : 16,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: compact ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Bookmark
                if (!compact)
                  IconButton(
                    onPressed: () {
                      Haptics.light();
                      onBookmark?.call();
                    },
                    icon: Icon(
                      tip.isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: tip.isBookmarked
                          ? categoryData.color
                          : AppColors.textTertiary,
                    ),
                  ),
              ],
            ),
            // Content
            if (!compact) ...[
              const SizedBox(height: AppSpacing.m),
              Text(
                tip.content,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            // Tags
            if (tip.tags.isNotEmpty && !compact) ...[
              const SizedBox(height: AppSpacing.m),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: tip.tags.take(3).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.chipBg,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      '#$tag',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            // Read time and share
            if (!compact) ...[
              const SizedBox(height: AppSpacing.m),
              Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${tip.readMins} min read',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.share_outlined, size: 16),
                    label: const Text('Share'),
                    style: TextButton.styleFrom(
                      foregroundColor: categoryData.color,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Skincare tip data
class SkincareTip {
  const SkincareTip({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.tags = const [],
    this.readMins = 2,
    this.isBookmarked = false,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String content;
  final TipCategory category;
  final List<String> tags;
  final int readMins;
  final bool isBookmarked;
  final String? imageUrl;
}

enum TipCategory {
  routine,
  ingredients,
  skinType,
  lifestyle,
  myths,
  seasonal,
}

class _CategoryData {
  const _CategoryData({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

const _categoryData = <TipCategory, _CategoryData>{
  TipCategory.routine: _CategoryData(
    label: 'Routine',
    icon: Icons.schedule_rounded,
    color: Color(0xFF8B5CF6),
  ),
  TipCategory.ingredients: _CategoryData(
    label: 'Ingredients',
    icon: Icons.science_outlined,
    color: Color(0xFF10B981),
  ),
  TipCategory.skinType: _CategoryData(
    label: 'Skin Type',
    icon: Icons.face_outlined,
    color: Color(0xFF3B82F6),
  ),
  TipCategory.lifestyle: _CategoryData(
    label: 'Lifestyle',
    icon: Icons.spa_outlined,
    color: Color(0xFFF59E0B),
  ),
  TipCategory.myths: _CategoryData(
    label: 'Myth Busters',
    icon: Icons.psychology_outlined,
    color: Color(0xFFEF4444),
  ),
  TipCategory.seasonal: _CategoryData(
    label: 'Seasonal',
    icon: Icons.wb_sunny_outlined,
    color: Color(0xFFEC4899),
  ),
};

/// Daily tip of the day widget
class DailyTipWidget extends StatelessWidget {
  const DailyTipWidget({
    super.key,
    required this.tip,
    this.onTap,
    this.onDismiss,
  });

  final SkincareTip tip;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final categoryData = _categoryData[tip.category]!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.m),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Sun decoration
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                Icons.wb_sunny_rounded,
                size: 100,
                color: const Color(0xFFFBBF24).withValues(alpha: 0.3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lightbulb_rounded,
                                size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Tip of the Day',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (onDismiss != null)
                        GestureDetector(
                          onTap: onDismiss,
                          child: const Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: Color(0xFF92400E),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    tip.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF78350F),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tip.content,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF92400E),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: categoryData.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(categoryData.icon,
                                size: 12, color: categoryData.color),
                            const SizedBox(width: 4),
                            Text(
                              categoryData.label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: categoryData.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Read more →',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFB45309),
                        ),
                      ),
                    ],
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

/// Ingredient education spotlight
class IngredientSpotlight extends StatelessWidget {
  const IngredientSpotlight({
    super.key,
    required this.ingredient,
    this.onTap,
    this.onLearnMore,
  });

  final IngredientInfo ingredient;
  final VoidCallback? onTap;
  final VoidCallback? onLearnMore;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ingredient.color.withValues(alpha: 0.12),
              ingredient.color.withValues(alpha: 0.04),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: ingredient.color.withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Emoji
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: ingredient.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.l),
                  ),
                  child: Center(
                    child: Text(
                      ingredient.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ingredient.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        ingredient.scientificName ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              ingredient.description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.m),
            // Benefits
            const Text(
              'Benefits',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ingredient.benefits.map((benefit) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ingredient.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: ingredient.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        benefit,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: ingredient.color,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.l),
            // Best for
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Best for',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ingredient.bestFor.join(', '),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onLearnMore,
                  child: const Text('Learn more'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class IngredientInfo {
  const IngredientInfo({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    required this.description,
    required this.benefits,
    this.scientificName,
    this.bestFor = const [],
  });

  final String id;
  final String name;
  final String emoji;
  final Color color;
  final String description;
  final List<String> benefits;
  final String? scientificName;
  final List<String> bestFor;
}
