import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/core/utils/haptics.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'package:ai_skincare_platform/presentation/widgets/routine/routine_step_card.dart';

/// Complete routine timeline view with steps and progress
class RoutineTimelineView extends StatefulWidget {
  const RoutineTimelineView({
    super.key,
    required this.steps,
    this.onStepTap,
    this.onStepComplete,
    this.onReorder,
    this.activeStepIndex,
    this.showProgress = true,
    this.allowReorder = false,
  });

  final List<RoutineStep> steps;
  final ValueChanged<RoutineStep>? onStepTap;
  final ValueChanged<RoutineStep>? onStepComplete;
  final void Function(int oldIndex, int newIndex)? onReorder;
  final int? activeStepIndex;
  final bool showProgress;
  final bool allowReorder;

  @override
  State<RoutineTimelineView> createState() => _RoutineTimelineViewState();
}

class _RoutineTimelineViewState extends State<RoutineTimelineView> {
  int get completedCount => widget.steps.where((s) => s.isCompleted).length;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress bar at top
        if (widget.showProgress) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.m),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '$completedCount/${widget.steps.length}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(
                            begin: 0,
                            end: widget.steps.isEmpty
                                ? 0
                                : completedCount / widget.steps.length,
                          ),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return LinearProgressIndicator(
                              value: value,
                              backgroundColor:
                                  AppColors.primary.withValues(alpha: 0.12),
                              valueColor: const AlwaysStoppedAnimation(
                                  AppColors.primary),
                              minHeight: 8,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (completedCount == widget.steps.length &&
                    widget.steps.isNotEmpty) ...[
                  const SizedBox(width: AppSpacing.m),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success.withValues(alpha: 0.15),
                    ),
                    child: const Icon(
                      Icons.celebration_rounded,
                      color: AppColors.success,
                      size: 20,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
        // Steps list
        Expanded(
          child: widget.allowReorder
              ? ReorderableListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  itemCount: widget.steps.length,
                  onReorder: (oldIndex, newIndex) {
                    Haptics.medium();
                    widget.onReorder?.call(oldIndex, newIndex);
                  },
                  proxyDecorator: (child, index, animation) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        final scale = Tween<double>(begin: 1, end: 1.03)
                            .evaluate(animation);
                        return Transform.scale(
                          scale: scale,
                          child: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(AppRadius.l),
                            shadowColor:
                                AppColors.primary.withValues(alpha: 0.3),
                            child: child,
                          ),
                        );
                      },
                      child: child,
                    );
                  },
                  itemBuilder: (context, index) {
                    final step = widget.steps[index];
                    return RoutineStepCard(
                      key: ValueKey(step.id),
                      step: step,
                      isActive: widget.activeStepIndex == index,
                      isLast: index == widget.steps.length - 1,
                      onTap: () => widget.onStepTap?.call(step),
                      onComplete: () {
                        Haptics.success();
                        widget.onStepComplete?.call(step);
                      },
                    );
                  },
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  itemCount: widget.steps.length,
                  itemBuilder: (context, index) {
                    final step = widget.steps[index];
                    return RoutineStepCard(
                      step: step,
                      isActive: widget.activeStepIndex == index,
                      isLast: index == widget.steps.length - 1,
                      onTap: () => widget.onStepTap?.call(step),
                      onComplete: () {
                        Haptics.success();
                        widget.onStepComplete?.call(step);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Interactive routine walkthrough mode
class RoutineWalkthrough extends StatefulWidget {
  const RoutineWalkthrough({
    super.key,
    required this.steps,
    this.onComplete,
    this.onExit,
  });

  final List<RoutineStep> steps;
  final VoidCallback? onComplete;
  final VoidCallback? onExit;

  @override
  State<RoutineWalkthrough> createState() => _RoutineWalkthroughState();
}

class _RoutineWalkthroughState extends State<RoutineWalkthrough> {
  int _currentIndex = 0;
  final Set<int> _completed = {};

  RoutineStep get currentStep => widget.steps[_currentIndex];
  bool get isLastStep => _currentIndex == widget.steps.length - 1;
  bool get isComplete => _completed.length == widget.steps.length;

  void _markComplete() {
    Haptics.success();
    setState(() {
      _completed.add(_currentIndex);
      if (!isLastStep) {
        _currentIndex++;
      } else if (isComplete) {
        widget.onComplete?.call();
      }
    });
  }

  void _skip() {
    if (!isLastStep) {
      setState(() => _currentIndex++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryData = _getCategoryData(currentStep.category);

    return Column(
      children: [
        // Progress dots
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.m,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.steps.length, (index) {
              final isActive = index == _currentIndex;
              final isDone = _completed.contains(index);
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isActive ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isDone
                      ? AppColors.success
                      : isActive
                          ? categoryData['color'] as Color
                          : AppColors.chipBg,
                ),
              );
            }),
          ),
        ),
        // Current step card
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _WalkthroughCard(
                key: ValueKey(currentStep.id),
                step: currentStep,
                stepNumber: _currentIndex + 1,
                totalSteps: widget.steps.length,
              ),
            ),
          ),
        ),
        // Action buttons
        Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Row(
            children: [
              if (currentStep.isOptional)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _skip,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.l),
                      ),
                    ),
                    child: const Text('Skip'),
                  ),
                ),
              if (currentStep.isOptional) const SizedBox(width: AppSpacing.m),
              Expanded(
                flex: currentStep.isOptional ? 2 : 1,
                child: ElevatedButton(
                  onPressed: _markComplete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: categoryData['color'] as Color,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.l),
                    ),
                  ),
                  child: Text(
                    _completed.contains(_currentIndex)
                        ? isLastStep
                            ? 'Finish'
                            : 'Next'
                        : 'Done',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WalkthroughCard extends StatelessWidget {
  const _WalkthroughCard({
    super.key,
    required this.step,
    required this.stepNumber,
    required this.totalSteps,
  });

  final RoutineStep step;
  final int stepNumber;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final categoryData = _getCategoryData(step.category);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (categoryData['color'] as Color).withValues(alpha: 0.08),
            (categoryData['color'] as Color).withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: (categoryData['color'] as Color).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Step indicator
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  categoryData['color'] as Color,
                  (categoryData['color'] as Color).withValues(alpha: 0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      (categoryData['color'] as Color).withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              categoryData['icon'] as IconData,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Category label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: (categoryData['color'] as Color).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              categoryData['label'] as String,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: categoryData['color'] as Color,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          // Step name
          Text(
            step.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
            textAlign: TextAlign.center,
          ),
          if (step.productName != null) ...[
            const SizedBox(height: AppSpacing.m),
            Text(
              step.productName!,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (step.instructions != null) ...[
            const SizedBox(height: AppSpacing.l),
            Container(
              padding: const EdgeInsets.all(AppSpacing.m),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.m),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 20,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: AppSpacing.s),
                  Expanded(
                    child: Text(
                      step.instructions!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (step.duration != null) ...[
            const SizedBox(height: AppSpacing.l),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.timer_outlined,
                  size: 18,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${step.duration!.inSeconds}s wait time',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

Map<String, dynamic> _getCategoryData(RoutineCategory category) {
  switch (category) {
    case RoutineCategory.cleanse:
      return {
        'label': 'Cleanse',
        'icon': Icons.water_drop_outlined,
        'color': const Color(0xFF7EC8E3),
      };
    case RoutineCategory.tone:
      return {
        'label': 'Tone',
        'icon': Icons.spa_outlined,
        'color': const Color(0xFF9B7EDE),
      };
    case RoutineCategory.treat:
      return {
        'label': 'Treat',
        'icon': Icons.auto_fix_high_rounded,
        'color': const Color(0xFFFF9F7C),
      };
    case RoutineCategory.moisturize:
      return {
        'label': 'Moisturize',
        'icon': Icons.water_outlined,
        'color': const Color(0xFF6BCB77),
      };
    case RoutineCategory.protect:
      return {
        'label': 'Protect',
        'icon': Icons.shield_outlined,
        'color': const Color(0xFFFFB347),
      };
    case RoutineCategory.special:
      return {
        'label': 'Special',
        'icon': Icons.stars_rounded,
        'color': const Color(0xFFE08A9D),
      };
  }
}
