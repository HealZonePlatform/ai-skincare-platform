// lib/presentation/screens/profile/skin_analysis_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ai_skincare_platform/domain/profile/entities/user_profile.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_buttons.dart';
import 'package:ai_skincare_platform/presentation/widgets/optimized_network_image.dart';
import 'package:ai_skincare_platform/presentation/widgets/ui_kit/hz_section_header.dart';
import 'package:ai_skincare_platform/presentation/widgets/ui_kit/hz_stat_chip.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

class SkinAnalysisDetailScreen extends StatelessWidget {
  const SkinAnalysisDetailScreen({
    super.key,
    required this.analysisItem,
  });

  final SkinAnalysisHistory analysisItem;

  @override
  Widget build(BuildContext context) {
    final createdDate = DateFormat('dd MMM yyyy – HH:mm').format(analysisItem.createdAt.toLocal());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết phân tích da'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OptimizedNetworkImage(
              imageUrl: analysisItem.imageUrl,
              height: 240,
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildBasicInfoCard(context, createdDate),
            const SizedBox(height: AppSpacing.xl),
            HzSectionHeader(
              title: 'Điểm nổi bật',
              subtitle: 'Các chỉ số chính mà AI đánh giá được',
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppSpacing.m),
            _buildHighlightChips(),
            const SizedBox(height: AppSpacing.xl),
            _buildAnalysisResultCard(),
            const SizedBox(height: AppSpacing.xl),
            HzPrimaryButton(
              label: 'Chia sẻ (demo)',
              icon: Icons.info_outline,
              onPressed: () => _showDemoNotice(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard(BuildContext context, String createdDate) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phân tích #${analysisItem.id.substring(0, 8)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.s),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: AppSpacing.s),
                Text(createdDate),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            if (analysisItem.status != null) _buildStatusBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color statusColor;
    switch (analysisItem.status) {
      case 'completed':
        statusColor = AppColors.success;
        break;
      case 'pending':
        statusColor = AppColors.warning;
        break;
      default:
        statusColor = AppColors.danger;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.s),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
      child: Text(
        analysisItem.status!,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHighlightChips() {
    final entries = analysisItem.analysisResult?.entries.take(3).toList() ?? [];
    if (entries.isEmpty) {
      return const Text(
        'Chúng tôi sẽ hiển thị highlight khi có đủ dữ liệu từ những lần quét tiếp theo.',
        style: TextStyle(color: AppColors.textSecondary),
      );
    }

    return Wrap(
      spacing: AppSpacing.s,
      runSpacing: AppSpacing.s,
      children: [
        for (final entry in entries)
          HzStatChip(
            label: entry.key,
            value: entry.value.toString(),
            icon: Icons.insights_outlined,
          ),
      ],
    );
  }

  Widget _buildAnalysisResultCard() {
    if (analysisItem.analysisResult == null || analysisItem.analysisResult!.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.l),
          child: Text('Chưa có kết quả phân tích chi tiết'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kết quả chi tiết',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.m),
            ...analysisItem.analysisResult!.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${entry.key}:'),
                    Text(
                      entry.value.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showDemoNotice(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chức năng chia sẻ chỉ bật trên bản production.')),
    );
  }
}
