import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/core/utils/haptics.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

/// A shareable routine card for community posts
class SharedRoutineCard extends StatelessWidget {
  const SharedRoutineCard({
    super.key,
    required this.routine,
    this.onTap,
    this.onSave,
    this.onTry,
    this.compact = false,
  });

  final SharedRoutine routine;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final VoidCallback? onTry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(compact ? AppSpacing.m : AppSpacing.l),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _getTimeColor(routine.timeOfDay).withValues(alpha: 0.08),
              _getTimeColor(routine.timeOfDay).withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: _getTimeColor(routine.timeOfDay).withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  _getTimeColor(routine.timeOfDay).withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                // Time icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        _getTimeColor(routine.timeOfDay),
                        _getTimeColor(routine.timeOfDay).withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: Icon(
                    _getTimeIcon(routine.timeOfDay),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        routine.name,
                        style: TextStyle(
                          fontSize: compact ? 15 : 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          _MetaChip(
                            icon: Icons.format_list_numbered_rounded,
                            label: '${routine.steps.length} steps',
                          ),
                          const SizedBox(width: 8),
                          if (routine.estimatedMins != null)
                            _MetaChip(
                              icon: Icons.timer_outlined,
                              label: '${routine.estimatedMins} min',
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Saves count
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        routine.isSaved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        size: 16,
                        color: _getTimeColor(routine.timeOfDay),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatCount(routine.saves),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getTimeColor(routine.timeOfDay),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Description
            if (routine.description != null && !compact) ...[
              const SizedBox(height: AppSpacing.m),
              Text(
                routine.description!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            // Steps preview
            const SizedBox(height: AppSpacing.m),
            _StepsPreview(
              steps: routine.steps,
              compact: compact,
              accentColor: _getTimeColor(routine.timeOfDay),
            ),
            // Skin types
            if (routine.suitableFor.isNotEmpty && !compact) ...[
              const SizedBox(height: AppSpacing.m),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: routine.suitableFor.map((type) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.chipBg,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      type,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            // Actions
            if (!compact) ...[
              const SizedBox(height: AppSpacing.l),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Haptics.light();
                        onSave?.call();
                      },
                      icon: Icon(
                        routine.isSaved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_add_outlined,
                        size: 18,
                      ),
                      label: Text(routine.isSaved ? 'Saved' : 'Save'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _getTimeColor(routine.timeOfDay),
                        side: BorderSide(
                          color: _getTimeColor(routine.timeOfDay)
                              .withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Haptics.medium();
                        onTry?.call();
                      },
                      icon: const Icon(Icons.play_arrow_rounded, size: 18),
                      label: const Text('Try it'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getTimeColor(routine.timeOfDay),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getTimeColor(RoutineTime time) {
    switch (time) {
      case RoutineTime.morning:
        return const Color(0xFFFF9800);
      case RoutineTime.evening:
        return const Color(0xFF673AB7);
      case RoutineTime.weekly:
        return const Color(0xFF10B981);
    }
  }

  IconData _getTimeIcon(RoutineTime time) {
    switch (time) {
      case RoutineTime.morning:
        return Icons.wb_sunny_rounded;
      case RoutineTime.evening:
        return Icons.nightlight_rounded;
      case RoutineTime.weekly:
        return Icons.calendar_today_rounded;
    }
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}

/// Shared routine data
class SharedRoutine {
  const SharedRoutine({
    required this.id,
    required this.name,
    required this.timeOfDay,
    required this.steps,
    this.description,
    this.estimatedMins,
    this.suitableFor = const [],
    this.saves = 0,
    this.isSaved = false,
    this.authorName,
    this.authorAvatar,
  });

  final String id;
  final String name;
  final RoutineTime timeOfDay;
  final List<RoutineStepData> steps;
  final String? description;
  final int? estimatedMins;
  final List<String> suitableFor;
  final int saves;
  final bool isSaved;
  final String? authorName;
  final String? authorAvatar;
}

class RoutineStepData {
  const RoutineStepData({
    required this.name,
    required this.category,
    this.productName,
    this.productImage,
  });

  final String name;
  final String category;
  final String? productName;
  final String? productImage;
}

enum RoutineTime { morning, evening, weekly }

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textTertiary),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _StepsPreview extends StatelessWidget {
  const _StepsPreview({
    required this.steps,
    required this.compact,
    required this.accentColor,
  });

  final List<RoutineStepData> steps;
  final bool compact;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final displaySteps = compact ? steps.take(3).toList() : steps.take(5).toList();
    final hasMore = steps.length > displaySteps.length;

    return Column(
      children: [
        ...displaySteps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isLast = index == displaySteps.length - 1 && !hasMore;

          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                // Number
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor.withValues(alpha: 0.15),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Connector line
                if (!isLast)
                  Positioned(
                    left: 11,
                    top: 24,
                    bottom: 0,
                    child: Container(
                      width: 2,
                      color: accentColor.withValues(alpha: 0.2),
                    ),
                  ),
                // Step content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.name,
                        style: TextStyle(
                          fontSize: compact ? 12 : 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (step.productName != null && !compact)
                        Text(
                          step.productName!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                    ],
                  ),
                ),
                // Category badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(step.category).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    step.category,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: _getCategoryColor(step.category),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        if (hasMore)
          Padding(
            padding: const EdgeInsets.only(left: 34),
            child: Text(
              '+${steps.length - displaySteps.length} more steps',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
              ),
            ),
          ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'cleanse':
        return const Color(0xFF7EC8E3);
      case 'tone':
        return const Color(0xFF9B7EDE);
      case 'treat':
        return const Color(0xFFFF9F7C);
      case 'moisturize':
        return const Color(0xFF6BCB77);
      case 'protect':
        return const Color(0xFFFFB347);
      default:
        return const Color(0xFFE08A9D);
    }
  }
}

/// Journey card showing skin progress over time
class SkinJourneyCard extends StatelessWidget {
  const SkinJourneyCard({
    super.key,
    required this.entries,
    this.onTap,
    this.onViewAll,
  });

  final List<JourneyEntry> entries;
  final VoidCallback? onTap;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFF3E5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                        ),
                      ),
                      child: const Icon(
                        Icons.trending_up_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Skin Journey',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        Text(
                          '${entries.length} milestones',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                TextButton(
                  onPressed: onViewAll,
                  child: const Text('View all'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.l),
            // Timeline
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: entries.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.m),
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return _JourneyThumbnail(entry: entry);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JourneyEntry {
  const JourneyEntry({
    required this.id,
    required this.date,
    required this.score,
    this.imageUrl,
    this.note,
  });

  final String id;
  final DateTime date;
  final int score;
  final String? imageUrl;
  final String? note;
}

class _JourneyThumbnail extends StatelessWidget {
  const _JourneyThumbnail({required this.entry});

  final JourneyEntry entry;

  @override
  Widget build(BuildContext context) {
    final scoreColor = entry.score >= 80
        ? AppColors.success
        : entry.score >= 60
            ? AppColors.warning
            : AppColors.danger;

    return Column(
      children: [
        // Image
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.m),
            border: Border.all(color: scoreColor, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.m - 2),
            child: entry.imageUrl != null
                ? Image.network(
                    entry.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.chipBg,
                      child: const Icon(Icons.face_outlined,
                          color: AppColors.textTertiary),
                    ),
                  )
                : Container(
                    color: AppColors.chipBg,
                    child: const Icon(Icons.face_outlined,
                        color: AppColors.textTertiary),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        // Score
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: scoreColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Text(
            '${entry.score}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: scoreColor,
            ),
          ),
        ),
        // Date
        Text(
          '${entry.date.day}/${entry.date.month}',
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
