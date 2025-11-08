import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/core/constants/app_assets.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.size = 48,
    this.compact = false,
  });

  final double size;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final image = compact ? AppAssets.logoMark : AppAssets.logoFull;

    return Image.asset(
      image,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(size / 3),
        ),
        alignment: Alignment.center,
        child: Text(
          'HZ',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
