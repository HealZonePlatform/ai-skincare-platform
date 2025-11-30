import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/presentation/screens/home/models/home_models.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

class InsightCards extends StatelessWidget {
  const InsightCards({super.key, required this.insights});

  final List<InsightModel> insights;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (insights.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.l),
          border: Border.all(color: AppColors.divider),
        ),
        child: Text(
          'No insights yet. Complete a scan to unlock tips.',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    Widget buildCard(InsightModel insight, bool isWide) {
      final gradient = LinearGradient(
        colors: [
          insight.iconColor.withValues(alpha: 0.1),
          Colors.white,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      final progressPercent = (insight.progress * 100).round();
      return AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.symmetric(
          horizontal: isWide ? AppSpacing.m / 2 : 0,
          vertical: isWide ? 0 : AppSpacing.m / 2,
        ),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppRadius.l),
          boxShadow: AppShadows.mild,
          border: Border.all(color: insight.iconColor.withValues(alpha: 0.16)),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -16,
              child: Transform.rotate(
                angle: -math.pi / 12,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: insight.iconColor.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s),
                        decoration: BoxDecoration(
                          color: insight.iconColor.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Icon(insight.icon,
                            color: insight.iconColor, size: 20),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            insight.title,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            insight.caption,
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        '$progressPercent%',
                        style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: insight.iconColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    child: LinearProgressIndicator(
                      value: insight.progress,
                      minHeight: 10,
                      backgroundColor:
                          insight.iconColor.withValues(alpha: 0.12),
                      valueColor: AlwaysStoppedAnimation(insight.iconColor),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Row(
                    children: [
                      Icon(insight.icon,
                          size: 16,
                          color: insight.iconColor.withValues(alpha: 0.8)),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'AI recommends a gentle boost',
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final cards =
            insights.map((insight) => buildCard(insight, isWide)).toList();

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: cards.map((card) => Expanded(child: card)).toList(),
          );
        }
        return Column(children: cards);
      },
    );
  }
}
