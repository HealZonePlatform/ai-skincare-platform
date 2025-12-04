import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/core/analytics/analytics_service.dart';
import 'package:ai_skincare_platform/core/utils/haptics.dart';
import 'package:ai_skincare_platform/presentation/screens/home/models/home_models.dart';
import 'package:ai_skincare_platform/presentation/widgets/illustrated_message.dart';
import 'package:ai_skincare_platform/presentation/widgets/optimized_network_image.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

class ProductCarousel extends StatelessWidget {
  const ProductCarousel({super.key, required this.products});

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return SliverToBoxAdapter(
        child: IllustratedMessage(
          illustration: IllustrationType.emptyProducts,
          title: 'No recommendations yet',
          message: 'Complete a quick scan to unlock products matched to your skin.',
          actionLabel: 'Start scan',
          onAction: () => context.push('/scan/permission'),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 340,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          cacheExtent: 960,
          itemBuilder: (context, index) => ProductCard(
            product: products[index],
          ),
          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.l),
          itemCount: products.length,
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ingredients = product.benefit
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final ingredientBadges =
        ingredients.isNotEmpty ? ingredients : [product.badge];
    return Semantics(
      label: 'View product ${product.name}',
      button: true,
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.l),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              product.color.withValues(alpha: 0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: product.color.withValues(alpha: 0.2)),
          boxShadow: AppShadows.medium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.m),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: _buildProductImage(),
                  ),
                ),
                Positioned(
                  top: AppSpacing.s,
                  left: AppSpacing.s,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.m,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      boxShadow: AppShadows.mild,
                    ),
                    child: Text(
                      product.badge,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.l),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              product.benefit,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              'Ingredient focus',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: ingredientBadges
                  .map(
                    (badge) => Chip(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s,
                        vertical: AppSpacing.xs,
                      ),
                      avatar: const Icon(Icons.science_outlined, size: 16),
                      label: Text(badge),
                    ),
                  )
                  .toList(),
            ),
            const Spacer(),
            Row(
              children: [
                Icon(product.icon, color: product.color, size: 20),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  product.rating.toStringAsFixed(1),
                  style: theme.textTheme.labelMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Tooltip(
                  message: 'View ${product.name}',
                  child: FilledButton.tonal(
                  onPressed: () async {
                    await Haptics.selection();
                    if (context.mounted) {
                      AnalyticsService.logProductView(
                        product.route,
                        parameters: {'surface': 'home_carousel'},
                      );
                      context.push(product.route);
                    }
                  },
                    style: FilledButton.styleFrom(
                      backgroundColor: product.color.withValues(alpha: 0.15),
                      foregroundColor: product.color,
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                      minimumSize: const Size(0, 36),
                    ),
                    child: const Text('View'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
      return OptimizedNetworkImage(
        imageUrl: product.imageUrl!,
        aspectRatio: 1,
        borderRadius: AppRadius.m,
      );
    }
    return Image.asset(
      product.placeholderAsset,
      fit: BoxFit.cover,
      cacheWidth: 800,
      cacheHeight: 800,
      errorBuilder: (_, __, ___) => Container(
        color: product.color.withValues(alpha: 0.12),
        alignment: Alignment.center,
        child: Icon(product.icon, color: product.color, size: 48),
      ),
    );
  }
}
