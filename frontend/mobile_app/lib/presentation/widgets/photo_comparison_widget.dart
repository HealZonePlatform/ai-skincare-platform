import 'dart:io';

import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';

/// A premium before/after photo comparison widget with interactive slider
class PhotoComparisonWidget extends StatefulWidget {
  const PhotoComparisonWidget({
    super.key,
    required this.beforeImage,
    required this.afterImage,
    this.beforeLabel = 'Before',
    this.afterLabel = 'After',
    this.height = 300,
    this.borderRadius = AppRadius.l,
    this.initialPosition = 0.5,
    this.showLabels = true,
    this.showDates = false,
    this.beforeDate,
    this.afterDate,
  });

  /// Image source - can be URL or file path
  final String beforeImage;
  final String afterImage;
  final String beforeLabel;
  final String afterLabel;
  final double height;
  final double borderRadius;
  final double initialPosition;
  final bool showLabels;
  final bool showDates;
  final DateTime? beforeDate;
  final DateTime? afterDate;

  @override
  State<PhotoComparisonWidget> createState() => _PhotoComparisonWidgetState();
}

class _PhotoComparisonWidgetState extends State<PhotoComparisonWidget>
    with SingleTickerProviderStateMixin {
  late double _sliderPosition;
  late AnimationController _pulseController;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _sliderPosition = widget.initialPosition;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildImage(String source, BoxFit fit) {
    final isLocal = !source.startsWith('http');
    if (isLocal) {
      return Image.file(
        File(source),
        fit: fit,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    }
    return Image.network(
      source,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingPlaceholder(loadingProgress);
      },
      errorBuilder: (_, __, ___) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Icon(Icons.image_not_supported_outlined, size: 48),
      ),
    );
  }

  Widget _buildLoadingPlaceholder(ImageChunkEvent progress) {
    final value = progress.expectedTotalBytes != null
        ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
        : null;
    return Container(
      color: AppColors.surface,
      child: Center(
        child: CircularProgressIndicator(
          value: value,
          strokeWidth: 2,
          color: AppColors.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main comparison view
        ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final dividerX = width * _sliderPosition;

                return GestureDetector(
                  onHorizontalDragStart: (_) {
                    setState(() => _isDragging = true);
                  },
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _sliderPosition =
                          (details.localPosition.dx / width).clamp(0.05, 0.95);
                    });
                  },
                  onHorizontalDragEnd: (_) {
                    setState(() => _isDragging = false);
                  },
                  child: Stack(
                    children: [
                      // After image (full width background)
                      Positioned.fill(
                        child: _buildImage(widget.afterImage, BoxFit.cover),
                      ),

                      // Before image (clipped)
                      Positioned.fill(
                        child: ClipRect(
                          clipper: _ImageClipper(dividerX),
                          child: _buildImage(widget.beforeImage, BoxFit.cover),
                        ),
                      ),

                      // Labels
                      if (widget.showLabels) ...[
                        // Before label
                        Positioned(
                          left: AppSpacing.m,
                          top: AppSpacing.m,
                          child: _buildLabel(
                            widget.beforeLabel,
                            widget.beforeDate,
                            isVisible: _sliderPosition > 0.15,
                          ),
                        ),
                        // After label
                        Positioned(
                          right: AppSpacing.m,
                          top: AppSpacing.m,
                          child: _buildLabel(
                            widget.afterLabel,
                            widget.afterDate,
                            isVisible: _sliderPosition < 0.85,
                          ),
                        ),
                      ],

                      // Divider line
                      Positioned(
                        left: dividerX - 1.5,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 3,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Slider handle
                      Positioned(
                        left: dividerX - 24,
                        top: widget.height / 2 - 24,
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            final scale = _isDragging
                                ? 1.1
                                : 1.0 + (_pulseController.value * 0.05);
                            return Transform.scale(
                              scale: scale,
                              child: child,
                            );
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                              border: Border.all(
                                color: AppColors.primary,
                                width: 3,
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chevron_left,
                                    size: 18, color: AppColors.primary),
                                Icon(Icons.chevron_right,
                                    size: 18, color: AppColors.primary),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        // Instruction hint
        const SizedBox(height: AppSpacing.m),
        const Center(
          child: Text(
            'Drag slider to compare',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String label, DateTime? date, {required bool isVisible}) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 150),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            if (date != null && widget.showDates)
              Text(
                _formatDate(date),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 11,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Custom clipper for the before image
class _ImageClipper extends CustomClipper<Rect> {
  _ImageClipper(this.dividerX);

  final double dividerX;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, dividerX, size.height);
  }

  @override
  bool shouldReclip(_ImageClipper oldClipper) {
    return oldClipper.dividerX != dividerX;
  }
}

/// Side-by-side comparison view (alternative layout)
class SideBySideComparison extends StatelessWidget {
  const SideBySideComparison({
    super.key,
    required this.beforeImage,
    required this.afterImage,
    this.beforeLabel = 'Before',
    this.afterLabel = 'After',
    this.height = 200,
    this.beforeDate,
    this.afterDate,
  });

  final String beforeImage;
  final String afterImage;
  final String beforeLabel;
  final String afterLabel;
  final double height;
  final DateTime? beforeDate;
  final DateTime? afterDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ComparisonCard(
            image: beforeImage,
            label: beforeLabel,
            date: beforeDate,
            height: height,
          ),
        ),
        const SizedBox(width: AppSpacing.m),
        Expanded(
          child: _ComparisonCard(
            image: afterImage,
            label: afterLabel,
            date: afterDate,
            height: height,
            isAfter: true,
          ),
        ),
      ],
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({
    required this.image,
    required this.label,
    required this.height,
    this.date,
    this.isAfter = false,
  });

  final String image;
  final String label;
  final double height;
  final DateTime? date;
  final bool isAfter;

  @override
  Widget build(BuildContext context) {
    final color = isAfter ? AppColors.success : AppColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.m),
          child: Stack(
            children: [
              SizedBox(
                height: height,
                width: double.infinity,
                child: _buildImage(image),
              ),
              Positioned(
                left: AppSpacing.s,
                top: AppSpacing.s,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(AppRadius.s),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (date != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${date!.day}/${date!.month}/${date!.year}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ],
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
      color: AppColors.surface,
      child: const Center(
        child:
            Icon(Icons.image_outlined, size: 32, color: AppColors.textTertiary),
      ),
    );
  }
}

/// Compact comparison thumbnail for lists
class ComparisonThumbnail extends StatelessWidget {
  const ComparisonThumbnail({
    super.key,
    required this.beforeImage,
    required this.afterImage,
    this.size = 80,
    this.onTap,
  });

  final String beforeImage;
  final String afterImage;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size * 1.8,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.m),
          border: Border.all(color: AppColors.border),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.m - 1),
          child: Row(
            children: [
              Expanded(child: _buildThumbnail(beforeImage)),
              Container(
                width: 2,
                color: Colors.white,
              ),
              Expanded(child: _buildThumbnail(afterImage)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(String source) {
    final isLocal = !source.startsWith('http');
    if (isLocal) {
      return Image.file(
        File(source),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(color: AppColors.surface),
      );
    }
    return Image.network(
      source,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(color: AppColors.surface),
    );
  }
}
