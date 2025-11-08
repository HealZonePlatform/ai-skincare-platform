import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/presentation/widgets/hz_buttons.dart';
import 'package:ai_skincare_platform/presentation/widgets/optimized_network_image.dart';
import 'package:ai_skincare_platform/presentation/widgets/ui_kit/hz_section_header.dart';
import 'package:ai_skincare_platform/presentation/widgets/ui_kit/hz_stat_chip.dart';
import 'package:ai_skincare_platform/presentation/widgets/ui_kit/hz_surface_card.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

class ScanPrepareScreen extends StatefulWidget {
  const ScanPrepareScreen({super.key});

  @override
  State<ScanPrepareScreen> createState() => _ScanPrepareScreenState();
}

class _ScanPrepareScreenState extends State<ScanPrepareScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              HzSurfaceCard(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Row(
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _controller.value * math.pi * 2,
                          child: child,
                        );
                      },
                      child: const Icon(Icons.sunny, size: 48, color: AppColors.secondary),
                    ),
                    const SizedBox(width: AppSpacing.l),
                    const Expanded(
                      child: Text(
                        'Đảm bảo ánh sáng tự nhiên hoặc đèn trắng dịu. Tránh ánh sáng vàng để AI nhận diện tốt nhất.',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              const _AnimatedInstructionList(),
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

class _AnimatedInstructionList extends StatefulWidget {
  const _AnimatedInstructionList();

  @override
  State<_AnimatedInstructionList> createState() => _AnimatedInstructionListState();
}

class _AnimatedInstructionListState extends State<_AnimatedInstructionList> {
  final instructions = const [
    _InstructionRow(icon: Icons.clean_hands, text: 'Làm sạch da mặt và lau khô trước khi quét.'),
    _InstructionRow(icon: Icons.center_focus_strong, text: 'Giữ máy cách mặt 15-20cm, căn chỉnh trán giữa khung.'),
    _InstructionRow(icon: Icons.spa_outlined, text: 'Thả lỏng khuôn mặt và giữ yên trong 5 giây.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Các bước nhanh',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.m),
        ...instructions.asMap().entries.map(
          (entry) => TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 400 + entry.key * 120),
            builder: (context, value, child) => Opacity(opacity: value, child: child),
            child: entry.value,
          ),
        ),
      ],
    );
  }
}

class ScanCaptureScreen extends StatefulWidget {
  const ScanCaptureScreen({super.key});

  @override
  State<ScanCaptureScreen> createState() => _ScanCaptureScreenState();
}

class _ScanCaptureScreenState extends State<ScanCaptureScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đang quét gương mặt')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final scale = 1 + (_controller.value * 0.05);
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(280),
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.15),
                            AppColors.primary.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: const Icon(Icons.face_retouching_natural, size: 120, color: AppColors.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              LinearProgressIndicator(
                value: _controller.value,
                minHeight: 8,
                borderRadius: BorderRadius.circular(AppRadius.m),
              ),
              const SizedBox(height: AppSpacing.xl),
              HzPrimaryButton(
                label: 'Xem kết quả mẫu',
                icon: Icons.visibility_outlined,
                onPressed: () => context.push('/scan/result'),
              ),
            ],
          ),
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
      appBar: AppBar(title: const Text('Kết quả gần nhất')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            HzSurfaceCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.success.withValues(alpha: 0.1),
                    child: const Text(
                      '86',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.l),
                  const Expanded(
                    child: Text(
                      'Da khỏe ổn định! Tiếp tục duy trì routine hiện tại để cải thiện vùng chữ T.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            HzSectionHeader(
              title: 'Chỉ số chính',
              subtitle: 'Cập nhật dựa trên lần quét mới nhất',
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppSpacing.m),
            Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: const [
                HzStatChip(label: 'Độ ẩm', value: '72', icon: Icons.water_drop),
                HzStatChip(label: 'Độ đàn hồi', value: '80', icon: Icons.auto_graph),
                HzStatChip(label: 'Thâm mụn', value: '65', icon: Icons.blur_on),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            HzSectionHeader(
              title: 'Ảnh đối chiếu',
              padding: const EdgeInsets.only(bottom: AppSpacing.m),
            ),
            OptimizedNetworkImage(
              imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=800',
              height: 220,
              borderRadius: AppRadius.l,
            ),
            const SizedBox(height: AppSpacing.xl),
            HzPrimaryButton(
              label: 'Xem phân tích chi tiết',
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
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
