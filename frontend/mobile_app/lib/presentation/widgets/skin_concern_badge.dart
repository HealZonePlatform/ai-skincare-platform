import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';

/// Enum representing common skin concerns
enum SkinConcern {
  acne,
  wrinkles,
  darkSpots,
  dullness,
  dryness,
  oiliness,
  redness,
  sensitivity,
  pores,
  darkCircles,
  finelines,
  texture,
  unevenTone,
  sagging,
  dehydration,
}

/// Premium skin concern badge with icon and gradient styling
class SkinConcernBadge extends StatelessWidget {
  const SkinConcernBadge({
    super.key,
    required this.concern,
    this.size = BadgeSize.medium,
    this.selected = false,
    this.onTap,
    this.showIcon = true,
  });

  final SkinConcern concern;
  final BadgeSize size;
  final bool selected;
  final VoidCallback? onTap;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final data = _concernData[concern]!;
    final dimensions = _badgeDimensions[size]!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: dimensions.horizontalPadding,
          vertical: dimensions.verticalPadding,
        ),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  colors: [data.color, data.color.withValues(alpha: 0.85)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: selected ? null : data.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: selected ? data.color : data.color.withValues(alpha: 0.3),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: data.color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(
                data.icon,
                size: dimensions.iconSize,
                color: selected ? Colors.white : data.color,
              ),
              SizedBox(width: dimensions.spacing),
            ],
            Text(
              data.label,
              style: TextStyle(
                fontSize: dimensions.fontSize,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : data.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Badge size variants
enum BadgeSize { small, medium, large }

class _BadgeDimensions {
  const _BadgeDimensions({
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.iconSize,
    required this.fontSize,
    required this.spacing,
  });

  final double horizontalPadding;
  final double verticalPadding;
  final double iconSize;
  final double fontSize;
  final double spacing;
}

const _badgeDimensions = <BadgeSize, _BadgeDimensions>{
  BadgeSize.small: _BadgeDimensions(
    horizontalPadding: 8,
    verticalPadding: 4,
    iconSize: 12,
    fontSize: 11,
    spacing: 4,
  ),
  BadgeSize.medium: _BadgeDimensions(
    horizontalPadding: 12,
    verticalPadding: 6,
    iconSize: 16,
    fontSize: 13,
    spacing: 6,
  ),
  BadgeSize.large: _BadgeDimensions(
    horizontalPadding: 16,
    verticalPadding: 8,
    iconSize: 20,
    fontSize: 15,
    spacing: 8,
  ),
};

/// Multi-select skin concern selector
class SkinConcernSelector extends StatelessWidget {
  const SkinConcernSelector({
    super.key,
    required this.selectedConcerns,
    required this.onChanged,
    this.badgeSize = BadgeSize.medium,
    this.maxSelection,
  });

  final Set<SkinConcern> selectedConcerns;
  final ValueChanged<Set<SkinConcern>> onChanged;
  final BadgeSize badgeSize;
  final int? maxSelection;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s,
      runSpacing: AppSpacing.s,
      children: SkinConcern.values.map((concern) {
        final isSelected = selectedConcerns.contains(concern);
        final canSelect = maxSelection == null ||
            selectedConcerns.length < maxSelection! ||
            isSelected;

        return Opacity(
          opacity: canSelect ? 1.0 : 0.5,
          child: SkinConcernBadge(
            concern: concern,
            size: badgeSize,
            selected: isSelected,
            onTap: canSelect
                ? () {
                    final newSelection =
                        Set<SkinConcern>.from(selectedConcerns);
                    if (isSelected) {
                      newSelection.remove(concern);
                    } else {
                      newSelection.add(concern);
                    }
                    onChanged(newSelection);
                  }
                : null,
          ),
        );
      }).toList(),
    );
  }
}

/// Skin concern indicator with severity level
class SkinConcernIndicator extends StatelessWidget {
  const SkinConcernIndicator({
    super.key,
    required this.concern,
    required this.severity,
    this.showLabel = true,
  });

  final SkinConcern concern;
  final double severity; // 0.0 to 1.0
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final data = _concernData[concern]!;
    final severityColor = _getSeverityColor(severity);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.m),
        border: Border.all(
          color: data.color.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: data.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.s),
                ),
                child: Icon(
                  data.icon,
                  size: 20,
                  color: data.color,
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.label,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    if (showLabel)
                      Text(
                        _getSeverityLabel(severity),
                        style: TextStyle(
                          fontSize: 12,
                          color: severityColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                '${(severity * 100).round()}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: severityColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: severity,
              backgroundColor: data.color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(severityColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(double severity) {
    if (severity < 0.3) return AppColors.success;
    if (severity < 0.6) return AppColors.warning;
    return AppColors.danger;
  }

  String _getSeverityLabel(double severity) {
    if (severity < 0.3) return 'Low concern';
    if (severity < 0.6) return 'Moderate';
    return 'Needs attention';
  }
}

/// Summary card showing multiple concerns
class SkinConcernSummary extends StatelessWidget {
  const SkinConcernSummary({
    super.key,
    required this.concerns,
  });

  final Map<SkinConcern, double> concerns;

  @override
  Widget build(BuildContext context) {
    final sorted = concerns.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: sorted.take(5).map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.m),
          child: SkinConcernIndicator(
            concern: entry.key,
            severity: entry.value,
          ),
        );
      }).toList(),
    );
  }
}

/// Data class for concern styling
class _ConcernData {
  const _ConcernData({
    required this.label,
    required this.icon,
    required this.color,
    required this.description,
  });

  final String label;
  final IconData icon;
  final Color color;
  final String description;
}

const _concernData = <SkinConcern, _ConcernData>{
  SkinConcern.acne: _ConcernData(
    label: 'Acne',
    icon: Icons.bubble_chart_rounded,
    color: Color(0xFFE74C3C),
    description: 'Breakouts, pimples, and blemishes',
  ),
  SkinConcern.wrinkles: _ConcernData(
    label: 'Wrinkles',
    icon: Icons.waves_rounded,
    color: Color(0xFF9B59B6),
    description: 'Deep lines and creases',
  ),
  SkinConcern.darkSpots: _ConcernData(
    label: 'Dark Spots',
    icon: Icons.brightness_2_rounded,
    color: Color(0xFF8D6E63),
    description: 'Hyperpigmentation and sun damage',
  ),
  SkinConcern.dullness: _ConcernData(
    label: 'Dullness',
    icon: Icons.wb_twilight_rounded,
    color: Color(0xFF607D8B),
    description: 'Lack of radiance and glow',
  ),
  SkinConcern.dryness: _ConcernData(
    label: 'Dryness',
    icon: Icons.grain_rounded,
    color: Color(0xFFE88D67),
    description: 'Flaky, tight, dehydrated skin',
  ),
  SkinConcern.oiliness: _ConcernData(
    label: 'Oiliness',
    icon: Icons.water_drop_rounded,
    color: Color(0xFF4ECDC4),
    description: 'Excess sebum and shine',
  ),
  SkinConcern.redness: _ConcernData(
    label: 'Redness',
    icon: Icons.local_fire_department_rounded,
    color: Color(0xFFFF6B6B),
    description: 'Inflammation and irritation',
  ),
  SkinConcern.sensitivity: _ConcernData(
    label: 'Sensitivity',
    icon: Icons.favorite_rounded,
    color: Color(0xFFE08A9D),
    description: 'Reactive and easily irritated',
  ),
  SkinConcern.pores: _ConcernData(
    label: 'Pores',
    icon: Icons.blur_on_rounded,
    color: Color(0xFF95A5A6),
    description: 'Enlarged and visible pores',
  ),
  SkinConcern.darkCircles: _ConcernData(
    label: 'Dark Circles',
    icon: Icons.visibility_off_rounded,
    color: Color(0xFF7F8C8D),
    description: 'Under-eye discoloration',
  ),
  SkinConcern.finelines: _ConcernData(
    label: 'Fine Lines',
    icon: Icons.linear_scale_rounded,
    color: Color(0xFFC5A9E0),
    description: 'Early signs of aging',
  ),
  SkinConcern.texture: _ConcernData(
    label: 'Texture',
    icon: Icons.texture_rounded,
    color: Color(0xFFBDC3C7),
    description: 'Uneven or rough surface',
  ),
  SkinConcern.unevenTone: _ConcernData(
    label: 'Uneven Tone',
    icon: Icons.palette_rounded,
    color: Color(0xFFFFB347),
    description: 'Discoloration and patches',
  ),
  SkinConcern.sagging: _ConcernData(
    label: 'Sagging',
    icon: Icons.trending_down_rounded,
    color: Color(0xFF9B7EDE),
    description: 'Loss of firmness and elasticity',
  ),
  SkinConcern.dehydration: _ConcernData(
    label: 'Dehydration',
    icon: Icons.water_damage_rounded,
    color: Color(0xFF7EC8E3),
    description: 'Lack of water in skin',
  ),
};

/// Extension to get concern data
extension SkinConcernExtension on SkinConcern {
  String get label => _concernData[this]!.label;
  IconData get icon => _concernData[this]!.icon;
  Color get color => _concernData[this]!.color;
  String get description => _concernData[this]!.description;
}
