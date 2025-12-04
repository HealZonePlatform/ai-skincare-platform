import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/core/utils/haptics.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'illustrations/skincare_illustration.dart';

export 'illustrations/skincare_illustration.dart';

class IllustratedMessage extends StatelessWidget {
  const IllustratedMessage({
    super.key,
    this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.accent,
    this.illustration,
    this.illustrationSize = 220,
  }) : assert(
          icon != null || illustration != null,
          'Provide an icon or an illustration to render',
        );

  final IconData? icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? accent;
  final IllustrationType? illustration;
  final double illustrationSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = accent ?? AppColors.primary;
    final visual = illustration != null
        ? SkincareIllustration(
            type: illustration!,
            size: illustrationSize,
          )
        : _IconOrb(
            icon: icon!,
            accentColor: accentColor,
          );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFF3F8),
            Color(0xFFE7F5F1),
            Color(0xFFFDF7FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          visual,
          const SizedBox(height: AppSpacing.m),
          Text(
            title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            message,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: AppColors.textSecondary, height: 1.4),
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.l),
            FilledButton.icon(
              onPressed: () async {
                await Haptics.selection();
                onAction?.call();
              },
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

class _IconOrb extends StatelessWidget {
  const _IconOrb({
    required this.icon,
    required this.accentColor,
  });

  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.75),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.16),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(icon, size: 48, color: accentColor),
    );
  }
}
