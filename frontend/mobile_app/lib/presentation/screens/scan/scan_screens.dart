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

class _ScanPrepareScreenState extends State<ScanPrepareScreen>
    with SingleTickerProviderStateMixin {
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
      appBar: AppBar(
        title: const Text('Chuẩn bị quét da'),
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.xl),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + (_controller.value * 0.05),
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.secondary.withValues(alpha: 0.1),
                            ),
                            child: const Icon(Icons.wb_sunny_rounded,
                                size: 80, color: AppColors.secondary),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Let\'s check your skin',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.m),
                    Text(
                      'Ensure natural lighting and remove any makeup or glasses for the best result.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    const _AnimatedInstructionList(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: HzPrimaryButton(
                label: 'Start Scan',
                icon: Icons.camera_alt_rounded,
                onPressed: () => context.push('/scan/capture'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedInstructionList extends StatelessWidget {
  const _AnimatedInstructionList();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _InstructionItem(icon: Icons.face, label: 'No Makeup'),
        _InstructionItem(icon: Icons.visibility_off, label: 'No Glasses'),
        _InstructionItem(icon: Icons.sentiment_neutral, label: 'Neutral Face'),
      ],
    );
  }
}

class _InstructionItem extends StatelessWidget {
  const _InstructionItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.l),
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.s),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(fontWeight: FontWeight.w600),
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

class _ScanCaptureScreenState extends State<ScanCaptureScreen>
    with SingleTickerProviderStateMixin {
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
                      child: const Icon(Icons.face_retouching_natural,
                          size: 120, color: AppColors.primary),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
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
            const HzSectionHeader(
              title: 'Chỉ số chính',
              subtitle: 'Cập nhật dựa trên lần quét mới nhất',
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppSpacing.m),
            const Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: [
                HzStatChip(label: 'Độ ẩm', value: '72', icon: Icons.water_drop),
                HzStatChip(
                    label: 'Độ đàn hồi', value: '80', icon: Icons.auto_graph),
                HzStatChip(label: 'Thâm mụn', value: '65', icon: Icons.blur_on),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            const HzSectionHeader(
              title: 'Ảnh đối chiếu',
              padding: EdgeInsets.only(bottom: AppSpacing.m),
            ),
            const OptimizedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=800',
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
