import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ai_skincare_platform/presentation/providers/auth_provider.dart';
import 'package:ai_skincare_platform/presentation/providers/home_provider.dart';
import 'package:ai_skincare_platform/presentation/providers/user_profile_provider.dart';
import 'package:ai_skincare_platform/presentation/screens/home/models/home_models.dart';
import 'package:ai_skincare_platform/presentation/screens/home/widgets/article_list.dart';
import 'package:ai_skincare_platform/presentation/screens/home/widgets/coach_card.dart';
import 'package:ai_skincare_platform/presentation/screens/home/widgets/hero_header.dart';
import 'package:ai_skincare_platform/presentation/screens/home/widgets/insight_cards.dart';
import 'package:ai_skincare_platform/presentation/screens/home/widgets/product_carousel.dart';
import 'package:ai_skincare_platform/presentation/screens/home/widgets/pulse_card.dart';
import 'package:ai_skincare_platform/presentation/screens/home/widgets/routine_carousel.dart';
import 'package:ai_skincare_platform/presentation/widgets/brand_logo.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_skeleton.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadDashboard();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeProvider = context.watch<HomeProvider>();
    final profileProvider = context.watch<UserProfileProvider>();

    final viewData = homeProvider.dashboard != null
        ? HomeViewData.fromEntity(homeProvider.dashboard!)
        : null;

    final showSkeleton = (homeProvider.isLoading && viewData == null) ||
        (profileProvider.isLoading && profileProvider.userProfile == null);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(homeProvider),
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.surface,
              pinned: true,
              expandedHeight: 380,
              leading: const SizedBox.shrink(),
              titleSpacing: 0,
              title: const BrandLogo(compact: true, size: 28),
              flexibleSpace: FlexibleSpaceBar(
                background: HeroHeader(
                  greetingName: profileProvider.userProfile?.fullName ??
                      viewData?.greetingName ??
                      'there',
                  heroStats: viewData?.heroStats ?? [],
                  score: viewData?.pulse.score ?? 0,
                ),
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
                  AppSpacing.xl,
                  AppSpacing.l,
                  AppSpacing.xl,
                  0,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _buildBodyContent(
                    theme: theme,
                    viewData: viewData,
                    showSkeleton: showSkeleton,
                    homeProvider: homeProvider,
                  ),
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
            ArticleList(articles: viewData?.articles ?? const []),
            const SliverToBoxAdapter(
              child: HzSectionHeader(
                title: 'Recommended products',
                subtitle: 'Fastest wins for your current skin state',
                actionLabel: 'Browse',
                route: '/products',
              ),
            ),
            ProductCarousel(products: viewData?.products ?? const []),
            const SliverPadding(
                padding: EdgeInsets.only(bottom: AppSpacing.xxl * 1.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent({
    required ThemeData theme,
    required HomeViewData? viewData,
    required bool showSkeleton,
    required HomeProvider homeProvider,
  }) {
    if (showSkeleton) {
      return const HomeSkeleton();
    }
    if (homeProvider.status == HomeLoadStatus.error) {
      return HomeError(
        message: homeProvider.error ?? 'Could not load dashboard data.',
        onRetry: () => homeProvider.retry(),
      );
    }
    if (viewData == null) {
      return const HomeSkeleton();
    }
    return HomeContent(viewData: viewData);
  }

  Future<void> _onRefresh(HomeProvider homeProvider) async {
    await homeProvider.loadDashboard(forceRefresh: true);
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key, required this.viewData});

  final HomeViewData viewData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PulseCard(pulse: viewData.pulse, highlights: viewData.pulseHighlights),
        const SizedBox(height: AppSpacing.l),
        InsightCards(insights: viewData.insights),
        const SizedBox(height: AppSpacing.l),
        const CoachCard(),
        const SizedBox(height: AppSpacing.l),
        RoutineCarousel(routines: viewData.routines),
        const SizedBox(height: AppSpacing.l),
      ],
    );
  }
}

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

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

class HomeError extends StatelessWidget {
  const HomeError({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return HzSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Something went wrong',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            message,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.m),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
