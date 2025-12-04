import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';

/// Premium tier levels
enum PremiumTier {
  free,
  silver,
  gold,
  platinum,
  diamond,
}

/// Premium badge widget with animated shimmer effect
class PremiumBadge extends StatefulWidget {
  const PremiumBadge({
    super.key,
    required this.tier,
    this.size = BadgeSize.medium,
    this.showLabel = true,
    this.animate = true,
    this.onTap,
  });

  final PremiumTier tier;
  final BadgeSize size;
  final bool showLabel;
  final bool animate;
  final VoidCallback? onTap;

  @override
  State<PremiumBadge> createState() => _PremiumBadgeState();
}

class _PremiumBadgeState extends State<PremiumBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    if (widget.animate && widget.tier != PremiumTier.free) {
      _shimmerController.repeat();
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tier == PremiumTier.free) {
      return const SizedBox.shrink();
    }

    final tierData = _tierData[widget.tier]!;
    final dimensions = _sizeDimensions[widget.size]!;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: dimensions.horizontalPadding,
              vertical: dimensions.verticalPadding,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  tierData.primaryColor,
                  tierData.secondaryColor,
                  tierData.primaryColor,
                ],
                stops: [
                  0.0,
                  _shimmerController.value,
                  1.0,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(dimensions.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: tierData.primaryColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  tierData.icon,
                  size: dimensions.iconSize,
                  color: tierData.textColor,
                ),
                if (widget.showLabel) ...[
                  SizedBox(width: dimensions.spacing),
                  Text(
                    tierData.label,
                    style: TextStyle(
                      fontSize: dimensions.fontSize,
                      fontWeight: FontWeight.w700,
                      color: tierData.textColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Compact premium indicator for profiles/cards
class PremiumIndicator extends StatelessWidget {
  const PremiumIndicator({
    super.key,
    required this.tier,
    this.size = 20,
  });

  final PremiumTier tier;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (tier == PremiumTier.free) {
      return const SizedBox.shrink();
    }

    final tierData = _tierData[tier]!;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [tierData.primaryColor, tierData.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: tierData.primaryColor.withValues(alpha: 0.4),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Icon(
        tierData.icon,
        size: size * 0.6,
        color: tierData.textColor,
      ),
    );
  }
}

/// Premium crown icon with glow
class PremiumCrown extends StatelessWidget {
  const PremiumCrown({
    super.key,
    required this.tier,
    this.size = 32,
  });

  final PremiumTier tier;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (tier == PremiumTier.free) {
      return const SizedBox.shrink();
    }

    final tierData = _tierData[tier]!;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            tierData.primaryColor.withValues(alpha: 0.3),
            tierData.primaryColor.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Center(
        child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [tierData.primaryColor, tierData.secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds),
          child: Icon(
            Icons.workspace_premium_rounded,
            size: size * 0.75,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Premium feature lock overlay
class PremiumLock extends StatelessWidget {
  const PremiumLock({
    super.key,
    required this.child,
    required this.requiredTier,
    this.currentTier = PremiumTier.free,
    this.onTap,
    this.message,
  });

  final Widget child;
  final PremiumTier requiredTier;
  final PremiumTier currentTier;
  final VoidCallback? onTap;
  final String? message;

  bool get isLocked => currentTier.index < requiredTier.index;

  @override
  Widget build(BuildContext context) {
    if (!isLocked) return child;

    final tierData = _tierData[requiredTier]!;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Blurred/grayed content
          ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.grey,
              BlendMode.saturation,
            ),
            child: Opacity(
              opacity: 0.5,
              child: IgnorePointer(child: child),
            ),
          ),
          // Lock overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(AppRadius.m),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          tierData.primaryColor,
                          tierData.secondaryColor,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: tierData.primaryColor.withValues(alpha: 0.5),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.lock_rounded,
                      color: tierData.textColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      message ?? '${tierData.label} only',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Premium subscription card
class PremiumSubscriptionCard extends StatelessWidget {
  const PremiumSubscriptionCard({
    super.key,
    required this.tier,
    required this.price,
    this.period = 'month',
    this.features = const [],
    this.isPopular = false,
    this.isCurrent = false,
    this.onSelect,
  });

  final PremiumTier tier;
  final String price;
  final String period;
  final List<String> features;
  final bool isPopular;
  final bool isCurrent;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    final tierData = _tierData[tier]!;

    return Container(
      decoration: BoxDecoration(
        gradient: isPopular
            ? LinearGradient(
                colors: [
                  tierData.primaryColor.withValues(alpha: 0.1),
                  tierData.secondaryColor.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isPopular ? null : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: isPopular
              ? tierData.primaryColor
              : isCurrent
                  ? AppColors.success
                  : AppColors.border,
          width: isPopular ? 2 : 1,
        ),
        boxShadow: isPopular
            ? [
                BoxShadow(
                  color: tierData.primaryColor.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          // Popular badge
          if (isPopular)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [tierData.primaryColor, tierData.secondaryColor],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.xl - 2),
                ),
              ),
              child: Center(
                child: Text(
                  'MOST POPULAR',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: tierData.textColor,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              children: [
                // Tier icon and name
                PremiumBadge(tier: tier, size: BadgeSize.large),
                const SizedBox(height: AppSpacing.m),
                // Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: tierData.primaryColor,
                      ),
                    ),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: tierData.primaryColor,
                      ),
                    ),
                    Text(
                      '/$period',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.l),
                // Features
                ...features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 18,
                          color: tierData.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
                // CTA button
                SizedBox(
                  width: double.infinity,
                  child: isCurrent
                      ? OutlinedButton(
                          onPressed: null,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.success),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_rounded,
                                  size: 18, color: AppColors.success),
                              SizedBox(width: 6),
                              Text(
                                'Current Plan',
                                style: TextStyle(color: AppColors.success),
                              ),
                            ],
                          ),
                        )
                      : ElevatedButton(
                          onPressed: onSelect,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tierData.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Subscribe',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Tier data
class _TierData {
  const _TierData({
    required this.label,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.textColor,
  });

  final String label;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final Color textColor;
}

const _tierData = <PremiumTier, _TierData>{
  PremiumTier.free: _TierData(
    label: 'Free',
    icon: Icons.person_outline_rounded,
    primaryColor: Color(0xFF94A3B8),
    secondaryColor: Color(0xFF64748B),
    textColor: Colors.white,
  ),
  PremiumTier.silver: _TierData(
    label: 'Silver',
    icon: Icons.star_rounded,
    primaryColor: Color(0xFFA8A9AD),
    secondaryColor: Color(0xFFE8E8E8),
    textColor: Color(0xFF1F2937),
  ),
  PremiumTier.gold: _TierData(
    label: 'Gold',
    icon: Icons.workspace_premium_rounded,
    primaryColor: Color(0xFFFFD700),
    secondaryColor: Color(0xFFFFA500),
    textColor: Color(0xFF1F2937),
  ),
  PremiumTier.platinum: _TierData(
    label: 'Platinum',
    icon: Icons.diamond_rounded,
    primaryColor: Color(0xFF818CF8),
    secondaryColor: Color(0xFFC4B5FD),
    textColor: Colors.white,
  ),
  PremiumTier.diamond: _TierData(
    label: 'Diamond',
    icon: Icons.auto_awesome_rounded,
    primaryColor: Color(0xFF22D3EE),
    secondaryColor: Color(0xFF67E8F9),
    textColor: Color(0xFF1F2937),
  ),
};

// Size dimensions
enum BadgeSize { small, medium, large }

class _SizeDimensions {
  const _SizeDimensions({
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.iconSize,
    required this.fontSize,
    required this.spacing,
    required this.borderRadius,
  });

  final double horizontalPadding;
  final double verticalPadding;
  final double iconSize;
  final double fontSize;
  final double spacing;
  final double borderRadius;
}

const _sizeDimensions = <BadgeSize, _SizeDimensions>{
  BadgeSize.small: _SizeDimensions(
    horizontalPadding: 6,
    verticalPadding: 3,
    iconSize: 12,
    fontSize: 10,
    spacing: 3,
    borderRadius: 6,
  ),
  BadgeSize.medium: _SizeDimensions(
    horizontalPadding: 10,
    verticalPadding: 5,
    iconSize: 16,
    fontSize: 12,
    spacing: 5,
    borderRadius: 8,
  ),
  BadgeSize.large: _SizeDimensions(
    horizontalPadding: 14,
    verticalPadding: 8,
    iconSize: 20,
    fontSize: 14,
    spacing: 6,
    borderRadius: 10,
  ),
};

// Extension for tier
extension PremiumTierExtension on PremiumTier {
  String get label => _tierData[this]!.label;
  IconData get icon => _tierData[this]!.icon;
  Color get primaryColor => _tierData[this]!.primaryColor;
  Color get secondaryColor => _tierData[this]!.secondaryColor;
  Color get textColor => _tierData[this]!.textColor;
}
