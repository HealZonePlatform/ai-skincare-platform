// lib/presentation/widgets/ui_kit/hz_surface_card.dart

import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';

class HzSurfaceCard extends StatelessWidget {
  const HzSurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.l),
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.backgroundColor,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.l),
        boxShadow: AppShadows.mild,
      ),
      child: child,
    );

    if (onTap == null) {
      return card;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.l),
      onTap: onTap,
      child: card,
    );
  }
}
