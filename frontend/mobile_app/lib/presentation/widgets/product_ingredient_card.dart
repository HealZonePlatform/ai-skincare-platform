import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'package:ai_skincare_platform/presentation/widgets/icons/ingredient_icons.dart';

/// Detailed ingredient information card for product screens
class ProductIngredientCard extends StatelessWidget {
  const ProductIngredientCard({
    super.key,
    required this.ingredient,
    this.concentration,
    this.isFeatured = false,
    this.onTap,
  });

  final SkincareIngredient ingredient;
  final String? concentration;
  final bool isFeatured;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.m),
        decoration: BoxDecoration(
          gradient: isFeatured
              ? LinearGradient(
                  colors: [
                    ingredient.color.withValues(alpha: 0.12),
                    ingredient.color.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isFeatured ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.m),
          border: Border.all(
            color: isFeatured
                ? ingredient.color.withValues(alpha: 0.3)
                : AppColors.border,
            width: isFeatured ? 1.5 : 1,
          ),
          boxShadow: isFeatured
              ? [
                  BoxShadow(
                    color: ingredient.color.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Ingredient icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.m),
                color: ingredient.color.withValues(alpha: 0.15),
              ),
              child: Center(
                child: Text(
                  ingredient.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          ingredient.name,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: isFeatured
                                        ? ingredient.color
                                        : AppColors.textPrimary,
                                  ),
                        ),
                      ),
                      if (isFeatured)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: ingredient.color,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: const Text(
                            'KEY',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ingredient.benefit,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (concentration != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.chipBg,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        concentration!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Arrow
            Icon(
              Icons.chevron_right_rounded,
              color: isFeatured
                  ? ingredient.color.withValues(alpha: 0.6)
                  : AppColors.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// Ingredient list with featured/highlight support
class ProductIngredientList extends StatelessWidget {
  const ProductIngredientList({
    super.key,
    required this.ingredients,
    this.featuredIngredients = const [],
    this.concentrations = const {},
    this.onIngredientTap,
    this.maxVisible,
    this.onShowAll,
  });

  final List<SkincareIngredient> ingredients;
  final List<SkincareIngredient> featuredIngredients;
  final Map<SkincareIngredient, String> concentrations;
  final ValueChanged<SkincareIngredient>? onIngredientTap;
  final int? maxVisible;
  final VoidCallback? onShowAll;

  @override
  Widget build(BuildContext context) {
    final displayList = maxVisible != null && maxVisible! < ingredients.length
        ? ingredients.take(maxVisible!).toList()
        : ingredients;
    final hasMore = maxVisible != null && ingredients.length > maxVisible!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...displayList.map((ingredient) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s),
            child: ProductIngredientCard(
              ingredient: ingredient,
              isFeatured: featuredIngredients.contains(ingredient),
              concentration: concentrations[ingredient],
              onTap: onIngredientTap != null
                  ? () => onIngredientTap!(ingredient)
                  : null,
            ),
          );
        }),
        if (hasMore && onShowAll != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s),
            child: Center(
              child: TextButton.icon(
                onPressed: onShowAll,
                icon: const Icon(Icons.expand_more_rounded, size: 18),
                label: Text(
                  'Show all ${ingredients.length} ingredients',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Compact ingredient chips row for product cards
class IngredientHighlights extends StatelessWidget {
  const IngredientHighlights({
    super.key,
    required this.ingredients,
    this.maxVisible = 3,
  });

  final List<SkincareIngredient> ingredients;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    final displayList = ingredients.take(maxVisible).toList();
    final remaining = ingredients.length - maxVisible;

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        ...displayList.map((ingredient) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ingredient.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  ingredient.emoji,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 4),
                Text(
                  ingredient.shortName,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ingredient.color,
                  ),
                ),
              ],
            ),
          );
        }),
        if (remaining > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.chipBg,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              '+$remaining',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}
