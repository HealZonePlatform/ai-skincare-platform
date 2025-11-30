import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ai_skincare_platform/core/analytics/analytics_service.dart';
import 'package:ai_skincare_platform/core/utils/haptics.dart';
import 'package:ai_skincare_platform/domain/profile/entities/user_profile.dart';
import 'package:ai_skincare_platform/presentation/providers/user_profile_provider.dart';
import 'package:ai_skincare_platform/presentation/widgets/error_state.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_skeleton.dart';
import 'package:ai_skincare_platform/presentation/widgets/optimized_network_image.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _ensureInitialLoad();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _ensureInitialLoad() {
    final provider = context.read<UserProfileProvider>();
    if (provider.skinAnalysisHistory.isEmpty && !provider.isHistoryLoading) {
      provider.loadSkinAnalysisHistory();
    }
  }

  void _onScroll() {
    final provider = context.read<UserProfileProvider>();
    if (!provider.hasMoreHistory || provider.isHistoryLoading) return;
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 200) {
      provider.loadSkinAnalysisHistory(loadMore: true);
    }
  }

  Future<void> _onRefresh() async {
    await context.read<UserProfileProvider>().loadSkinAnalysisHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan history')),
      body: Consumer<UserProfileProvider>(
        builder: (context, provider, _) {
          final items = provider.skinAnalysisHistory;
          final isLoading = provider.isHistoryLoading && items.isEmpty;
          final hasError = provider.errorMessage != null && items.isEmpty;

          if (isLoading) {
            return const _HistorySkeleton();
          }

          if (hasError) {
            return ErrorState(
              title: 'Không tải được lịch sử',
              message: provider.errorMessage ?? 'Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => provider.loadSkinAnalysisHistory(),
            );
          }

          if (items.isEmpty) {
            return const _EmptyHistory();
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.all(AppSpacing.xl),
              itemCount: items.length + (provider.hasMoreHistory ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
              itemBuilder: (context, index) {
                if (index >= items.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.m),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final item = items[index];
                return _HistoryTile(item: item);
              },
            ),
          );
        },
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.item});

  final SkinAnalysisHistory item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(item.status);
    final statusLabel = (item.status ?? 'unknown').toUpperCase();
    return Semantics(
      button: true,
      label: 'Open analysis ${item.id}',
      child: InkWell(
        onTap: () async {
          await Haptics.selection();
          if (context.mounted) {
            AnalyticsService.logEvent('analysisHistoryOpen',
                parameters: {'id': item.id});
            context.pushNamed(
              'analysis-detail',
              pathParameters: {'id': item.id},
              extra: item,
            );
          }
        },
        borderRadius: BorderRadius.circular(AppRadius.l),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.l),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.l),
            border: Border.all(
              color: Theme.of(context).dividerColor,
            ),
            boxShadow: AppShadows.mild,
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.m),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: OptimizedNetworkImage(
                    imageUrl: item.imageUrl,
                    aspectRatio: 1,
                    borderRadius: AppRadius.m,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scan #${item.id}',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _formatDate(item.createdAt),
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                    if (item.analysisResult != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Result ready',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  statusLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistorySkeleton extends StatelessWidget {
  const _HistorySkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.xl),
      itemBuilder: (_, __) => const Row(
        children: [
          HzSkeleton.rect(height: 72, width: 72, borderRadius: AppRadius.m),
          SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HzSkeleton.rect(height: 14, width: 140),
                SizedBox(height: AppSpacing.s),
                HzSkeleton.rect(height: 12, width: 100),
                SizedBox(height: AppSpacing.s),
                HzSkeleton.rect(height: 12, width: 180),
              ],
            ),
          ),
        ],
      ),
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
      itemCount: 6,
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.history, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: AppSpacing.m),
            Text(
              'Chưa có phiên quét nào',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              'Thực hiện quét da để xem lịch sử và tiến trình cải thiện.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

Color _statusColor(String? status) {
  switch (status) {
    case 'completed':
      return AppColors.success;
    case 'pending':
      return AppColors.warning;
    case 'failed':
      return AppColors.danger;
    default:
      return AppColors.textSecondary;
  }
}

String _formatDate(DateTime date) {
  String twoDigits(int value) => value.toString().padLeft(2, '0');
  return '${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)} '
      '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
}
