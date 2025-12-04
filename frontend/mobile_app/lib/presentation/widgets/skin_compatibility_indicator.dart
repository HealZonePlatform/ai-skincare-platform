import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';

/// Skin compatibility level for products
enum CompatibilityLevel {
  excellent,
  good,
  moderate,
  notRecommended,
}

/// Shows how compatible a product is with user's skin
class SkinCompatibilityIndicator extends StatelessWidget {
  const SkinCompatibilityIndicator({
    super.key,
    required this.level,
    this.showLabel = true,
    this.size = IndicatorSize.medium,
    this.reasons = const [],
  });

  final CompatibilityLevel level;
  final bool showLabel;
  final IndicatorSize size;
  final List<String> reasons;

  @override
  Widget build(BuildContext context) {
    final data = _compatibilityData[level]!;
    final dimensions = _sizeDimensions[size]!;

    return Container(
      padding: EdgeInsets.all(dimensions.padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            data.color.withValues(alpha: 0.12),
            data.color.withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        border: Border.all(
          color: data.color.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Icon with glow
              Container(
                width: dimensions.iconContainerSize,
                height: dimensions.iconContainerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: data.color.withValues(alpha: 0.15),
                  boxShadow: [
                    BoxShadow(
                      color: data.color.withValues(alpha: 0.2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  data.icon,
                  size: dimensions.iconSize,
                  color: data.color,
                ),
              ),
              SizedBox(width: dimensions.spacing),
              // Label and score
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.label,
                      style: TextStyle(
                        fontSize: dimensions.labelFontSize,
                        fontWeight: FontWeight.w700,
                        color: data.color,
                      ),
                    ),
                    if (showLabel)
                      Text(
                        data.description,
                        style: TextStyle(
                          fontSize: dimensions.descFontSize,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              // Match percentage
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: data.color,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '${data.matchPercent}%',
                  style: TextStyle(
                    fontSize: dimensions.descFontSize,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          // Reasons
          if (reasons.isNotEmpty) ...[
            SizedBox(height: dimensions.spacing),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: reasons.map((reason) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: data.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 12, color: data.color),
                      const SizedBox(width: 4),
                      Text(
                        reason,
                        style: TextStyle(
                          fontSize: 11,
                          color: data.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Compact compatibility badge for product cards
class CompatibilityBadge extends StatelessWidget {
  const CompatibilityBadge({
    super.key,
    required this.level,
    this.compact = false,
  });

  final CompatibilityLevel level;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final data = _compatibilityData[level]!;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: data.color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            data.icon,
            size: compact ? 12 : 16,
            color: data.color,
          ),
          SizedBox(width: compact ? 3 : 5),
          Text(
            '${data.matchPercent}% Match',
            style: TextStyle(
              fontSize: compact ? 10 : 12,
              fontWeight: FontWeight.w600,
              color: data.color,
            ),
          ),
        ],
      ),
    );
  }
}

enum IndicatorSize { small, medium, large }

class _SizeDimensions {
  const _SizeDimensions({
    required this.padding,
    required this.iconContainerSize,
    required this.iconSize,
    required this.spacing,
    required this.labelFontSize,
    required this.descFontSize,
    required this.borderRadius,
  });

  final double padding;
  final double iconContainerSize;
  final double iconSize;
  final double spacing;
  final double labelFontSize;
  final double descFontSize;
  final double borderRadius;
}

const _sizeDimensions = <IndicatorSize, _SizeDimensions>{
  IndicatorSize.small: _SizeDimensions(
    padding: 10,
    iconContainerSize: 32,
    iconSize: 18,
    spacing: 10,
    labelFontSize: 13,
    descFontSize: 11,
    borderRadius: 12,
  ),
  IndicatorSize.medium: _SizeDimensions(
    padding: 14,
    iconContainerSize: 40,
    iconSize: 22,
    spacing: 12,
    labelFontSize: 15,
    descFontSize: 12,
    borderRadius: 14,
  ),
  IndicatorSize.large: _SizeDimensions(
    padding: 18,
    iconContainerSize: 48,
    iconSize: 26,
    spacing: 14,
    labelFontSize: 17,
    descFontSize: 13,
    borderRadius: 16,
  ),
};

class _CompatibilityData {
  const _CompatibilityData({
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    required this.matchPercent,
  });

  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final int matchPercent;
}

const _compatibilityData = <CompatibilityLevel, _CompatibilityData>{
  CompatibilityLevel.excellent: _CompatibilityData(
    label: 'Excellent Match',
    description: 'Perfect for your skin type',
    icon: Icons.verified_rounded,
    color: Color(0xFF10B981),
    matchPercent: 95,
  ),
  CompatibilityLevel.good: _CompatibilityData(
    label: 'Good Match',
    description: 'Suitable for your skin',
    icon: Icons.thumb_up_rounded,
    color: Color(0xFF3B82F6),
    matchPercent: 80,
  ),
  CompatibilityLevel.moderate: _CompatibilityData(
    label: 'Moderate',
    description: 'May work with patch test',
    icon: Icons.info_outline_rounded,
    color: Color(0xFFF59E0B),
    matchPercent: 60,
  ),
  CompatibilityLevel.notRecommended: _CompatibilityData(
    label: 'Not Recommended',
    description: 'May irritate your skin',
    icon: Icons.warning_amber_rounded,
    color: Color(0xFFEF4444),
    matchPercent: 30,
  ),
};

/// Extension for compatibility level
extension CompatibilityLevelExtension on CompatibilityLevel {
  String get label => _compatibilityData[this]!.label;
  String get description => _compatibilityData[this]!.description;
  IconData get icon => _compatibilityData[this]!.icon;
  Color get color => _compatibilityData[this]!.color;
  int get matchPercent => _compatibilityData[this]!.matchPercent;
}
