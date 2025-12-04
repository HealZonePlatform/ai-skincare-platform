import 'dart:io';

import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';

/// A visual progress timeline showing skin improvement over time
class ProgressTimeline extends StatelessWidget {
  const ProgressTimeline({
    super.key,
    required this.entries,
    this.onEntryTap,
    this.showConnectors = true,
  });

  final List<TimelineEntry> entries;
  final ValueChanged<TimelineEntry>? onEntryTap;
  final bool showConnectors;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const _EmptyTimeline();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final isFirst = index == 0;
        final isLast = index == entries.length - 1;

        return _TimelineItem(
          entry: entry,
          isFirst: isFirst,
          isLast: isLast,
          showConnectors: showConnectors,
          onTap: onEntryTap != null ? () => onEntryTap!(entry) : null,
        );
      },
    );
  }
}

/// A single timeline entry data
class TimelineEntry {
  const TimelineEntry({
    required this.id,
    required this.date,
    required this.score,
    this.imageUrl,
    this.imagePath,
    this.title,
    this.description,
    this.scoreChange,
    this.tags = const [],
  });

  final String id;
  final DateTime date;
  final int score;
  final String? imageUrl;
  final String? imagePath;
  final String? title;
  final String? description;
  final int? scoreChange; // Positive or negative change from previous
  final List<String> tags;

  String get image => imagePath ?? imageUrl ?? '';
  bool get hasImage => image.isNotEmpty;
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.entry,
    required this.isFirst,
    required this.isLast,
    required this.showConnectors,
    this.onTap,
  });

  final TimelineEntry entry;
  final bool isFirst;
  final bool isLast;
  final bool showConnectors;
  final VoidCallback? onTap;

  Color get _scoreColor {
    if (entry.score >= 80) return AppColors.success;
    if (entry.score >= 60) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator column
          SizedBox(
            width: 60,
            child: Column(
              children: [
                // Top connector
                if (showConnectors && !isFirst)
                  Container(
                    width: 2,
                    height: 20,
                    color: AppColors.border,
                  ),

                // Score circle
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [_scoreColor, _scoreColor.withValues(alpha: 0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _scoreColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${entry.score}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                // Bottom connector
                if (showConnectors && !isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.border,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.m),

          // Content card
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                margin: EdgeInsets.only(
                  top: isFirst ? 0 : AppSpacing.s,
                  bottom: isLast ? 0 : AppSpacing.m,
                ),
                padding: const EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.m),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date and change
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDate(entry.date),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (entry.scoreChange != null)
                          _ScoreChange(change: entry.scoreChange!),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.s),

                    // Title
                    if (entry.title != null)
                      Text(
                        entry.title!,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),

                    // Description
                    if (entry.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        entry.description!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Image thumbnail
                    if (entry.hasImage) ...[
                      const SizedBox(height: AppSpacing.m),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.s),
                        child: SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: _buildImage(entry.image),
                        ),
                      ),
                    ],

                    // Tags
                    if (entry.tags.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.m),
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: entry.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.s,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String source) {
    final isLocal = !source.startsWith('http');
    if (isLocal) {
      return Image.file(
        File(source),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    }
    return Image.network(
      source,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.chipBg,
      child: const Center(
        child: Icon(Icons.image_outlined, color: AppColors.textTertiary),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _ScoreChange extends StatelessWidget {
  const _ScoreChange({required this.change});

  final int change;

  @override
  Widget build(BuildContext context) {
    final isPositive = change > 0;
    final color = isPositive ? AppColors.success : AppColors.danger;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 2),
          Text(
            isPositive ? '+$change' : '$change',
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTimeline extends StatelessWidget {
  const _EmptyTimeline();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.timeline_rounded,
            size: 48,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            'No entries yet',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Your skin progress will appear here',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact horizontal timeline for quick navigation
class HorizontalProgressTimeline extends StatelessWidget {
  const HorizontalProgressTimeline({
    super.key,
    required this.entries,
    this.selectedIndex,
    this.onEntryTap,
    this.height = 80,
  });

  final List<TimelineEntry> entries;
  final int? selectedIndex;
  final ValueChanged<int>? onEntryTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          final isSelected = index == selectedIndex;

          Color scoreColor;
          if (entry.score >= 80) {
            scoreColor = AppColors.success;
          } else if (entry.score >= 60) {
            scoreColor = AppColors.warning;
          } else {
            scoreColor = AppColors.danger;
          }

          return GestureDetector(
            onTap: onEntryTap != null ? () => onEntryTap!(index) : null,
            child: Container(
              margin: const EdgeInsets.only(right: AppSpacing.m),
              child: Column(
                children: [
                  // Score circle
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isSelected ? 52 : 44,
                    height: isSelected ? 52 : 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? scoreColor : scoreColor.withValues(alpha: 0.15),
                      border: Border.all(
                        color: scoreColor,
                        width: isSelected ? 3 : 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.score}',
                        style: TextStyle(
                          color: isSelected ? Colors.white : scoreColor,
                          fontWeight: FontWeight.bold,
                          fontSize: isSelected ? 16 : 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Date
                  Text(
                    '${entry.date.day}/${entry.date.month}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? AppColors.textPrimary : AppColors.textTertiary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
