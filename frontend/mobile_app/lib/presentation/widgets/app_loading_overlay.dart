// lib/presentation/widgets/app_loading_overlay.dart

import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';

class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    super.key,
    required this.visible,
    this.message = 'Đang xử lý...',
  });

  final bool visible;
  final String message;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        child: Container(
          color: AppColors.surface.withValues(alpha: 0.9),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 54,
                height: 54,
                child: CircularProgressIndicator(strokeWidth: 4),
              ),
              const SizedBox(height: AppSpacing.m),
              Text(
                message,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
