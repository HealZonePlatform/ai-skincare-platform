// lib/presentation/widgets/optimized_network_image.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/presentation/widgets/hz_skeleton.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

class OptimizedNetworkImage extends StatelessWidget {
  const OptimizedNetworkImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.borderRadius = AppRadius.l,
    this.aspectRatio,
  });

  final String imageUrl;
  final double? height;
  final double? width;
  final double borderRadius;
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveWidth = width ?? constraints.maxWidth;
        final ratio = aspectRatio ??
            (effectiveWidth.isFinite
                ? effectiveWidth / (height ?? 200)
                : 16 / 9);
        final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
        final memCacheWidth =
            (effectiveWidth * devicePixelRatio).clamp(480, 2048).round();
        final memCacheHeight = (memCacheWidth / ratio).round();

        final placeholder = AspectRatio(
          aspectRatio: ratio,
          child: const HzSkeleton.rect(),
        );

        final image = CachedNetworkImage(
          imageUrl: imageUrl,
          memCacheWidth: memCacheWidth,
          memCacheHeight: memCacheHeight,
          maxWidthDiskCache: memCacheWidth,
          maxHeightDiskCache: memCacheHeight,
          fadeInDuration: const Duration(milliseconds: 250),
          fadeOutDuration: const Duration(milliseconds: 200),
          fit: BoxFit.cover,
          placeholder: (_, __) => placeholder,
          errorWidget: (_, __, ___) => AspectRatio(
            aspectRatio: ratio,
            child: Container(
              color: Colors.grey.shade100,
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image_outlined,
                  color: AppColors.textTertiary),
            ),
          ),
        );

        if (borderRadius <= 0) {
          return SizedBox(
            height: height,
            width: width,
            child: image,
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: SizedBox(
            height: height,
            width: width,
            child: image,
          ),
        );
      },
    );
  }
}
