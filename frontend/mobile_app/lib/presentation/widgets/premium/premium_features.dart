import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'package:ai_skincare_platform/presentation/widgets/premium/premium_badge.dart';

/// Premium feature comparison card
class PremiumFeatureCard extends StatelessWidget {
  const PremiumFeatureCard({
    super.key,
    required this.feature,
    this.onUpgrade,
  });

  final PremiumFeature feature;
  final VoidCallback? onUpgrade;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            feature.requiredTier.primaryColor.withValues(alpha: 0.08),
            feature.requiredTier.primaryColor.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(
          color: feature.requiredTier.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  feature.requiredTier.primaryColor,
                  feature.requiredTier.secondaryColor,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: feature.requiredTier.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              feature.icon,
              size: 28,
              color: feature.requiredTier.textColor,
            ),
          ),
          const SizedBox(width: AppSpacing.l),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        feature.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    PremiumBadge(
                      tier: feature.requiredTier,
                      size: BadgeSize.small,
                      showLabel: false,
                      animate: false,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  feature.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Upgrade button
          if (!feature.isUnlocked) ...[
            const SizedBox(width: AppSpacing.m),
            IconButton(
              onPressed: onUpgrade,
              icon: Icon(
                Icons.arrow_forward_rounded,
                color: feature.requiredTier.primaryColor,
              ),
              style: IconButton.styleFrom(
                backgroundColor:
                    feature.requiredTier.primaryColor.withValues(alpha: 0.12),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PremiumFeature {
  const PremiumFeature({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.requiredTier,
    this.isUnlocked = false,
  });

  final String id;
  final String name;
  final String description;
  final IconData icon;
  final PremiumTier requiredTier;
  final bool isUnlocked;
}

/// Premium benefits banner for promotions
class PremiumBanner extends StatelessWidget {
  const PremiumBanner({
    super.key,
    required this.tier,
    this.discount,
    this.message,
    this.onTap,
    this.onDismiss,
  });

  final PremiumTier tier;
  final int? discount;
  final String? message;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final tierData = tier;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.m),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              tierData.primaryColor,
              tierData.secondaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: tierData.primaryColor.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative elements
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              left: -10,
              bottom: -10,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    child: Icon(
                      tierData.icon,
                      size: 26,
                      color: tierData.textColor,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Upgrade to ${tierData.label}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: tierData.textColor,
                              ),
                            ),
                            if (discount != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.full),
                                ),
                                child: Text(
                                  '-$discount%',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: tierData.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          message ?? 'Unlock premium features today!',
                          style: TextStyle(
                            fontSize: 13,
                            color: tierData.textColor.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: tierData.textColor,
                  ),
                ],
              ),
            ),
            // Dismiss button
            if (onDismiss != null)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onDismiss,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.2),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: tierData.textColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// User profile premium badge display
class ProfilePremiumDisplay extends StatelessWidget {
  const ProfilePremiumDisplay({
    super.key,
    required this.tier,
    this.expiresAt,
    this.onManage,
  });

  final PremiumTier tier;
  final DateTime? expiresAt;
  final VoidCallback? onManage;

  @override
  Widget build(BuildContext context) {
    if (tier == PremiumTier.free) {
      return const SizedBox.shrink();
    }

    final daysLeft = expiresAt?.difference(DateTime.now()).inDays;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            tier.primaryColor.withValues(alpha: 0.12),
            tier.secondaryColor.withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(
          color: tier.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          PremiumBadge(tier: tier, size: BadgeSize.medium),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Active Subscription',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (daysLeft != null)
                  Text(
                    daysLeft > 0
                        ? '$daysLeft days remaining'
                        : 'Expires today',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: daysLeft <= 7 ? AppColors.warning : AppColors.textPrimary,
                    ),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: onManage,
            child: const Text('Manage'),
          ),
        ],
      ),
    );
  }
}
