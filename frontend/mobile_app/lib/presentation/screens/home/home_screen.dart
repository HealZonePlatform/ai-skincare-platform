import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ai_skincare_platform/core/constants/app_assets.dart';
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
import 'package:ai_skincare_platform/presentation/widgets/illustrated_message.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_skeleton.dart';
import 'package:ai_skincare_platform/presentation/widgets/ui_kit/hz_section_header.dart';
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

  Future<void> _onRefresh(HomeProvider provider) async {
    await provider.loadDashboard(forceRefresh: true);
    if (!mounted) return;
    await context.read<UserProfileProvider>().loadUserProfile(
          forceRefresh: true,
        );
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final profileProvider = context.watch<UserProfileProvider>();

    final viewData = homeProvider.dashboard != null
        ? HomeViewData.fromEntity(homeProvider.dashboard!)
        : null;

    final showSkeleton = (homeProvider.isLoading && viewData == null) ||
        (profileProvider.isLoading && profileProvider.userProfile == null);

    return Scaffold(
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () => _onRefresh(homeProvider),
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            cacheExtent: 1200,
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(context).colorScheme.surface,
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
                    lastScanLabel: viewData?.pulse.updated ?? 'Today',
                    beforeImageAsset: AppAssets.analysisPlaceholder,
                    afterImageAsset: AppAssets.analysisPlaceholder,
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
                    context: context,
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
              if (viewData?.articles.isNotEmpty == true)
                ArticleList(articles: viewData!.articles)
              else
                SliverToBoxAdapter(
                  child: _EmptySection(
                    message: 'New skincare guides coming soon!',
                    illustration: IllustrationType.emptyArticles,
                    actionLabel: 'Browse community',
                    onAction: () => context.push('/community'),
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
              if (viewData?.products.isNotEmpty == true)
                ProductCarousel(products: viewData!.products)
              else
                const SliverToBoxAdapter(
                  child: _EmptySection(
                    message: 'We are finding the best products for you...',
                    illustration: IllustrationType.emptyProducts,
                  ),
                ),
              const SliverPadding(
                padding: EdgeInsets.only(bottom: AppSpacing.xxl * 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent({
    required BuildContext context,
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
        onAltAction: () => context.push('/scan/permission'),
      );
    }
    if (viewData == null) {
      return HomeError(
        message: 'No dashboard data yet. Pull to refresh.',
        onRetry: () => homeProvider.retry(),
      );
    }
    return HomeContent(
      viewData: viewData,
      usingCache: homeProvider.usingCache,
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key, required this.viewData, this.usingCache = false});

  final HomeViewData viewData;
  final bool usingCache;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (usingCache)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.l, vertical: AppSpacing.s),
            margin: const EdgeInsets.only(bottom: AppSpacing.m),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.m),
            ),
            child: Row(
              children: [
                const Icon(Icons.wifi_off, color: AppColors.warning, size: 18),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'Offline - showing cached dashboard',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
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
  const HomeError({
    super.key,
    required this.message,
    required this.onRetry,
    this.onAltAction,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback? onAltAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: AppColors.dewdropGradient,
          borderRadius: BorderRadius.circular(AppRadius.l),
          boxShadow: AppShadows.mild,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SkincareIllustration(
              type: IllustrationType.errorState,
              size: 180,
            ),
            const SizedBox(height: AppSpacing.l),
            Text(
              'Connection hiccup',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.m),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
                if (onAltAction != null) ...[
                  const SizedBox(width: AppSpacing.s),
                  OutlinedButton.icon(
                    onPressed: onAltAction,
                    icon: const Icon(Icons.center_focus_strong_rounded),
                    label: const Text('Quick scan'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({
    required this.message,
    required this.illustration,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final IllustrationType illustration;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxl,
        horizontal: AppSpacing.xl,
      ),
      child: IllustratedMessage(
        illustration: illustration,
        title: 'Stay tuned',
        message: message,
        actionLabel: actionLabel,
        onAction: onAction,
      ),
    );
  }
}
