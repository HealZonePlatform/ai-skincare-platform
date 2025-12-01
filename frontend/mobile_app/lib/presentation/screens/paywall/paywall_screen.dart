import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/presentation/widgets/hz_buttons.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: const Text('HealZone Premium')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kham pha toan bo suc manh AI cua HealZone',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: ListView(
                  children: const [
                    _PlanCard(
                      name: 'Goi Nang Cao',
                      price: '49.000d / thang',
                      features: [
                        'Quet da khong gioi han',
                        'Routine ca nhan hoa',
                        'Thu vien san pham da kiem duyet'
                      ],
                    ),
                    _PlanCard(
                      name: 'Goi Chuyen Gia',
                      price: '99.000d / thang',
                      features: [
                        'Tu van chuyen gia dinh ky',
                        'Theo doi tien trinh 1-1',
                        'Nhat ky nhac nho thong minh'
                      ],
                      highlight: true,
                    ),
                  ],
                ),
              ),
              HzPrimaryButton(
                label: 'Chon goi & thanh toan',
                icon: Icons.credit_card,
                onPressed: () => context.push('/checkout/method'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.name,
    required this.price,
    required this.features,
    this.highlight = false,
  });

  final String name;
  final String price;
  final List<String> features;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final cardColor = highlight
        ? theme.colorScheme.primary.withValues(alpha: 0.08)
        : surface;

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: AppSpacing.l),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.l),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.7),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              price,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            for (final feature in features)
              ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primary,
                  size: 20,
                ),
                title: Text(
                  feature,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
