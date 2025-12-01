import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';

class RequirementItem {
  const RequirementItem({required this.label, required this.met});

  final String label;
  final bool met;
}

class RequirementChecklist extends StatelessWidget {
  const RequirementChecklist({
    super.key,
    required this.items,
    this.spacing = AppSpacing.xs,
  });

  final List<RequirementItem> items;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: spacing),
              child: Row(
                children: [
                  Icon(
                    item.met
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 18,
                    color: item.met ? AppColors.success : AppColors.textTertiary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      item.label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: item.met
                            ? AppColors.textSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
