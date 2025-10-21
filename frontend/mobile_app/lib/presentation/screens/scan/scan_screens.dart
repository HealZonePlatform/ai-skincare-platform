import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_buttons.dart';

class ScanPrepareScreen extends StatelessWidget {
  const ScanPrepareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chuẩn bị quét da')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _InstructionRow(icon: Icons.sunny, text: 'Đứng gần nguồn sáng tự nhiên hoặc ánh sáng trắng'),
              const _InstructionRow(icon: Icons.clean_hands, text: 'Làm sạch mặt và lau khô trước khi quét'),
              const _InstructionRow(icon: Icons.center_focus_strong, text: 'Giữ điện thoại cách mặt 15-20cm, canh giữa khung'),
              const Spacer(),
              HzPrimaryButton(
                label: 'Bắt đầu quét',
                icon: Icons.document_scanner,
                onPressed: () => context.push('/scan/capture'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScanCaptureScreen extends StatelessWidget {
  const ScanCaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đang quét gương mặt')),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(AppSpacing.xl),
              height: 280,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(AppRadius.l),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.photo_camera_front_outlined, size: 96, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.m),
            const Text('Giữ yên trong vài giây...'),
            const SizedBox(height: AppSpacing.xl),
            HzPrimaryButton(
              label: 'Xem kết quả mẫu',
              icon: Icons.visibility_outlined,
              onPressed: () => context.push('/scan/result'),
            ),
          ],
        ),
      ),
    );
  }
}

class ScanResultScreen extends StatelessWidget {
  const ScanResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kết quả quét da')), 
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.l),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.l),
                boxShadow: AppShadows.mild,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.success.withOpacityFraction(0.15),
                    child: const Text('86', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  const SizedBox(width: AppSpacing.l),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Da khá ổn định!', style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(height: AppSpacing.s),
                        Text('Làn da của bạn đang ở mức tốt, duy trì dưỡng ẩm và chống nắng hằng ngày.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: const [
                _ScoreTile(label: 'Mụn', value: '72'),
                _ScoreTile(label: 'Thâm', value: '80'),
                _ScoreTile(label: 'Độ ẩm', value: '68'),
                _ScoreTile(label: 'Dầu', value: '62'),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            HzPrimaryButton(
              label: 'Xem phân tích & gợi ý',
              icon: Icons.analytics_outlined,
              onPressed: () => context.push('/advice'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructionRow extends StatelessWidget {
  const _InstructionRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.l),
      child: Row(
        children: [
          CircleAvatar(radius: 24, backgroundColor: AppColors.primary.withOpacityFraction(0.15), child: Icon(icon, color: AppColors.primary)),
          const SizedBox(width: AppSpacing.m),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _ScoreTile extends StatelessWidget {
  const _ScoreTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.m),
        boxShadow: AppShadows.mild,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.s),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
    );
  }
}
