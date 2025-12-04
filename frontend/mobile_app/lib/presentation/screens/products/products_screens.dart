import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/core/utils/haptics.dart';
import 'package:ai_skincare_platform/presentation/widgets/illustrated_message.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

class ProductsListScreen extends StatelessWidget {
  const ProductsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const products = <_ProductSummary>[
      _ProductSummary(
        id: '1',
        name: 'Senka Perfect Whip',
        price: '96,000 VND',
        rating: 4.7,
        imageUrl: 'assets/images/product_placeholder.png',
        tags: ['Cleanser', 'Gentle foam', 'Daily'],
      ),
      _ProductSummary(
        id: '2',
        name: "Paula's Choice BHA 2%",
        price: '335,000 VND',
        rating: 4.8,
        imageUrl: 'assets/images/product_placeholder.png',
        tags: ['Exfoliant', 'BHA 2%', 'Reduce acne'],
      ),
      _ProductSummary(
        id: '3',
        name: 'Skin1004 Ampoule',
        price: '420,000 VND',
        rating: 4.6,
        imageUrl: 'assets/images/product_placeholder.png',
        tags: ['Repair', 'Calming', 'Ampoule'],
      ),
    ];
    final hasProducts = products.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended products'),
        actions: [
          IconButton(
            onPressed: () async {
              await Haptics.selection();
            },
            icon: const Icon(Icons.filter_alt_outlined),
            tooltip: 'Filter',
          ),
        ],
      ),
      body: hasProducts
          ? ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.xl),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.l),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.l),
                    boxShadow: AppShadows.mild,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.l),
                    onTap: () async {
                      await Haptics.selection();
                      if (context.mounted) {
                        context.push('/products/${product.id}');
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.m),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.m),
                            child: Image.asset(
                              product.imageUrl,
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.m),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded,
                                        color: AppColors.warning, size: 18),
                                    const SizedBox(width: AppSpacing.xs),
                                    Text(
                                      product.rating.toStringAsFixed(1),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Wrap(
                                  spacing: AppSpacing.s,
                                  runSpacing: AppSpacing.xs,
                                  children: product.tags
                                      .map(
                                        (tag) => Chip(
                                          label: Text(tag),
                                          backgroundColor: AppColors.surfaceLight,
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                  color:
                                                      AppColors.textPrimary),
                                          side:
                                              const BorderSide(color: AppColors.border),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.m),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                product.price,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              FilledButton.icon(
                                onPressed: () async {
                                  await Haptics.selection();
                                  if (context.mounted) {
                                    context.push('/products/${product.id}');
                                  }
                                },
                                icon: const Icon(Icons.arrow_forward_rounded),
                                label: const Text('Details'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : const _EmptyProductsState(),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product #$productId')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.l),
                child: Image.asset(
                  'assets/images/product_placeholder.png',
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                'Senka Perfect Whip',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'BeautyStore Official • 96,000 VND',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.m),
              const Wrap(
                spacing: AppSpacing.s,
                children: [
                  Chip(label: Text('Gentle foam')),
                  Chip(label: Text('All skin types')),
                  Chip(label: Text('Daily use')),
                ],
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                'Product story',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.s),
              const Text(
                'Foaming cleanser with amino acid surfactants to deeply clean without stripping. Enriched with silk essence and hyaluronic acid to maintain hydration and support skin barrier. Ideal for daily AM/PM use.',
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Add to routine'),
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Buy now'),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyProductsState extends StatelessWidget {
  const _EmptyProductsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: IllustratedMessage(
          illustration: IllustrationType.emptyProducts,
          title: 'Curating your shelf',
          message:
              'We are matching products to your latest scans. Check the community for routines while we prepare picks.',
          actionLabel: 'See community tips',
          onAction: () {
            Haptics.selection();
            context.push('/community');
          },
        ),
      ),
    );
  }
}

class _ProductSummary {
  final String id;
  final String name;
  final String price;
  final double rating;
  final String imageUrl;
  final List<String> tags;

  const _ProductSummary({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.tags,
  });
}

