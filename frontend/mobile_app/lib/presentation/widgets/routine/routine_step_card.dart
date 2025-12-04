import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';

/// Represents a single step in a skincare routine
class RoutineStep {
  const RoutineStep({
    required this.id,
    required this.order,
    required this.name,
    required this.category,
    this.productName,
    this.productImageUrl,
    this.duration,
    this.instructions,
    this.isCompleted = false,
    this.isOptional = false,
  });

  final String id;
  final int order;
  final String name;
  final RoutineCategory category;
  final String? productName;
  final String? productImageUrl;
  final Duration? duration;
  final String? instructions;
  final bool isCompleted;
  final bool isOptional;

  RoutineStep copyWith({
    String? id,
    int? order,
    String? name,
    RoutineCategory? category,
    String? productName,
    String? productImageUrl,
    Duration? duration,
    String? instructions,
    bool? isCompleted,
    bool? isOptional,
  }) {
    return RoutineStep(
      id: id ?? this.id,
      order: order ?? this.order,
      name: name ?? this.name,
      category: category ?? this.category,
      productName: productName ?? this.productName,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      duration: duration ?? this.duration,
      instructions: instructions ?? this.instructions,
      isCompleted: isCompleted ?? this.isCompleted,
      isOptional: isOptional ?? this.isOptional,
    );
  }
}

/// Categories for routine steps
enum RoutineCategory {
  cleanse,
  tone,
  treat,
  moisturize,
  protect,
  special,
}

/// Visual routine step card with animation
class RoutineStepCard extends StatelessWidget {
  const RoutineStepCard({
    super.key,
    required this.step,
    this.onTap,
    this.onComplete,
    this.isActive = false,
    this.showConnector = true,
    this.isLast = false,
  });

  final RoutineStep step;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final bool isActive;
  final bool showConnector;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final categoryData = _categoryData[step.category]!;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline column
          SizedBox(
            width: 56,
            child: Column(
              children: [
                // Step number circle
                GestureDetector(
                  onTap: onComplete,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: step.isCompleted
                          ? LinearGradient(
                              colors: [
                                AppColors.success,
                                AppColors.success.withValues(alpha: 0.8),
                              ],
                            )
                          : isActive
                              ? LinearGradient(
                                  colors: [
                                    categoryData.color,
                                    categoryData.color.withValues(alpha: 0.8),
                                  ],
                                )
                              : null,
                      color: step.isCompleted || isActive
                          ? null
                          : categoryData.color.withValues(alpha: 0.15),
                      border: Border.all(
                        color: step.isCompleted
                            ? AppColors.success
                            : categoryData.color,
                        width: isActive ? 3 : 2,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color:
                                    categoryData.color.withValues(alpha: 0.3),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: step.isCompleted
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: 22)
                          : Text(
                              '${step.order}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: step.isCompleted || isActive
                                    ? Colors.white
                                    : categoryData.color,
                              ),
                            ),
                    ),
                  ),
                ),
                // Connector line
                if (showConnector && !isLast)
                  Expanded(
                    child: Container(
                      width: 2.5,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            categoryData.color.withValues(alpha: 0.4),
                            categoryData.color.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Card content
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.m),
                padding: const EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? LinearGradient(
                          colors: [
                            categoryData.color.withValues(alpha: 0.08),
                            categoryData.color.withValues(alpha: 0.03),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isActive ? null : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.l),
                  border: Border.all(
                    color: isActive
                        ? categoryData.color
                        : step.isCompleted
                            ? AppColors.success.withValues(alpha: 0.3)
                            : AppColors.border,
                    width: isActive ? 1.5 : 1,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: categoryData.color.withValues(alpha: 0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with category and time
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: categoryData.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                categoryData.icon,
                                size: 12,
                                color: categoryData.color,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                categoryData.label,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: categoryData.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (step.isOptional) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.chipBg,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.full),
                            ),
                            child: const Text(
                              'Optional',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (step.duration != null)
                          Text(
                            _formatDuration(step.duration!),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textTertiary,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s),
                    // Step name
                    Text(
                      step.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: step.isCompleted
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        decoration: step.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    // Product info
                    if (step.productName != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (step.productImageUrl != null)
                            Container(
                              width: 36,
                              height: 36,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.chipBg,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  step.productImageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.inventory_2_outlined,
                                    size: 18,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ),
                            ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step.productName!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (step.instructions != null)
                                  Text(
                                    step.instructions!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textTertiary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                        ],
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

  String _formatDuration(Duration duration) {
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes} min';
    }
    return '${duration.inSeconds}s';
  }
}

/// Category data
class _CategoryData {
  const _CategoryData({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

const _categoryData = <RoutineCategory, _CategoryData>{
  RoutineCategory.cleanse: _CategoryData(
    label: 'Cleanse',
    icon: Icons.water_drop_outlined,
    color: Color(0xFF7EC8E3),
  ),
  RoutineCategory.tone: _CategoryData(
    label: 'Tone',
    icon: Icons.spa_outlined,
    color: Color(0xFF9B7EDE),
  ),
  RoutineCategory.treat: _CategoryData(
    label: 'Treat',
    icon: Icons.auto_fix_high_rounded,
    color: Color(0xFFFF9F7C),
  ),
  RoutineCategory.moisturize: _CategoryData(
    label: 'Moisturize',
    icon: Icons.water_outlined,
    color: Color(0xFF6BCB77),
  ),
  RoutineCategory.protect: _CategoryData(
    label: 'Protect',
    icon: Icons.shield_outlined,
    color: Color(0xFFFFB347),
  ),
  RoutineCategory.special: _CategoryData(
    label: 'Special',
    icon: Icons.stars_rounded,
    color: Color(0xFFE08A9D),
  ),
};

extension RoutineCategoryExtension on RoutineCategory {
  String get label => _categoryData[this]!.label;
  IconData get icon => _categoryData[this]!.icon;
  Color get color => _categoryData[this]!.color;
}
