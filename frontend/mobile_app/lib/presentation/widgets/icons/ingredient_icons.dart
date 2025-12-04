import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';

/// Enum representing common skincare ingredients
enum SkincareIngredient {
  niacinamide,
  retinol,
  hyaluronicAcid,
  vitaminC,
  salicylicAcid,
  glycolicAcid,
  ceramides,
  peptides,
  vitaminE,
  zinc,
  aloeVera,
  teaTree,
  greenTea,
  centella,
  squalane,
  argan,
  rosehip,
  jojoba,
}

/// Premium ingredient icon with beautiful styling
class IngredientIcon extends StatelessWidget {
  const IngredientIcon({
    super.key,
    required this.ingredient,
    this.size = 48,
    this.showLabel = true,
    this.selected = false,
    this.onTap,
  });

  final SkincareIngredient ingredient;
  final double size;
  final bool showLabel;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final data = _ingredientData[ingredient]!;
    final iconSize = size * 0.5;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * 0.28),
              gradient: LinearGradient(
                colors: selected
                    ? [data.color, data.color.withValues(alpha: 0.8)]
                    : [
                        data.color.withValues(alpha: 0.12),
                        data.color.withValues(alpha: 0.06),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: selected
                    ? data.color
                    : data.color.withValues(alpha: 0.25),
                width: selected ? 2 : 1.5,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: data.color.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                data.emoji,
                style: TextStyle(fontSize: iconSize),
              ),
            ),
          ),
          if (showLabel) ...[
            SizedBox(height: size * 0.12),
            SizedBox(
              width: size * 1.4,
              child: Text(
                data.shortName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: size * 0.2,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? data.color : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Horizontal scrollable ingredient selector
class IngredientSelector extends StatelessWidget {
  const IngredientSelector({
    super.key,
    required this.selectedIngredients,
    required this.onChanged,
    this.iconSize = 48,
    this.allowMultiple = true,
  });

  final Set<SkincareIngredient> selectedIngredients;
  final ValueChanged<Set<SkincareIngredient>> onChanged;
  final double iconSize;
  final bool allowMultiple;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      child: Row(
        children: SkincareIngredient.values.map((ingredient) {
          final isSelected = selectedIngredients.contains(ingredient);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
            child: IngredientIcon(
              ingredient: ingredient,
              size: iconSize,
              selected: isSelected,
              onTap: () {
                final newSelection = Set<SkincareIngredient>.from(selectedIngredients);
                if (isSelected) {
                  newSelection.remove(ingredient);
                } else {
                  if (!allowMultiple) newSelection.clear();
                  newSelection.add(ingredient);
                }
                onChanged(newSelection);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Compact ingredient chip for display in lists
class IngredientChip extends StatelessWidget {
  const IngredientChip({
    super.key,
    required this.ingredient,
    this.onRemove,
    this.compact = false,
  });

  final SkincareIngredient ingredient;
  final VoidCallback? onRemove;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final data = _ingredientData[ingredient]!;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.s : AppSpacing.m,
        vertical: compact ? 4 : AppSpacing.s,
      ),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: data.color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data.emoji,
            style: TextStyle(fontSize: compact ? 12 : 16),
          ),
          SizedBox(width: compact ? 4 : AppSpacing.s),
          Text(
            data.shortName,
            style: TextStyle(
              fontSize: compact ? 11 : 13,
              fontWeight: FontWeight.w600,
              color: data.color,
            ),
          ),
          if (onRemove != null) ...[
            SizedBox(width: compact ? 4 : AppSpacing.s),
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close_rounded,
                size: compact ? 14 : 16,
                color: data.color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Detailed ingredient card with benefits
class IngredientCard extends StatelessWidget {
  const IngredientCard({
    super.key,
    required this.ingredient,
    this.onTap,
  });

  final SkincareIngredient ingredient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final data = _ingredientData[ingredient]!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.m),
        decoration: BoxDecoration(
          color: data.color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppRadius.l),
          border: Border.all(
            color: data.color.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.m),
                gradient: LinearGradient(
                  colors: [
                    data.color.withValues(alpha: 0.2),
                    data.color.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  data.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: data.color,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.benefit,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: data.color.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data class for ingredient styling
class _IngredientData {
  const _IngredientData({
    required this.name,
    required this.shortName,
    required this.emoji,
    required this.color,
    required this.benefit,
    required this.category,
  });

  final String name;
  final String shortName;
  final String emoji;
  final Color color;
  final String benefit;
  final String category;
}

const _ingredientData = <SkincareIngredient, _IngredientData>{
  SkincareIngredient.niacinamide: _IngredientData(
    name: 'Niacinamide',
    shortName: 'Niacinamide',
    emoji: '💧',
    color: Color(0xFF4ECDC4),
    benefit: 'Minimizes pores, controls oil, brightens skin',
    category: 'Vitamin',
  ),
  SkincareIngredient.retinol: _IngredientData(
    name: 'Retinol',
    shortName: 'Retinol',
    emoji: '✨',
    color: Color(0xFFE88D67),
    benefit: 'Anti-aging, reduces wrinkles, boosts collagen',
    category: 'Vitamin A',
  ),
  SkincareIngredient.hyaluronicAcid: _IngredientData(
    name: 'Hyaluronic Acid',
    shortName: 'HA',
    emoji: '💦',
    color: Color(0xFF7EC8E3),
    benefit: 'Intense hydration, plumps skin, retains moisture',
    category: 'Humectant',
  ),
  SkincareIngredient.vitaminC: _IngredientData(
    name: 'Vitamin C',
    shortName: 'Vit C',
    emoji: '🍊',
    color: Color(0xFFFFB347),
    benefit: 'Brightens, protects from free radicals, evens tone',
    category: 'Antioxidant',
  ),
  SkincareIngredient.salicylicAcid: _IngredientData(
    name: 'Salicylic Acid',
    shortName: 'BHA',
    emoji: '🧪',
    color: Color(0xFF9B7EDE),
    benefit: 'Unclogs pores, reduces acne, exfoliates',
    category: 'BHA',
  ),
  SkincareIngredient.glycolicAcid: _IngredientData(
    name: 'Glycolic Acid',
    shortName: 'AHA',
    emoji: '🌿',
    color: Color(0xFF6BCB77),
    benefit: 'Exfoliates dead skin, brightens, smooths texture',
    category: 'AHA',
  ),
  SkincareIngredient.ceramides: _IngredientData(
    name: 'Ceramides',
    shortName: 'Ceramides',
    emoji: '🛡️',
    color: Color(0xFFE08A9D),
    benefit: 'Strengthens skin barrier, locks in moisture',
    category: 'Lipid',
  ),
  SkincareIngredient.peptides: _IngredientData(
    name: 'Peptides',
    shortName: 'Peptides',
    emoji: '⚡',
    color: Color(0xFFD4A5A5),
    benefit: 'Firms skin, reduces fine lines, boosts collagen',
    category: 'Protein',
  ),
  SkincareIngredient.vitaminE: _IngredientData(
    name: 'Vitamin E',
    shortName: 'Vit E',
    emoji: '🌸',
    color: Color(0xFFC5A9E0),
    benefit: 'Antioxidant protection, nourishes, heals',
    category: 'Vitamin',
  ),
  SkincareIngredient.zinc: _IngredientData(
    name: 'Zinc',
    shortName: 'Zinc',
    emoji: '⚪',
    color: Color(0xFF95A5A6),
    benefit: 'Calms inflammation, antibacterial, heals',
    category: 'Mineral',
  ),
  SkincareIngredient.aloeVera: _IngredientData(
    name: 'Aloe Vera',
    shortName: 'Aloe',
    emoji: '🌱',
    color: Color(0xFF27AE60),
    benefit: 'Soothes, hydrates, heals irritation',
    category: 'Botanical',
  ),
  SkincareIngredient.teaTree: _IngredientData(
    name: 'Tea Tree',
    shortName: 'Tea Tree',
    emoji: '🍃',
    color: Color(0xFF1E8449),
    benefit: 'Antibacterial, fights acne, purifies',
    category: 'Essential Oil',
  ),
  SkincareIngredient.greenTea: _IngredientData(
    name: 'Green Tea',
    shortName: 'Green Tea',
    emoji: '🍵',
    color: Color(0xFF82B74B),
    benefit: 'Antioxidant, anti-inflammatory, protects',
    category: 'Botanical',
  ),
  SkincareIngredient.centella: _IngredientData(
    name: 'Centella Asiatica',
    shortName: 'Centella',
    emoji: '🌿',
    color: Color(0xFF3CB371),
    benefit: 'Calms, repairs, strengthens barrier',
    category: 'Botanical',
  ),
  SkincareIngredient.squalane: _IngredientData(
    name: 'Squalane',
    shortName: 'Squalane',
    emoji: '💎',
    color: Color(0xFFB8D4E3),
    benefit: 'Lightweight moisture, non-comedogenic, balances',
    category: 'Lipid',
  ),
  SkincareIngredient.argan: _IngredientData(
    name: 'Argan Oil',
    shortName: 'Argan',
    emoji: '🌰',
    color: Color(0xFFD4A853),
    benefit: 'Nourishes, anti-aging, adds radiance',
    category: 'Oil',
  ),
  SkincareIngredient.rosehip: _IngredientData(
    name: 'Rosehip Oil',
    shortName: 'Rosehip',
    emoji: '🌹',
    color: Color(0xFFE74C3C),
    benefit: 'Reduces scars, brightens, regenerates',
    category: 'Oil',
  ),
  SkincareIngredient.jojoba: _IngredientData(
    name: 'Jojoba Oil',
    shortName: 'Jojoba',
    emoji: '🫒',
    color: Color(0xFFCDC673),
    benefit: 'Balances oil, moisturizes, non-clogging',
    category: 'Oil',
  ),
};

/// Extension to get ingredient data
extension SkincareIngredientExtension on SkincareIngredient {
  String get name => _ingredientData[this]!.name;
  String get shortName => _ingredientData[this]!.shortName;
  String get emoji => _ingredientData[this]!.emoji;
  Color get color => _ingredientData[this]!.color;
  String get benefit => _ingredientData[this]!.benefit;
  String get category => _ingredientData[this]!.category;
}
