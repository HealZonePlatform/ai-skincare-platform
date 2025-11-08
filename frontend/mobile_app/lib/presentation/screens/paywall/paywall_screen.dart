import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_buttons.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HealZone Premium')), 
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Khám phá toàn bộ sức mạnh AI của HealZone', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: ListView(
                  children: const [
                    _PlanCard(
                      name: 'Gói Nâng Cao',
                      price: '49.000đ / tháng',
                      features: ['Quét da không giới hạn', 'Routine cá nhân hoá', 'Thư viện sản phẩm được kiểm duyệt'],
                    ),
                    _PlanCard(
                      name: 'Gói Chuyên Gia',
                      price: '99.000đ / tháng',
                      features: ['Tư vấn chuyên gia định kỳ', 'Theo dõi tiến triển 1-1', 'Nhắc nhở thông minh'],
                      highlight: true,
                    ),
                  ],
                ),
              ),
              HzPrimaryButton(
                label: 'Chọn gói & thanh toán',
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
    return Card(
      color: highlight ? AppColors.primary.withValues(alpha: 0.08) : Colors.white,
      margin: const EdgeInsets.only(bottom: AppSpacing.l),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.l)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.s),
            Text(price, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.m),
            for (final feature in features)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.check_circle_outline, color: AppColors.primary),
                title: Text(feature),
              ),
          ],
        ),
      ),
    );
  }
}
