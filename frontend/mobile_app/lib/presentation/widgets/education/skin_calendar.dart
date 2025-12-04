import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/core/utils/haptics.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

/// Skincare calendar showing routine tracking
class SkinCalendar extends StatelessWidget {
  const SkinCalendar({
    super.key,
    required this.month,
    required this.year,
    required this.entries,
    this.onDayTap,
    this.onPreviousMonth,
    this.onNextMonth,
  });

  final int month;
  final int year;
  final Map<int, CalendarEntry> entries;
  final ValueChanged<int>? onDayTap;
  final VoidCallback? onPreviousMonth;
  final VoidCallback? onNextMonth;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstDayOfWeek = DateTime(year, month, 1).weekday;
    final today = DateTime.now();
    final isCurrentMonth = today.month == month && today.year == year;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onPreviousMonth,
                icon: const Icon(Icons.chevron_left_rounded),
                color: AppColors.textSecondary,
              ),
              Text(
                '${_monthNames[month - 1]} $year',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              IconButton(
                onPressed: onNextMonth,
                icon: const Icon(Icons.chevron_right_rounded),
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          // Weekday headers
          Row(
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.s),
          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: 42,
            itemBuilder: (context, index) {
              final dayOffset = index - (firstDayOfWeek - 1);
              if (dayOffset < 1 || dayOffset > daysInMonth) {
                return const SizedBox();
              }

              final entry = entries[dayOffset];
              final isToday = isCurrentMonth && today.day == dayOffset;
              final isPast = DateTime(year, month, dayOffset).isBefore(
                DateTime(today.year, today.month, today.day),
              );

              return GestureDetector(
                onTap: () {
                  Haptics.selection();
                  onDayTap?.call(dayOffset);
                },
                child: _CalendarDay(
                  day: dayOffset,
                  entry: entry,
                  isToday: isToday,
                  isPast: isPast,
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.l),
          // Legend
          const _CalendarLegend(),
        ],
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.day,
    this.entry,
    this.isToday = false,
    this.isPast = false,
  });

  final int day;
  final CalendarEntry? entry;
  final bool isToday;
  final bool isPast;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    BoxBorder? border;

    if (entry != null) {
      bgColor = _getStatusColor(entry!.status).withValues(alpha: 0.15);
      textColor = _getStatusColor(entry!.status);
    } else if (isToday) {
      bgColor = AppColors.primary.withValues(alpha: 0.12);
      textColor = AppColors.primary;
      border = Border.all(color: AppColors.primary, width: 2);
    } else if (isPast) {
      bgColor = AppColors.chipBg.withValues(alpha: 0.5);
      textColor = AppColors.textTertiary;
    } else {
      bgColor = Colors.transparent;
      textColor = AppColors.textPrimary;
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: border,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            '$day',
            style: TextStyle(
              fontSize: 13,
              fontWeight: isToday || entry != null
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: textColor,
            ),
          ),
          // Score indicator
          if (entry?.score != null)
            Positioned(
              bottom: 2,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getScoreColor(entry!.score!),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(RoutineStatus status) {
    switch (status) {
      case RoutineStatus.complete:
        return AppColors.success;
      case RoutineStatus.partial:
        return AppColors.warning;
      case RoutineStatus.skipped:
        return AppColors.danger;
      case RoutineStatus.none:
        return AppColors.textTertiary;
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.warning;
    return AppColors.danger;
  }
}

class _CalendarLegend extends StatelessWidget {
  const _CalendarLegend();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(
          color: AppColors.success,
          label: 'Complete',
        ),
        SizedBox(width: AppSpacing.l),
        _LegendItem(
          color: AppColors.warning,
          label: 'Partial',
        ),
        SizedBox(width: AppSpacing.l),
        _LegendItem(
          color: AppColors.danger,
          label: 'Skipped',
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Calendar entry data
class CalendarEntry {
  const CalendarEntry({
    required this.date,
    required this.status,
    this.score,
    this.morningComplete = false,
    this.eveningComplete = false,
    this.note,
  });

  final DateTime date;
  final RoutineStatus status;
  final int? score;
  final bool morningComplete;
  final bool eveningComplete;
  final String? note;
}

enum RoutineStatus { complete, partial, skipped, none }

const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Weekly streak widget
class StreakWidget extends StatelessWidget {
  const StreakWidget({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    required this.weekData,
    this.onTap,
  });

  final int currentStreak;
  final int longestStreak;
  final List<bool> weekData; // 7 days, true = complete
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFF6B6B).withValues(alpha: 0.1),
              const Color(0xFFFF8E53).withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: const Color(0xFFFF6B6B).withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Fire icon with streak
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '$currentStreak',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFFF6B6B),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'day streak',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF8E53),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Best: $longestStreak days',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.l),
            // Week days
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final isComplete = index < weekData.length && weekData[index];
                final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

                return Column(
                  children: [
                    Text(
                      dayLabels[index],
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isComplete
                            ? const Color(0xFFFF6B6B)
                            : AppColors.chipBg,
                      ),
                      child: isComplete
                          ? const Icon(
                              Icons.check_rounded,
                              size: 18,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skin goal tracker card
class SkinGoalCard extends StatelessWidget {
  const SkinGoalCard({
    super.key,
    required this.goal,
    this.onTap,
    this.onComplete,
  });

  final SkinGoal goal;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    final progress = goal.currentDays / goal.targetDays;
    final isComplete = progress >= 1;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.l),
          border: Border.all(
            color: isComplete ? AppColors.success : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: goal.color.withValues(alpha: 0.12),
                  ),
                  child: Icon(goal.icon, size: 20, color: goal.color),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${goal.currentDays}/${goal.targetDays} days',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isComplete)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success.withValues(alpha: 0.12),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 20,
                      color: AppColors.success,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: LinearProgressIndicator(
                value: progress.clamp(0, 1).toDouble(),
                backgroundColor: goal.color.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation(goal.color),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SkinGoal {
  const SkinGoal({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.targetDays,
    this.currentDays = 0,
  });

  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final int targetDays;
  final int currentDays;
}
