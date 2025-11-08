// lib/presentation/widgets/ui_kit/hz_section_header.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';

class HzSectionHeader extends StatelessWidget {
  const HzSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onActionPressed,
    this.route,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.m),
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final String? route;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onActionPressed ??
                  () {
                    if (route != null) {
                      context.push(route!);
                    }
                  },
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}
