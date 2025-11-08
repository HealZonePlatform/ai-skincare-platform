import 'dart:math' as math;

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
    final showSkeleton = profileProvider.isLoading && profileProvider.userProfile == null;
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.surface,
            pinned: true,
            expandedHeight: 240,
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
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: showSkeleton ? const _HomeSkeleton() : const _HomeContent(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: HzSectionHeader(
              title: 'Latest stories',
              actionLabel: 'See all',
              route: '/community',
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.m),
            sliver: SliverList.separated(
              itemCount: _articles.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.l),
              itemBuilder: (context, index) => _ArticleCard(article: _articles[index]),
            ),
          ),
          SliverToBoxAdapter(
            child: HzSectionHeader(
              title: 'Recommended products',
              actionLabel: 'Browse',
              route: '/products',
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 240,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _products.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.l),
                itemBuilder: (context, index) => _ProductCard(product: _products[index]),
                cacheExtent: 1000, // Improve performance for horizontal scrolling
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: AppSpacing.xxl * 1.5)),
        ],
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
    final gradient = LinearGradient(
      colors: [
        AppColors.primary,
        AppColors.primary.withValues(alpha: 0.75),
        AppColors.secondary.withValues(alpha: 0.6),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(decoration: BoxDecoration(gradient: gradient)),
        Positioned.fill(
          child: Image.asset(
            AppAssets.heroWave,
            fit: BoxFit.cover,
            color: Colors.black.withValues(alpha: 0.08),
            colorBlendMode: BlendMode.darken,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
        Positioned(
          top: 50,
          left: media.size.width * 0.12,
          child: Transform.rotate(
            angle: -math.pi / 22,
            child: Container(
              width: media.size.width * 0.6,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.l),
                border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.4),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 28,
          right: media.size.width * 0.12,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xxl, AppSpacing.xl, AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Good morning, Hana!',
                style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Your moisture level is trending lower today. Remember to scan at 9 PM for updated insights.',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.85)),
              ),
              const SizedBox(height: AppSpacing.l),
              FilledButton.tonal(
                onPressed: () => context.push('/scan/prepare'),
                style: FilledButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.2)),
                child: const Text('Start quick scan'),
              ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(height: AppSpacing.xl),
        _InsightCards(),
        SizedBox(height: AppSpacing.xl),
        _RoutineCarousel(),
        SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: AppSpacing.xl),
        HzSkeleton.rect(height: 140, margin: EdgeInsets.symmetric(vertical: AppSpacing.s)),
        HzSkeleton.rect(height: 140, margin: EdgeInsets.symmetric(vertical: AppSpacing.s)),
        SizedBox(height: AppSpacing.l),
        HzSkeleton.rect(height: 220),
        SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _InsightCards extends StatelessWidget {
  const _InsightCards();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final children = _insights
            .map(
              (insight) => Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  margin: EdgeInsets.symmetric(
                    horizontal: isWide ? AppSpacing.m : 0,
                    vertical: isWide ? 0 : AppSpacing.m / 2,
                  ),
                  child: HzSurfaceCard(
                    padding: const EdgeInsets.all(AppSpacing.l),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(insight.icon, color: insight.iconColor, size: 26),
                        const SizedBox(height: AppSpacing.m),
                        Text(
                          insight.title,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: AppSpacing.s),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: insight.progress),
                          duration: const Duration(milliseconds: 900),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, _) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LinearProgressIndicator(
                                value: value,
                                minHeight: 6,
                                backgroundColor: AppColors.chipBg,
                                color: insight.iconColor,
                                borderRadius: BorderRadius.circular(AppRadius.s),
                              ),
                              const SizedBox(height: AppSpacing.s),
                              Text(
                                insight.caption,
                                style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList();

        if (isWide) {
          return SizedBox(
            height: 160, // Đặt chiều cao cụ thể cho Row chứa các insight cards
            child: Row(children: children),
          );
        }
        return SizedBox(
          height: 240, // Đặt chiều cao cụ thể cho Column chứa các insight cards
          child: Column(children: children),
        );
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
        Text('Today\'s routines', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppSpacing.m),
        HzResponsiveLayout(
          mobile: (_, __) => SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _routines.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.l),
              itemBuilder: (context, index) => _RoutineCard(routine: _routines[index]),
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
      width: 220,
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.l),
        color: Colors.white,
        boxShadow: AppShadows.mild,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(routine.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              Icon(routine.icon, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: routine.steps
                  .map(
                    (step) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.s / 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.circle, size: 6, color: AppColors.primary),
                          const SizedBox(width: AppSpacing.s),
                          Flexible(
                            child: Text(
                              step,
                              style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          FilledButton.tonal(
            onPressed: () => context.push('/routine'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
              backgroundColor: AppColors.secondary.withValues(alpha: 0.16),
              foregroundColor: AppColors.secondary,
            ),
            child: const Text('See details'),
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
          color: Colors.white,
          boxShadow: AppShadows.mild,
        ),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.m),
                gradient: LinearGradient(
                  colors: [
                    article.heroColor.withValues(alpha: 0.16),
                    AppColors.primary.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(article.icon, color: article.heroColor, size: 32),
            ),
            const SizedBox(width: AppSpacing.l),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    article.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 16, color: AppColors.textSecondary.withValues(alpha: 0.7)),
                      const SizedBox(width: AppSpacing.xs),
                      Text(article.readingTime, style: theme.textTheme.labelSmall),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
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
        boxShadow: AppShadows.mild,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: AppSpacing.l),
          Text(product.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.s),
          Text(
            product.benefit,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.star_rounded, color: AppColors.secondary.withValues(alpha: 0.9), size: 18),
              const SizedBox(width: AppSpacing.xs),
              Text('${product.rating.toStringAsFixed(1)} / 5', style: theme.textTheme.labelSmall),
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
  });

  final String title;
  final IconData icon;
  final List<String> steps;
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
  });

  final String name;
  final String benefit;
  final double rating;
  final IconData icon;
  final String route;
  final Color color;
  final String imageAsset;
}

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
];

const _routines = [
  _Routine(
    title: 'Morning care',
    icon: Icons.wb_sunny_outlined,
    steps: ['Enzyme cleanser', 'Chamomile toner', 'Vitamin C serum', 'Barrier cream', 'SPF 50 sunscreen'],
  ),
  _Routine(
    title: 'Night repair',
    icon: Icons.nightlight_outlined,
    steps: ['Oil cleanser', 'Gentle gel wash', 'Mild BHA toner', 'Recovery serum', 'Sleeping mask'],
  ),
];

const _articles = [
  _Article(
    title: 'Minimal night routine',
    subtitle: 'Busy evening? Here are three essential steps to keep your skin glowing.',
    icon: Icons.timeline_rounded,
    readingTime: '3 min read',
    route: '/community/detail/1',
    heroColor: Color(0xFF7C8CFF),
  ),
  _Article(
    title: 'Skin cycling in 7 days',
    subtitle: 'A gentle approach to alternating acids and recovery nights without irritation.',
    icon: Icons.autorenew_rounded,
    readingTime: '5 min read',
    route: '/community/detail/2',
    heroColor: Color(0xFFF48FB1),
  ),
];

const _products = [
  _Product(
    name: 'Skin1004 Madagascar Ampoule',
    benefit: 'Soothes sensitive skin and restores the moisture barrier in two weeks.',
    rating: 4.8,
    icon: Icons.science_outlined,
    route: '/products/serum-centella',
    color: Color(0xFF90CAF9),
    imageAsset: AppAssets.productPlaceholder,
  ),
  _Product(
    name: 'La Roche-Posay Effaclar Duo+',
    benefit: 'Targets breakouts and helps fade fresh marks without irritation.',
    rating: 4.7,
    icon: Icons.medical_services_outlined,
    route: '/products/effaclar-duo',
    color: Color(0xFFF48FB1),
    imageAsset: AppAssets.productPlaceholder,
  ),
  _Product(
    name: 'Paula’s Choice BHA 2%',
    benefit: 'Unclogs pores, refines texture, and keeps congestion under control.',
    rating: 4.9,
    icon: Icons.blur_on_outlined,
    route: '/products/pc-bha',
    color: Color(0xFFCE93D8),
    imageAsset: AppAssets.productPlaceholder,
  ),
];

