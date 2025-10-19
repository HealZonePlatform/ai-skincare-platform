import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';

class LifestyleScreen extends StatelessWidget {
  const LifestyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lối sống & thói quen'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: const [
          _LifestyleTile(
            title: 'Giấc ngủ',
            value: '7.5 giờ / đêm',
            description: 'Ổn định, nên cố gắng đi ngủ trước 23h để da phục hồi tốt hơn.',
          ),
          _LifestyleTile(
            title: 'Nước uống',
            value: '2 lít mỗi ngày',
            description: 'Tăng thêm 0.5 lít vào những ngày vận động nhiều.',
          ),
          _LifestyleTile(
            title: 'Chế độ ăn',
            value: 'Kiêng đường, nhiều rau xanh',
            description: 'Bổ sung omega-3 từ cá biển, các loại hạt.',
          ),
          _LifestyleTile(
            title: 'Căng thẳng',
            value: 'Mức 4/10',
            description: 'Tập hít thở 4-7-8 và yoga nhẹ 3 lần/tuần.',
          ),
        ],
      ),
    );
  }
}

class _LifestyleTile extends StatelessWidget {
  const _LifestyleTile({required this.title, required this.value, required this.description});

  final String title;
  final String value;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.l),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.m)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.s),
            Text(value, style: const TextStyle(color: AppColors.primary)),
            const SizedBox(height: AppSpacing.s),
            Text(description),
          ],
        ),
      ),
    );
  }
}
