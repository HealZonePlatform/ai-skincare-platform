import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/core/analytics/analytics_service.dart';
import 'package:ai_skincare_platform/core/utils/haptics.dart';
import 'package:ai_skincare_platform/presentation/screens/home/models/home_models.dart';
import 'package:ai_skincare_platform/presentation/widgets/ui_kit/hz_responsive_layout.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

class RoutineCarousel extends StatelessWidget {
  const RoutineCarousel({super.key, required this.routines});

  final List<RoutineModel> routines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (routines.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.l),
          border: Border.all(color: AppColors.divider),
        ),
        child: Text(
          'No routines assigned. Check back after your next scan.',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s routines',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.m),
        HzResponsiveLayout(
          mobile: (_, __) => SizedBox(
            height: 320,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              cacheExtent: 720,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) =>
                  RoutineCard(routine: routines[index]),
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.l),
              itemCount: routines.length,
            ),
          ),
          tablet: (_, constraints) {
            final itemWidth = (constraints.maxWidth - AppSpacing.l) / 2;
            return Wrap(
              spacing: AppSpacing.l,
              runSpacing: AppSpacing.l,
              children: routines
                  .map(
                    (routine) => SizedBox(
                      width: itemWidth,
                      child: RoutineCard(routine: routine),
                    ),
                  )
                  .toList(),
            );
          },
          desktop: (_, constraints) {
            final rawWidth = (constraints.maxWidth - AppSpacing.l * 2) / 3;
            final itemWidth = rawWidth.clamp(260, 320).toDouble();
            return Wrap(
              spacing: AppSpacing.l,
              runSpacing: AppSpacing.l,
              children: routines
                  .map(
                    (routine) => SizedBox(
                      width: itemWidth,
                      child: RoutineCard(routine: routine),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class RoutineCard extends StatelessWidget {
  const RoutineCard({super.key, required this.routine});

  final RoutineModel routine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      width: 240,
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.l),
        gradient: LinearGradient(
          colors: [
            routine.accentColor.withValues(alpha: 0.12),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: routine.accentColor.withValues(alpha: 0.2)),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.m, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: routine.accentColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  routine.bestMoment,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: routine.accentColor),
                ),
              ),
              const Spacer(),
              Icon(routine.icon, color: routine.accentColor),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            routine.title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            routine.focus,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.m),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: [
              ...routine.steps.take(3).map(
                    (step) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.m, vertical: AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(
                            color: routine.accentColor.withValues(alpha: 0.22)),
                      ),
                      child: Text(
                        step,
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
              if (routine.steps.length > 3)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.m, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: routine.accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    '+${routine.steps.length - 3}',
                    style: theme.textTheme.labelSmall?.copyWith(
                        color: routine.accentColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.timelapse_rounded,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${routine.minutes} min',
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const Spacer(),
              Tooltip(
                message: 'See routine details',
                child: FilledButton.tonal(
                  onPressed: () async {
                    await Haptics.selection();
                    if (context.mounted) {
                      AnalyticsService.logRoutineOpen(
                        routine.title,
                        parameters: {'focus': routine.focus},
                      );
                      context.push('/routine');
                    }
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.s, horizontal: AppSpacing.m),
                    backgroundColor: routine.accentColor.withValues(alpha: 0.2),
                    foregroundColor: routine.accentColor,
                  ),
                  child: const Text('See details'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
