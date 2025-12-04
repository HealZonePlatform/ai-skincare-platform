import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/core/analytics/analytics_service.dart';
import 'package:ai_skincare_platform/core/constants/app_assets.dart';
import 'package:ai_skincare_platform/core/utils/haptics.dart';
import 'package:ai_skincare_platform/presentation/screens/home/models/home_models.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

class HeroHeader extends StatefulWidget {
  const HeroHeader({
    super.key,
    required this.greetingName,
    required this.heroStats,
    required this.score,
    required this.lastScanLabel,
    this.beforeImageAsset = AppAssets.analysisPlaceholder,
    this.afterImageAsset = AppAssets.analysisPlaceholder,
  });

  final String greetingName;
  final List<HeroStatModel> heroStats;
  final int score;
  final String lastScanLabel;
  final String beforeImageAsset;
  final String afterImageAsset;

  @override
  State<HeroHeader> createState() => _HeroHeaderState();
}

class _HeroHeaderState extends State<HeroHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getSkinCondition(int score) {
    if (score >= 85) return 'Excellent';
    if (score >= 70) return 'Good';
    if (score >= 50) return 'Fair';
    return 'Needs Attention';
  }

  Color _getConditionColor(int score) {
    if (score >= 85) return AppColors.accent;
    if (score >= 70) return Colors.white;
    if (score >= 50) return AppColors.warningLight;
    return AppColors.dangerLight;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final resolvedName =
        widget.greetingName.isNotEmpty ? widget.greetingName : 'there';
    final condition = _getSkinCondition(widget.score);
    final conditionColor = _getConditionColor(widget.score);

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(gradient: AppColors.sunriseGradient),
        ),
        // Decorative circles
        Positioned(
          right: -60,
          top: -60,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
        ),
        Positioned(
          left: -40,
          top: 100,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
        ),
        // Floating particles
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value * 2 * pi;
            return Stack(
              children: [
                _AnimatedParticle(
                  offset: Offset(
                    0.12 + sin(t) * 0.02,
                    0.3 + cos(t * 1.2) * 0.015,
                  ),
                  size: 24,
                  color: Colors.white.withValues(alpha: 0.45),
                ),
                _AnimatedParticle(
                  offset: Offset(
                    0.7 + sin(t * 0.8) * 0.03,
                    0.2 + cos(t * 1.6) * 0.02,
                  ),
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.38),
                ),
                _AnimatedParticle(
                  offset: Offset(
                    0.4 + sin(t * 1.4) * 0.025,
                    0.75 + cos(t) * 0.02,
                  ),
                  size: 16,
                  color: AppColors.accent.withValues(alpha: 0.25),
                ),
              ],
            );
          },
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xl,
            media.padding.top + AppSpacing.l,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning,',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.textPrimary.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        resolvedName,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_outlined),
                      color: AppColors.textPrimary,
                      tooltip: 'Notifications',
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Score Card
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl, vertical: AppSpacing.l),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(AppRadius.xxl),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Current Skin Score',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s),
                      TweenAnimationBuilder<int>(
                        key: ValueKey(widget.score),
                        tween: IntTween(begin: 0, end: widget.score),
                        duration: const Duration(seconds: 2),
                        curve: Curves.easeOutQuart,
                        builder: (context, value, child) {
                          final progress = value / (widget.score == 0 ? 1 : widget.score);
                          final scale = 0.9 + (progress * 0.1);
                          return Transform.scale(
                            scale: scale,
                            child: Text(
                              '$value',
                              style: theme.textTheme.displayLarge?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 64,
                                height: 1,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.m, vertical: AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: conditionColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, size: 10, color: conditionColor),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              condition,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.m),
                      _BeforeAfterStrip(
                        beforeImageAsset: widget.beforeImageAsset,
                        afterImageAsset: widget.afterImageAsset,
                        lastScanLabel: widget.lastScanLabel,
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Quick Scan Button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
                    await Haptics.light();
                    if (context.mounted) {
                      AnalyticsService.logButtonTap(
                        'quickScan',
                        parameters: {'surface': 'hero_header'},
                      );
                      AnalyticsService.logScanStarted(source: 'hero');
                      context.push('/scan/permission');
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.l),
                    elevation: 4,
                    shadowColor: AppColors.primary.withValues(alpha: 0.4),
                  ),
                  icon: const Icon(Icons.center_focus_strong_rounded),
                  label: const Text('Start New Scan'),
                ),
              ),

              const SizedBox(height: AppSpacing.l),

              // Stats Row
              if (widget.heroStats.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: widget.heroStats
                        .map((stat) => HeroStatCard(stat: stat))
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BeforeAfterStrip extends StatelessWidget {
  const _BeforeAfterStrip({
    required this.beforeImageAsset,
    required this.afterImageAsset,
    required this.lastScanLabel,
  });

  final String beforeImageAsset;
  final String afterImageAsset;
  final String lastScanLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          _MiniThumb(label: 'Before', asset: beforeImageAsset),
          const SizedBox(width: AppSpacing.s),
          _MiniThumb(label: 'After', asset: afterImageAsset),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                lastScanLabel,
                style: theme.textTheme.labelMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniThumb extends StatelessWidget {
  const _MiniThumb({required this.label, required this.asset});

  final String label;
  final String asset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.m),
          child: Image.asset(
            asset,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: theme.textTheme.labelSmall
              ?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _AnimatedParticle extends StatelessWidget {
  const _AnimatedParticle({
    required this.offset,
    required this.size,
    required this.color,
  });

  final Offset offset;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: offset,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.5),
              blurRadius: size * 1.5,
            ),
          ],
        ),
      ),
    );
  }
}

class HeroStatCard extends StatelessWidget {
  const HeroStatCard({super.key, required this.stat});

  final HeroStatModel stat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.s),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.l),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.l,
              vertical: AppSpacing.m,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.l),
              border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(stat.icon, color: Colors.white, size: 18),
                ),
                const SizedBox(width: AppSpacing.s),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stat.value,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      stat.label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.s),
                Text(
                  stat.detail,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: stat.color.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
