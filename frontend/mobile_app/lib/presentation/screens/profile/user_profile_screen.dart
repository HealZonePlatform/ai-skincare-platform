import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ai_skincare_platform/core/constants/app_assets.dart';
import 'package:ai_skincare_platform/domain/profile/entities/user_profile.dart';
import 'package:ai_skincare_platform/presentation/providers/auth_provider.dart';
import 'package:ai_skincare_platform/presentation/providers/user_profile_provider.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_buttons.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_skeleton.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileProvider>().loadUserProfile();
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, provider, _) {
        final profile = provider.userProfile;

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () => provider.loadUserProfile(forceRefresh: true),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverAppBar(
                  expandedHeight: 230,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  leading: Navigator.of(context).canPop()
                      ? const BackButton()
                      : const SizedBox.shrink(),
                  flexibleSpace: FlexibleSpaceBar(
                    background: _ProfileHero(
                      profile: profile,
                      onEditPressed: profile == null
                          ? null
                          : () => _showEditSheet(
                                context,
                                provider,
                                profile.fullName,
                                profile.phoneNumber,
                              ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      tooltip: 'Sign out',
                      onPressed: () => context.read<AuthProvider>().logout(),
                      icon: const Icon(Icons.logout_rounded),
                    ),
                  ],
                ),
                if (provider.isLoading && profile == null)
                  const SliverToBoxAdapter(child: _ProfileSkeleton())
                else
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.xl,
                          AppSpacing.xl, AppSpacing.xl, AppSpacing.l),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _QuickStats(provider: provider),
                          const SizedBox(height: AppSpacing.xl),
                          _ActionCards(
                              onChangePassword: () =>
                                  _showChangePasswordDialog(context, provider)),
                        ],
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl, AppSpacing.l, AppSpacing.xl, AppSpacing.s),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Skin analysis history',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        TextButton(
                          onPressed: () => context.push('/history'),
                          child: const Text('Compare results'),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  sliver: provider.isHistoryLoading &&
                          provider.skinAnalysisHistory.isEmpty
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => const Padding(
                              padding: EdgeInsets.only(bottom: AppSpacing.m),
                              child: HzSkeleton.rect(
                                  height: 96, width: double.infinity),
                            ),
                            childCount: 4,
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final history =
                                  provider.skinAnalysisHistory[index];
                              return _HistoryTile(item: history);
                            },
                            childCount: provider.skinAnalysisHistory.length,
                          ),
                        ),
                ),
                if (provider.hasMoreHistory)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl, vertical: AppSpacing.l),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: OutlinedButton.icon(
                          onPressed: provider.isHistoryLoading
                              ? null
                              : () => provider.loadSkinAnalysisHistory(
                                  loadMore: true),
                          icon: provider.isHistoryLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.expand_more),
                          label: const Text('Load more history'),
                        ),
                      ),
                    ),
                  ),
                const SliverPadding(
                    padding: EdgeInsets.only(bottom: AppSpacing.xxl * 1.5)),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showEditSheet(
    BuildContext context,
    UserProfileProvider provider,
    String? fullName,
    String? phoneNumber,
  ) async {
    _fullNameController.text = fullName ?? '';
    _phoneController.text = phoneNumber ?? '';

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.l)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom +
                AppSpacing.xl,
            top: AppSpacing.l,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit profile',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.l),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  prefixIcon: Icon(Icons.call_outlined),
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              HzPrimaryButton(
                label: 'Save changes',
                icon: Icons.save_outlined,
                onPressed: () async {
                  final navigator = Navigator.of(bottomSheetContext);
                  final messenger = ScaffoldMessenger.of(context);
                  final success = await provider.updateUserProfile(
                    fullName: _fullNameController.text.trim(),
                    phoneNumber: _phoneController.text.trim(),
                  );
                  if (!mounted) return;
                  navigator.pop();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Profile updated successfully.'
                            : provider.errorMessage ??
                                'Could not update profile.',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showChangePasswordDialog(
      BuildContext context, UserProfileProvider provider) async {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Change password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Current password'),
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: newController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New password'),
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Confirm new password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(dialogContext);

                if (newController.text.trim() !=
                    confirmController.text.trim()) {
                  messenger.showSnackBar(const SnackBar(
                      content: Text('New password does not match.')));
                  return;
                }

                final success = await provider.changePassword(
                  currentPassword: currentController.text.trim(),
                  newPassword: newController.text.trim(),
                );
                if (!mounted) return;

                navigator.pop();
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Password updated successfully.'
                          : provider.errorMessage ??
                              'Could not change password.',
                    ),
                  ),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.profile, required this.onEditPressed});

  final UserProfile? profile;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = profile?.fullName?.isNotEmpty == true
        ? profile!.fullName!
        : 'HealZone member';
    final since = profile?.createdAt != null
        ? profile!.createdAt!.year
        : DateTime.now().year;

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6F52ED), Color(0xFF8A8E5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned.fill(
          child: Image.asset(
            AppAssets.analysisPlaceholder,
            fit: BoxFit.cover,
            color: Colors.black.withValues(alpha: 0.35),
            colorBlendMode: BlendMode.darken,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl, AppSpacing.xxl, AppSpacing.xl, AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.white.withValues(alpha: 0.18),
                child: Text(
                  name.isNotEmpty ? name.characters.first.toUpperCase() : 'U',
                  style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              Text(
                name,
                style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Healing journey with HealZone since $since',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.white.withValues(alpha: 0.85)),
              ),
              const SizedBox(height: AppSpacing.m),
              Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.s,
                children: [
                  InputChip(
                    backgroundColor: Colors.white.withValues(alpha: 0.16),
                    avatar: const Icon(Icons.email_outlined,
                        size: 18, color: Colors.white),
                    label: Text(profile?.email ?? 'Syncing email...',
                        style: const TextStyle(color: Colors.white)),
                    onPressed: () {},
                  ),
                  if (onEditPressed != null)
                    InputChip(
                      backgroundColor: Colors.white.withValues(alpha: 0.16),
                      avatar: const Icon(Icons.edit_outlined,
                          size: 18, color: Colors.white),
                      label: const Text('Edit profile',
                          style: TextStyle(color: Colors.white)),
                      onPressed: onEditPressed,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          HzSkeleton.rect(height: 120, width: double.infinity),
          SizedBox(height: AppSpacing.l),
          HzSkeleton.rect(height: 64, width: double.infinity),
          SizedBox(height: AppSpacing.l),
          HzSkeleton.rect(height: 64, width: double.infinity),
        ],
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.provider});

  final UserProfileProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final history = provider.skinAnalysisHistory;
    final latest = history.isNotEmpty ? history.first : null;
    final strengths =
        (latest?.analysisResult?['strengths'] as List?)?.length ?? 0;
    final confidence =
        ((latest?.analysisResult?['confidenceScore'] ?? 0.0) * 100).round();

    final stats = [
      _StatItem(
        icon: Icons.schedule_outlined,
        title: 'Recent scan',
        description: latest == null
            ? 'Waiting for a new scan'
            : _formatDate(latest.createdAt),
      ),
      _StatItem(
        icon: Icons.star_rate_rounded,
        title: 'Skin strengths',
        description: strengths == 0
            ? 'Building insights...'
            : '$strengths highlighted areas',
      ),
      _StatItem(
        icon: Icons.timeline_rounded,
        title: 'Model confidence',
        description: latest == null ? 'Pending analysis' : '$confidence%',
      ),
    ];

    final isWide = MediaQuery.of(context).size.width > 620;
    return Wrap(
      spacing: AppSpacing.l,
      runSpacing: AppSpacing.l,
      children: stats
          .map(
            (stat) => SizedBox(
              width: isWide
                  ? (MediaQuery.of(context).size.width / 3) -
                      AppSpacing.xl * 1.8
                  : double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.l)),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(stat.icon, color: AppColors.primary),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(stat.title,
                                style: theme.textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              stat.description,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
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
          .toList(),
    );
  }

  String _formatDate(DateTime input) {
    final date = input.toLocal();
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _ActionCards extends StatelessWidget {
  const _ActionCards({required this.onChangePassword});

  final VoidCallback onChangePassword;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.l)),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shield_moon_outlined,
                            color: AppColors.primary),
                        const SizedBox(width: AppSpacing.m),
                        Text('Account security',
                            style: theme.textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    TextButton(
                      onPressed: onChangePassword,
                      child: const Text('Change password'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  'Refresh your password frequently to keep your account safe.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.l),
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.l)),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_graph_outlined,
                        color: AppColors.primary),
                    const SizedBox(width: AppSpacing.m),
                    Text('Progress tracking',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  'Run weekly scans so HealZone can tune your regimen with accurate trend data.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.item});

  final SkinAnalysisHistory item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = switch (item.status) {
      'completed' => AppColors.primary,
      'pending' => AppColors.warning,
      'failed' => AppColors.danger,
      _ => AppColors.textSecondary,
    };

    final summary = item.analysisResult?['summary'] as String? ??
        'Detailed summary will appear here once the analysis is complete.';

    return InkWell(
      onTap: () => context.goNamed(
        'analysis-detail',
        pathParameters: {'id': item.id},
        extra: item,
      ),
      borderRadius: BorderRadius.circular(AppRadius.l),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.m),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.l),
          boxShadow: AppShadows.mild,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.l),
                bottomLeft: Radius.circular(AppRadius.l),
              ),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.asset(
                  AppAssets.analysisPlaceholder,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: statusColor.withValues(alpha: 0.12),
                    alignment: Alignment.center,
                    child: Icon(Icons.image_outlined, color: statusColor),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.l),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.l, horizontal: AppSpacing.s),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Analysis • ${_formatDate(item.createdAt)}',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Chip(
                      backgroundColor: statusColor.withValues(alpha: 0.18),
                      labelStyle: theme.textTheme.labelSmall?.copyWith(
                          color: statusColor, fontWeight: FontWeight.w600),
                      visualDensity: VisualDensity.compact,
                      label: Text(item.status?.toUpperCase() ?? 'UNKNOWN'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.l),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime input) {
    final date = input.toLocal();
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _StatItem {
  const _StatItem(
      {required this.icon, required this.title, required this.description});

  final IconData icon;
  final String title;
  final String description;
}
