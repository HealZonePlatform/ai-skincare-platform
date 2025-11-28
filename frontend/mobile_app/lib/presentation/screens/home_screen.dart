import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ai_skincare_platform/core/constants/app_assets.dart';
import 'package:ai_skincare_platform/presentation/providers/auth_provider.dart';
import 'package:ai_skincare_platform/presentation/providers/user_profile_provider.dart';
import 'package:ai_skincare_platform/presentation/widgets/brand_logo.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_skeleton.dart';
import 'package:ai_skincare_platform/presentation/widgets/ui_kit/hz_responsive_layout.dart';
import 'package:ai_skincare_platform/presentation/widgets/ui_kit/hz_section_header.dart';
import 'package:ai_skincare_platform/presentation/widgets/ui_kit/hz_surface_card.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileProvider = context.watch<UserProfileProvider>();
    final showSkeleton =
        profileProvider.isLoading && profileProvider.userProfile == null;
    final resolvedDirection =
        Directionality.maybeOf(context) ?? TextDirection.ltr;

    return Directionality(
      textDirection: resolvedDirection,
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.surface,
              pinned: true,
              expandedHeight: 380,
              leading: const SizedBox.shrink(),
              titleSpacing: 0,
              title: const BrandLogo(compact: true, size: 28),
              flexibleSpace: FlexibleSpaceBar(
                background: _HeroHeader(theme: theme),
              ),
              actions: [
                IconButton(
                  tooltip: 'Profile',
                  onPressed: () => context.push('/profile'),
                  icon: const Icon(Icons.person_outline),
                ),
                IconButton(
                  tooltip: 'Sign out',
                  onPressed: () => context.read<AuthProvider>().logout(),
                  icon: const Icon(Icons.logout_rounded),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl, AppSpacing.l, AppSpacing.xl, 0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: showSkeleton
                      ? const _HomeSkeleton()
                      : const _HomeContent(),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: HzSectionHeader(
                title: 'Latest stories',
                subtitle: 'Guides curated for your skin goals',
                actionLabel: 'See all',
                route: '/community',
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl, vertical: AppSpacing.m),
              sliver: SliverList.separated(
                itemCount: _articles.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.l),
                itemBuilder: (context, index) =>
                    _ArticleCard(article: _articles[index]),
              ),
            ),
            const SliverToBoxAdapter(
              child: HzSectionHeader(
                title: 'Recommended products',
                subtitle: 'Fastest wins for your current skin state',
                actionLabel: 'Browse',
                route: '/products',
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 340,
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _products.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSpacing.l),
                  itemBuilder: (context, index) =>
                      _ProductCard(product: _products[index]),
                  cacheExtent: 1000,
                ),
              ),
            ),
            const SliverPadding(
                padding: EdgeInsets.only(bottom: AppSpacing.xxl * 1.5)),
          ],
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Gradient Background
        Container(
            decoration: const BoxDecoration(gradient: AppColors.heroGradient)),

        // Decorative Circles
        Positioned(
          right: -40,
          top: media.padding.top + 12,
          child: Transform.rotate(
            angle: -math.pi / 14,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
        ),
        Positioned(
          left: -30,
          bottom: 24,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
        ),

        // Content
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xl,
            media.padding.top + AppSpacing.l,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const _GlassChip(
                icon: Icons.water_drop_outlined,
                label: 'Humidity',
                value: 'Optimal',
              ),
              const SizedBox(height: AppSpacing.m),
              Text(
                'Good morning, Hana!',
                style: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                'Skin is calm and balanced. Keep hydration steady and we\'ll be ready for tonight\'s scan.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
              ),
              const SizedBox(height: AppSpacing.l),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => context.push('/scan/prepare'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.l, vertical: AppSpacing.m),
                      ),
                      icon: const Icon(Icons.center_focus_strong_rounded),
                      label: const Text('Quick Scan'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.5)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.l, vertical: AppSpacing.m),
                      ),
                      onPressed: () => context.push('/survey'),
                      icon: const Icon(Icons.calendar_today_rounded),
                      label: const Text('Plan'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.m),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                child: Row(
                  children: _heroStats
                      .map((stat) => _HeroStatCard(stat: stat))
                      .toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.s),
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSpacing.l),
        _PulseCard(),
        SizedBox(height: AppSpacing.l),
        _InsightCards(),
        SizedBox(height: AppSpacing.l),
        _CoachCard(),
        SizedBox(height: AppSpacing.l),
        _RoutineCarousel(),
        SizedBox(height: AppSpacing.l),
      ],
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: AppSpacing.l),
        HzSkeleton.rect(
            height: 200, margin: EdgeInsets.symmetric(vertical: AppSpacing.s)),
        HzSkeleton.rect(
            height: 140, margin: EdgeInsets.symmetric(vertical: AppSpacing.s)),
        HzSkeleton.rect(
            height: 220, margin: EdgeInsets.symmetric(vertical: AppSpacing.s)),
        SizedBox(height: AppSpacing.l),
        HzSkeleton.rect(height: 220),
        SizedBox(height: AppSpacing.l),
      ],
    );
  }
}

class _PulseCard extends StatelessWidget {
  const _PulseCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return HzSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: AppShadows.medium,
                ),
                child: const Icon(Icons.monitor_heart_outlined,
                    color: Colors.white),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Skin Pulse',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    Text(_pulse.updated,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.m, vertical: AppSpacing.s),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  color: AppColors.secondary.withValues(alpha: 0.14),
                ),
                child: Text(_pulse.delta,
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: AppColors.secondaryDark)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.l),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${_pulse.score}',
                      style: theme.textTheme.displayMedium
                          ?.copyWith(color: AppColors.primaryDark)),
                  Text(_pulse.mood,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(width: AppSpacing.l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hydration Trajectory',
                        style: theme.textTheme.labelMedium),
                    const SizedBox(height: AppSpacing.s),
                    _Sparkline(values: _pulse.trend, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.l),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: _pulseHighlights
                .map((highlight) => _PulseHighlightPill(highlight: highlight))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _CoachCard extends StatelessWidget {
  const _CoachCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return HzSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      backgroundColor: AppColors.primary.withValues(alpha: 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.m),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.secondaryGradient,
                  boxShadow: AppShadows.medium,
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Coach Note',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: AppSpacing.s),
                    Text(
                      'Tonight swap to recovery mode after exfoliation. Keep niacinamide and barrier cream, skip actives.',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'We will remind you 30 minutes before your scan.',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: AppColors.primaryDark),
                ),
              ),
              TextButton.icon(
                onPressed: () => context.push('/advice'),
                icon: const Icon(Icons.chat_bubble_outline, size: 18),
                label: const Text('Ask Coach'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsightCards extends StatelessWidget {
  const _InsightCards();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget buildCard(_Insight insight, bool isWide) {
      final gradient = LinearGradient(
        colors: [
          insight.iconColor.withValues(alpha: 0.1),
          Colors.white,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      final progressPercent = (insight.progress * 100).round();
      return AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.symmetric(
          horizontal: isWide ? AppSpacing.m / 2 : 0,
          vertical: isWide ? 0 : AppSpacing.m / 2,
        ),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppRadius.l),
          boxShadow: AppShadows.mild,
          border: Border.all(color: insight.iconColor.withValues(alpha: 0.16)),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -16,
              child: Transform.rotate(
                angle: -math.pi / 12,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: insight.iconColor.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: AppShadows.mild,
                        ),
                        child: Icon(insight.icon,
                            color: insight.iconColor, size: 22),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.m, vertical: AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: insight.iconColor.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          '$progressPercent% ready',
                          style: theme.textTheme.labelMedium
                              ?.copyWith(color: insight.iconColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    insight.title,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    insight.caption,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: insight.progress),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.s),
                          child: LinearProgressIndicator(
                            value: value,
                            minHeight: 8,
                            backgroundColor: AppColors.chipBg,
                            color: insight.iconColor,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s),
                        Row(
                          children: [
                            Icon(Icons.eco_outlined,
                                size: 16,
                                color:
                                    insight.iconColor.withValues(alpha: 0.8)),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'AI recommends a gentle boost',
                              style: theme.textTheme.labelSmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final cards =
            _insights.map((insight) => buildCard(insight, isWide)).toList();

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: cards.map((card) => Expanded(child: card)).toList(),
          );
        }
        return Column(children: cards);
      },
    );
  }
}

class _RoutineCarousel extends StatelessWidget {
  const _RoutineCarousel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Today\'s routines',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.m),
        HzResponsiveLayout(
          mobile: (_, __) => SizedBox(
            height: 320,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _routines.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.l),
              itemBuilder: (context, index) =>
                  _RoutineCard(routine: _routines[index]),
            ),
          ),
          tablet: (_, constraints) {
            final itemWidth = (constraints.maxWidth - AppSpacing.l) / 2;
            return Wrap(
              spacing: AppSpacing.l,
              runSpacing: AppSpacing.l,
              children: _routines
                  .map(
                    (routine) => SizedBox(
                      width: itemWidth,
                      child: _RoutineCard(routine: routine),
                    ),
                  )
                  .toList(),
            );
          },
          desktop: (_, constraints) {
            final rawWidth = (constraints.maxWidth - AppSpacing.l * 2) / 3;
            final itemWidth = rawWidth.clamp(260, 320).toDouble();
            return Wrap(
              spacing: AppSpacing.l,
              runSpacing: AppSpacing.l,
              children: _routines
                  .map(
                    (routine) => SizedBox(
                      width: itemWidth,
                      child: _RoutineCard(routine: routine),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _RoutineCard extends StatelessWidget {
  const _RoutineCard({required this.routine});

  final _Routine routine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      width: 240,
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.l),
        gradient: LinearGradient(
          colors: [
            routine.accent.withValues(alpha: 0.12),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: routine.accent.withValues(alpha: 0.2)),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.m, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: routine.accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  routine.bestMoment,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: routine.accent),
                ),
              ),
              const Spacer(),
              Icon(routine.icon, color: routine.accent),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          Text(routine.title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.xs),
          Text(routine.focus,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.m),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: routine.steps
                .map(
                  (step) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.m, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(
                          color: routine.accent.withValues(alpha: 0.22)),
                    ),
                    child: Text(
                      step,
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                )
                .toList(),
          ),
          const Spacer(),
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.timelapse_rounded,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${routine.minutes} min',
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const Spacer(),
              FilledButton.tonal(
                onPressed: () => context.push('/routine'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.s, horizontal: AppSpacing.m),
                  backgroundColor: routine.accent.withValues(alpha: 0.2),
                  foregroundColor: routine.accent,
                ),
                child: const Text('See details'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});

  final _Article article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => context.push(article.route),
      borderRadius: BorderRadius.circular(AppRadius.l),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.l),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              article.heroColor.withValues(alpha: 0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: article.heroColor.withValues(alpha: 0.16)),
          boxShadow: AppShadows.mild,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.m),
                gradient: LinearGradient(
                  colors: [
                    article.heroColor.withValues(alpha: 0.16),
                    AppColors.primary.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(article.icon, color: article.heroColor, size: 32),
            ),
            const SizedBox(width: AppSpacing.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article.title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    article.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.m, vertical: AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: article.heroColor.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.timer_outlined,
                                size: 14, color: article.heroColor),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              article.readingTime,
                              style: theme.textTheme.labelSmall
                                  ?.copyWith(color: article.heroColor),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppColors.textSecondary),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final _Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 220,
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.l),
        gradient: LinearGradient(
          colors: [
            Colors.white,
            product.color.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: product.color.withValues(alpha: 0.2)),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.m),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.asset(
                    product.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: product.color.withValues(alpha: 0.12),
                      alignment: Alignment.center,
                      child: Icon(product.icon, color: product.color, size: 42),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: AppSpacing.s,
                left: AppSpacing.s,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.m, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    product.badge,
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.l),
          Text(product.name,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.s),
          Text(
            product.benefit,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.star_rounded, color: product.color, size: 18),
              const SizedBox(width: AppSpacing.xs),
              Text('${product.rating.toStringAsFixed(1)} / 5',
                  style: theme.textTheme.labelSmall),
              const Spacer(),
              TextButton(
                onPressed: () => context.push(product.route),
                child: const Text('Details'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PulseHighlightPill extends StatelessWidget {
  const _PulseHighlightPill({required this.highlight});

  final _PulseHighlight highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l, vertical: AppSpacing.m),
      decoration: BoxDecoration(
        color: highlight.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: highlight.color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(highlight.icon, color: highlight.color, size: 20),
          const SizedBox(width: AppSpacing.s),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                highlight.value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: highlight.color,
                ),
              ),
              Text(
                highlight.label,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Sparkline extends StatelessWidget {
  const _Sparkline({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: CustomPaint(
        painter: _SparklinePainter(values: values, color: color),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final range =
        (maxValue - minValue).abs() < 0.001 ? 1.0 : maxValue - minValue;

    final points = <Offset>[];
    final dx = values.length == 1 ? 0.0 : size.width / (values.length - 1);
    for (var i = 0; i < values.length; i++) {
      final normalized = (values[i] - minValue) / range;
      final y = size.height - (normalized * size.height);
      points.add(Offset(dx * i, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0.18),
          color.withValues(alpha: 0.05),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    canvas.drawPath(path, linePaint);

    canvas.drawCircle(points.last, 5, Paint()..color = Colors.white);
    canvas.drawCircle(points.last, 4, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}

class _HeroStatCard extends StatelessWidget {
  const _HeroStatCard({required this.stat});

  final _HeroStat stat;

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
                horizontal: AppSpacing.l, vertical: AppSpacing.m),
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
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.4)),
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
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      stat.label,
                      style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85)),
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.s),
                Text(
                  stat.detail,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: stat.color.withValues(alpha: 0.9)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassChip extends StatelessWidget {
  const _GlassChip(
      {required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.l, vertical: AppSpacing.s),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: AppSpacing.s),
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '· $value',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Insight {
  const _Insight({
    required this.title,
    required this.caption,
    required this.icon,
    required this.progress,
    required this.iconColor,
  });

  final String title;
  final String caption;
  final IconData icon;
  final double progress;
  final Color iconColor;
}

class _Routine {
  const _Routine({
    required this.title,
    required this.icon,
    required this.steps,
    required this.focus,
    required this.minutes,
    required this.bestMoment,
    required this.accent,
  });

  final String title;
  final IconData icon;
  final List<String> steps;
  final String focus;
  final int minutes;
  final String bestMoment;
  final Color accent;
}

class _Article {
  const _Article({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.readingTime,
    required this.route,
    required this.heroColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String readingTime;
  final String route;
  final Color heroColor;
}

class _Product {
  const _Product({
    required this.name,
    required this.benefit,
    required this.rating,
    required this.icon,
    required this.route,
    required this.color,
    required this.imageAsset,
    required this.badge,
  });

  final String name;
  final String benefit;
  final double rating;
  final IconData icon;
  final String route;
  final Color color;
  final String imageAsset;
  final String badge;
}

class _Pulse {
  const _Pulse({
    required this.score,
    required this.trend,
    required this.delta,
    required this.mood,
    required this.updated,
  });

  final int score;
  final List<double> trend;
  final String delta;
  final String mood;
  final String updated;
}

class _PulseHighlight {
  const _PulseHighlight({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
}

class _HeroStat {
  const _HeroStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.detail,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final String detail;
  final Color color;
}

const _heroStats = [
  _HeroStat(
    label: 'Skin index',
    value: '82',
    icon: Icons.bubble_chart_outlined,
    detail: '+4 today',
    color: Color(0xFFF4A259),
  ),
  _HeroStat(
    label: 'Streak',
    value: '12 days',
    icon: Icons.local_fire_department_outlined,
    detail: 'On track',
    color: Color(0xFF6F52ED),
  ),
  _HeroStat(
    label: 'Recovery',
    value: 'Low redness',
    icon: Icons.eco_outlined,
    detail: 'Gentle mode',
    color: Color(0xFF4DB6AC),
  ),
];

const _pulse = _Pulse(
  score: 82,
  trend: [0.46, 0.5, 0.58, 0.62, 0.66, 0.7, 0.74],
  delta: '+4 vs yesterday',
  mood: 'Calm barrier',
  updated: 'Synced 8 min ago',
);

const _pulseHighlights = [
  _PulseHighlight(
    label: 'Moisture',
    value: '64% sweet spot',
    icon: Icons.water_drop_outlined,
    color: Color(0xFF4C9AFF),
  ),
  _PulseHighlight(
    label: 'Resilience',
    value: 'Low redness',
    icon: Icons.favorite_outline,
    color: Color(0xFF4DB6AC),
  ),
  _PulseHighlight(
    label: 'Environment',
    value: 'Indoor 26°C · 58%',
    icon: Icons.wb_cloudy_outlined,
    color: Color(0xFFF4A259),
  ),
];

const _insights = [
  _Insight(
    title: 'Moisture score',
    caption: 'Completed 3/5 deep hydration sessions this week.',
    icon: Icons.water_drop_outlined,
    progress: 0.6,
    iconColor: Color(0xFF4C9AFF),
  ),
  _Insight(
    title: 'Scan consistency',
    caption: 'Night scans maintained for 12 consecutive days.',
    icon: Icons.radar_outlined,
    progress: 0.8,
    iconColor: Color(0xFF6F52ED),
  ),
  _Insight(
    title: 'Barrier strength',
    caption: 'Recovery nights keep irritation risk under 2%.',
    icon: Icons.shield_moon_outlined,
    progress: 0.72,
    iconColor: Color(0xFF4DB6AC),
  ),
];

const _routines = [
  _Routine(
    title: 'Morning care',
    icon: Icons.wb_sunny_outlined,
    steps: [
      'Enzyme cleanser',
      'Chamomile toner',
      'Vitamin C serum',
      'Barrier cream',
      'SPF 50 sunscreen'
    ],
    focus: 'Hydrate, brighten, and protect',
    minutes: 7,
    bestMoment: '7 AM',
    accent: Color(0xFFF4A259),
  ),
  _Routine(
    title: 'Night repair',
    icon: Icons.nightlight_outlined,
    steps: [
      'Oil cleanser',
      'Gentle gel wash',
      'Mild BHA toner',
      'Recovery serum',
      'Sleeping mask'
    ],
    focus: 'Soothe barrier after the day',
    minutes: 9,
    bestMoment: '9 PM',
    accent: Color(0xFF8A8E5A),
  ),
];

const _articles = [
  _Article(
    title: 'Minimal night routine',
    subtitle:
        'Busy evening? Here are three essential steps to keep your skin glowing.',
    icon: Icons.timeline_rounded,
    readingTime: '3 min read',
    route: '/community/detail/1',
    heroColor: Color(0xFF7C8CFF),
  ),
  _Article(
    title: 'Skin cycling in 7 days',
    subtitle:
        'A gentle approach to alternating acids and recovery nights without irritation.',
    icon: Icons.autorenew_rounded,
    readingTime: '5 min read',
    route: '/community/detail/2',
    heroColor: Color(0xFFF48FB1),
  ),
];

const _products = [
  _Product(
    name: 'Skin1004 Madagascar Ampoule',
    benefit:
        'Soothes sensitive skin and restores the moisture barrier in two weeks.',
    rating: 4.8,
    icon: Icons.science_outlined,
    route: '/products/serum-centella',
    color: Color(0xFF90CAF9),
    imageAsset: AppAssets.productPlaceholder,
    badge: 'Barrier repair',
  ),
  _Product(
    name: 'La Roche-Posay Effaclar Duo+',
    benefit: 'Targets breakouts and helps fade fresh marks without irritation.',
    rating: 4.7,
    icon: Icons.medical_services_outlined,
    route: '/products/effaclar-duo',
    color: Color(0xFFF48FB1),
    imageAsset: AppAssets.productPlaceholder,
    badge: 'Acne control',
  ),
  _Product(
    name: 'Paula\'s Choice BHA 2%',
    benefit:
        'Unclogs pores, refines texture, and keeps congestion under control.',
    rating: 4.9,
    icon: Icons.blur_on_outlined,
    route: '/products/pc-bha',
    color: Color(0xFFCE93D8),
    imageAsset: AppAssets.productPlaceholder,
    badge: 'Texture reset',
  ),
];
