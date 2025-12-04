import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';

/// Circular progress tracker for routine completion
class RoutineProgressTracker extends StatelessWidget {
  const RoutineProgressTracker({
    super.key,
    required this.completedSteps,
    required this.totalSteps,
    this.size = 120,
    this.strokeWidth = 10,
    this.showPercentage = true,
    this.accentColor,
  });

  final int completedSteps;
  final int totalSteps;
  final double size;
  final double strokeWidth;
  final bool showPercentage;
  final Color? accentColor;

  double get progress => totalSteps > 0 ? completedSteps / totalSteps : 0;

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.primary;
    final percentage = (progress * 100).round();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: strokeWidth,
              backgroundColor: color.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation(color.withValues(alpha: 0.12)),
            ),
          ),
          // Progress circle
          SizedBox(
            width: size,
            height: size,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: strokeWidth,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(color),
                );
              },
            ),
          ),
          // Center content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showPercentage)
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: percentage),
                  duration: const Duration(milliseconds: 600),
                  builder: (context, value, child) {
                    return Text(
                      '$value%',
                      style: TextStyle(
                        fontSize: size * 0.22,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    );
                  },
                ),
              Text(
                '$completedSteps of $totalSteps',
                style: TextStyle(
                  fontSize: size * 0.1,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Header for morning/evening routine sections
class RoutineTimeHeader extends StatelessWidget {
  const RoutineTimeHeader({
    super.key,
    required this.isMorning,
    this.completedSteps = 0,
    this.totalSteps = 0,
    this.estimatedTime,
    this.onStart,
  });

  final bool isMorning;
  final int completedSteps;
  final int totalSteps;
  final Duration? estimatedTime;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final isComplete = completedSteps == totalSteps && totalSteps > 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isMorning
              ? [
                  const Color(0xFFFFF3E0),
                  const Color(0xFFFFF8E1),
                ]
              : [
                  const Color(0xFFE8EAF6),
                  const Color(0xFFF3E5F5),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color:
                (isMorning ? const Color(0xFFFFB74D) : const Color(0xFF7E57C2))
                    .withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: isMorning
                    ? [const Color(0xFFFFB74D), const Color(0xFFFF9800)]
                    : [const Color(0xFF9575CD), const Color(0xFF673AB7)],
              ),
              boxShadow: [
                BoxShadow(
                  color: (isMorning
                          ? const Color(0xFFFF9800)
                          : const Color(0xFF673AB7))
                      .withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              isMorning ? Icons.wb_sunny_rounded : Icons.nightlight_rounded,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: AppSpacing.l),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isMorning ? 'Morning Routine' : 'Evening Routine',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isMorning
                            ? const Color(0xFFE65100)
                            : const Color(0xFF512DA8),
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.checklist_rounded,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$completedSteps/$totalSteps steps',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (estimatedTime != null) ...[
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.timer_outlined,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '~${estimatedTime!.inMinutes} min',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Action button
          if (!isComplete && onStart != null)
            ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: isMorning
                    ? const Color(0xFFFF9800)
                    : const Color(0xFF673AB7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.s,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              child: const Text(
                'Start',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            )
          else if (isComplete)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success.withValues(alpha: 0.15),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 28,
              ),
            ),
        ],
      ),
    );
  }
}

/// Compact routine summary card for dashboard
class RoutineSummaryCard extends StatelessWidget {
  const RoutineSummaryCard({
    super.key,
    required this.morningProgress,
    required this.morningTotal,
    required this.eveningProgress,
    required this.eveningTotal,
    this.onTap,
  });

  final int morningProgress;
  final int morningTotal;
  final int eveningProgress;
  final int eveningTotal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Routine",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.l),
            Row(
              children: [
                Expanded(
                  child: _MiniProgress(
                    icon: Icons.wb_sunny_rounded,
                    label: 'Morning',
                    progress: morningProgress,
                    total: morningTotal,
                    color: const Color(0xFFFF9800),
                  ),
                ),
                const SizedBox(width: AppSpacing.l),
                Expanded(
                  child: _MiniProgress(
                    icon: Icons.nightlight_rounded,
                    label: 'Evening',
                    progress: eveningProgress,
                    total: eveningTotal,
                    color: const Color(0xFF673AB7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniProgress extends StatelessWidget {
  const _MiniProgress({
    required this.icon,
    required this.label,
    required this.progress,
    required this.total,
    required this.color,
  });

  final IconData icon;
  final String label;
  final int progress;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final percent = total > 0 ? progress / total : 0.0;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.12),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: AppSpacing.s),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: LinearProgressIndicator(
                  value: percent,
                  backgroundColor: color.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation(color),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        Text(
          '$progress/$total',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
