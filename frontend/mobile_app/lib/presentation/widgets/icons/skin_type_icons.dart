import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';

/// Enum representing different skin types for skincare analysis
enum SkinType {
  oily,
  dry,
  combination,
  sensitive,
  normal,
}

/// Premium skin type icon widget with beautiful gradients and animations
class SkinTypeIcon extends StatelessWidget {
  const SkinTypeIcon({
    super.key,
    required this.type,
    this.size = 56,
    this.selected = false,
    this.onTap,
    this.showLabel = true,
  });

  final SkinType type;
  final double size;
  final bool selected;
  final VoidCallback? onTap;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final data = _skinTypeData[type]!;
    final iconSize = size * 0.45;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: selected
                      ? [data.primaryColor, data.secondaryColor]
                      : [
                          data.primaryColor.withValues(alpha: 0.15),
                          data.secondaryColor.withValues(alpha: 0.15),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: selected
                      ? data.primaryColor
                      : data.primaryColor.withValues(alpha: 0.3),
                  width: selected ? 2.5 : 1.5,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: data.primaryColor.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glow effect when selected
                  if (selected)
                    Container(
                      width: size * 0.7,
                      height: size * 0.7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  // Main icon
                  Icon(
                    data.icon,
                    size: iconSize,
                    color: selected ? Colors.white : data.primaryColor,
                  ),
                  // Small indicator dot
                  Positioned(
                    right: size * 0.12,
                    top: size * 0.12,
                    child: AnimatedOpacity(
                      opacity: selected ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 150),
                      child: Container(
                        width: size * 0.18,
                        height: size * 0.18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: data.primaryColor,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.check,
                          size: size * 0.12,
                          color: data.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showLabel) ...[
              SizedBox(height: size * 0.15),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: TextStyle(
                  fontSize: size * 0.22,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? data.primaryColor : AppColors.textSecondary,
                ),
                child: Text(data.label),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A row of skin type icons for selection
class SkinTypeSelector extends StatelessWidget {
  const SkinTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
    this.iconSize = 56,
  });

  final SkinType? selectedType;
  final ValueChanged<SkinType> onChanged;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      child: Row(
        children: SkinType.values.map((type) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
            child: SkinTypeIcon(
              type: type,
              size: iconSize,
              selected: selectedType == type,
              onTap: () => onChanged(type),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Compact skin type badge for display in cards
class SkinTypeBadge extends StatelessWidget {
  const SkinTypeBadge({
    super.key,
    required this.type,
    this.compact = false,
  });

  final SkinType type;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final data = _skinTypeData[type]!;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.s : AppSpacing.m,
        vertical: compact ? AppSpacing.xs : AppSpacing.s,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            data.primaryColor.withValues(alpha: 0.15),
            data.secondaryColor.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: data.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            data.icon,
            size: compact ? 14 : 18,
            color: data.primaryColor,
          ),
          SizedBox(width: compact ? AppSpacing.xs : AppSpacing.s),
          Text(
            data.label,
            style: TextStyle(
              fontSize: compact ? 11 : 13,
              fontWeight: FontWeight.w600,
              color: data.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Data class for skin type styling
class _SkinTypeData {
  const _SkinTypeData({
    required this.label,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.description,
  });

  final String label;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final String description;
}

const _skinTypeData = <SkinType, _SkinTypeData>{
  SkinType.oily: _SkinTypeData(
    label: 'Oily',
    icon: Icons.water_drop_rounded,
    primaryColor: Color(0xFF4ECDC4),
    secondaryColor: Color(0xFF7FE7DC),
    description: 'Excess sebum production, shiny appearance',
  ),
  SkinType.dry: _SkinTypeData(
    label: 'Dry',
    icon: Icons.grain_rounded,
    primaryColor: Color(0xFFE88D67),
    secondaryColor: Color(0xFFF5B89A),
    description: 'Tight feeling, flaky patches, fine lines',
  ),
  SkinType.combination: _SkinTypeData(
    label: 'Combo',
    icon: Icons.contrast_rounded,
    primaryColor: Color(0xFF9B7EDE),
    secondaryColor: Color(0xFFC4B3F0),
    description: 'Oily T-zone with dry cheeks',
  ),
  SkinType.sensitive: _SkinTypeData(
    label: 'Sensitive',
    icon: Icons.favorite_rounded,
    primaryColor: Color(0xFFE08A9D),
    secondaryColor: Color(0xFFF0B5C2),
    description: 'Easily irritated, prone to redness',
  ),
  SkinType.normal: _SkinTypeData(
    label: 'Normal',
    icon: Icons.check_circle_rounded,
    primaryColor: Color(0xFF6BCB77),
    secondaryColor: Color(0xFFA8E6CF),
    description: 'Balanced, minimal concerns',
  ),
};

/// Extension to get skin type data
extension SkinTypeExtension on SkinType {
  String get label => _skinTypeData[this]!.label;
  IconData get icon => _skinTypeData[this]!.icon;
  Color get primaryColor => _skinTypeData[this]!.primaryColor;
  Color get secondaryColor => _skinTypeData[this]!.secondaryColor;
  String get description => _skinTypeData[this]!.description;
}
