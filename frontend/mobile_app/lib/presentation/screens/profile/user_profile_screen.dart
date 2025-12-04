import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:ai_skincare_platform/core/constants/app_assets.dart';
import 'package:ai_skincare_platform/core/config/reminder_preferences.dart';
import 'package:ai_skincare_platform/core/utils/haptics.dart';
import 'package:ai_skincare_platform/domain/profile/entities/user_profile.dart';
import 'package:ai_skincare_platform/presentation/providers/auth_provider.dart';
import 'package:ai_skincare_platform/presentation/providers/theme_provider.dart';
import 'package:ai_skincare_platform/presentation/providers/user_profile_provider.dart';
import 'package:ai_skincare_platform/core/notifications/notification_service.dart';
import 'package:ai_skincare_platform/core/validation/input_validators.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_buttons.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_skeleton.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'package:ai_skincare_platform/presentation/widgets/illustrated_message.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final ImagePicker _avatarPicker = ImagePicker();
  ReminderPreferences? _reminderPreferences;
  bool _reminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);
  bool _isAvatarUploading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileProvider>().loadUserProfile();
    });
    _loadReminderPrefs();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadReminderPrefs() async {
    final prefs = await ReminderPreferences.create();
    setState(() {
      _reminderPreferences = prefs;
      _reminderEnabled = prefs.isEnabled;
      _reminderTime = prefs.timeOfDay;
    });
    if (_reminderEnabled) {
      await NotificationService.instance
          .scheduleRoutineReminder(timeOfDay: _reminderTime);
    }
  }

  Future<void> _toggleReminder(bool value) async {
    await Haptics.selection();
    final prefs = _reminderPreferences ??= await ReminderPreferences.create();
    setState(() {
      _reminderEnabled = value;
    });
    await prefs.save(enabled: value, time: _reminderTime);
    if (value) {
      await NotificationService.instance
          .scheduleRoutineReminder(timeOfDay: _reminderTime);
    } else {
      await NotificationService.instance.cancelReminder(101);
    }
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked == null) return;
    final prefs = _reminderPreferences ??= await ReminderPreferences.create();
    setState(() {
      _reminderTime = picked;
    });
    await prefs.save(enabled: _reminderEnabled, time: picked);
    if (_reminderEnabled) {
      await NotificationService.instance.scheduleRoutineReminder(
        timeOfDay: picked,
      );
    }
  }

  ImageProvider<Object>? _avatarImageProvider(String? avatarUrl) {
    if (avatarUrl == null || avatarUrl.isEmpty) return null;
    if (avatarUrl.startsWith('http')) return NetworkImage(avatarUrl);
    if (kIsWeb) return NetworkImage(avatarUrl);
    return FileImage(File(avatarUrl));
  }

  Future<void> _onAvatarPressed(UserProfileProvider provider) async {
    await Haptics.selection();
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.l)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.l,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Choose from gallery'),
                  subtitle: const Text('Use a clear, front-facing photo'),
                  onTap: () => _pickAvatar(ImageSource.gallery, provider),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('Take a new photo'),
                  subtitle: const Text('Use soft lighting for best results'),
                  onTap: () => _pickAvatar(ImageSource.camera, provider),
                ),
                const SizedBox(height: AppSpacing.s),
                TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickAvatar(
    ImageSource source,
    UserProfileProvider provider,
  ) async {
    Navigator.of(context).pop();
    final picked = await _avatarPicker.pickImage(
      source: source,
      maxWidth: 1400,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() => _isAvatarUploading = true);
    final success = await provider.uploadAvatar(picked.path);
    if (!mounted) return;
    setState(() => _isAvatarUploading = false);

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Profile photo updated.'
              : provider.errorMessage ?? 'Could not update profile photo.',
        ),
      ),
    );
  }

  List<_GoalProgressData> _goalProgress(int historyCount) {
    final consistency = (historyCount / 8).clamp(0.2, 1.0).toDouble();
    final clarity = (0.35 + historyCount * 0.03).clamp(0.25, 0.95).toDouble();
    return [
      _GoalProgressData(
        title: 'Hydration discipline',
        subtitle: 'AM/PM cleanse, SPF, light actives',
        progress: consistency,
        icon: Icons.water_drop_rounded,
        color: AppColors.primary,
      ),
      _GoalProgressData(
        title: 'Calm & repair',
        subtitle: 'Barrier support and sleep hygiene',
        progress: 0.55 + (consistency * 0.2),
        icon: Icons.health_and_safety_rounded,
        color: AppColors.accent,
      ),
      _GoalProgressData(
        title: 'Spot fading',
        subtitle: 'Vitamin C + sunscreen habit',
        progress: clarity,
        icon: Icons.wb_twilight_rounded,
        color: AppColors.secondary,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, provider, _) {
        final profile = provider.userProfile;
        final historyCount = provider.skinAnalysisHistory.length;
        final goals = _goalProgress(historyCount);

        return Scaffold(
          body: SafeArea(
            top: false,
            child: RefreshIndicator(
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
                        avatarImage: _avatarImageProvider(profile?.avatarUrl),
                        isUploadingAvatar:
                            _isAvatarUploading || provider.isUpdating,
                        onAvatarPressed: profile == null
                            ? null
                            : () => _onAvatarPressed(provider),
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
                      Consumer<ThemeProvider>(
                        builder: (context, themeProvider, _) {
                          final isDark = themeProvider.isDark;
                          return IconButton(
                            tooltip: isDark
                                ? 'Switch to light mode'
                                : 'Switch to dark mode',
                            onPressed: () async {
                              await Haptics.selection();
                              themeProvider.toggle();
                            },
                            icon: Icon(
                              isDark
                                  ? Icons.light_mode_outlined
                                  : Icons.dark_mode_outlined,
                            ),
                          );
                        },
                      ),
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
                            _GoalProgressBoard(
                              goals: goals,
                              completedScans: historyCount,
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            _ProfileMenu(
                                onChangePassword: () =>
                                    _showChangePasswordDialog(
                                        context, provider)),
                            const SizedBox(height: AppSpacing.l),
                            _ReminderCard(
                              enabled: _reminderEnabled,
                              timeOfDay: _reminderTime,
                              onToggle: _toggleReminder,
                              onPickTime: _pickReminderTime,
                            ),
                          ],
                        ),
                      ),
                    ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.xl,
                        AppSpacing.l, AppSpacing.xl, AppSpacing.s),
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
                  if (provider.skinAnalysisHistory.isEmpty &&
                      !provider.isHistoryLoading)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl, vertical: AppSpacing.l),
                        child: _EmptyHistoryState(),
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
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
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
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Change password'),
          content: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: currentController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Current password'),
                  validator: (value) =>
                      InputValidators.password(value, minLength: 6),
                ),
                const SizedBox(height: AppSpacing.m),
                TextFormField(
                  controller: newController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'New password'),
                  validator: (value) =>
                      InputValidators.password(value, minLength: 6),
                ),
                const SizedBox(height: AppSpacing.m),
                TextFormField(
                  controller: confirmController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Confirm new password'),
                  validator: (value) =>
                      InputValidators.confirmPassword(value, newController.text),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (!(formKey.currentState?.validate() ?? false)) {
                  return;
                }
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(dialogContext);

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
  const _ProfileHero({
    required this.profile,
    required this.onEditPressed,
    required this.avatarImage,
    required this.onAvatarPressed,
    this.isUploadingAvatar = false,
  });

  final UserProfile? profile;
  final VoidCallback? onEditPressed;
  final ImageProvider<Object>? avatarImage;
  final VoidCallback? onAvatarPressed;
  final bool isUploadingAvatar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final name = profile?.fullName?.isNotEmpty == true
        ? profile!.fullName!
        : 'HealZone Member';
    final email = profile?.email ?? 'Glow-first skincare';
    final since = profile?.createdAt != null
        ? profile!.createdAt!.year
        : DateTime.now().year;
    final membershipDays = profile?.createdAt != null
        ? DateTime.now().difference(profile!.createdAt!).inDays
        : 7;
    final trackerProgress =
        (membershipDays / 21).clamp(0.2, 1.0).toDouble();

    const badges = <_HeroBadge>[
      _HeroBadge(
        icon: Icons.auto_awesome_rounded,
        label: 'Premium care',
        color: AppColors.secondary,
      ),
      _HeroBadge(
        icon: Icons.spa_rounded,
        label: 'Balance focus',
        color: AppColors.accent,
      ),
      _HeroBadge(
        icon: Icons.favorite_outline,
        label: 'Kind routines',
        color: AppColors.primary,
      ),
    ];

    final metrics = [
      _HeroMetric(
        icon: Icons.local_fire_department_rounded,
        label: 'Consistency',
        value: '${membershipDays.clamp(1, 60)} days',
        color: AppColors.secondary,
      ),
      const _HeroMetric(
        icon: Icons.shield_moon_outlined,
        label: 'Barrier',
        value: 'Stable',
        color: AppColors.primary,
      ),
      _HeroMetric(
        icon: Icons.emoji_events_outlined,
        label: 'Streak',
        value: 'Level ${1 + (membershipDays ~/ 7)}',
        color: AppColors.accent,
      ),
    ];

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? AppColors.primaryGradient
                : AppColors.sunriseGradient,
          ),
        ),
        Positioned(
          right: -40,
          top: -60,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
        ),
        Positioned(
          left: -70,
          bottom: -80,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AvatarGlow(
                      avatarImage: avatarImage,
                      isUploading: isUploadingAvatar,
                      onPressed: onAvatarPressed,
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      email,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      'Member since $since',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: Colors.white.withValues(
                                          alpha: 0.85,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (onEditPressed != null)
                                IconButton(
                                  tooltip: 'Edit profile',
                                  onPressed: onEditPressed,
                                  style: IconButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withValues(alpha: 0.2),
                                    foregroundColor: Colors.white,
                                  ),
                                  icon: const Icon(Icons.edit_outlined),
                                ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.s),
                          Wrap(
                            spacing: AppSpacing.s,
                            runSpacing: AppSpacing.s,
                            children: badges
                                .map((badge) => _HeroBadgeChip(badge: badge))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.m),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: isDark ? 0.08 : 0.35,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.l),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.all(AppSpacing.xs + 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                            child: const Icon(
                              Icons.auto_graph_rounded,
                              color: AppColors.textPrimary,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s),
                          Text(
                            'Radiance tracker',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      LinearProgressIndicator(
                        value: trackerProgress,
                        minHeight: 10,
                        backgroundColor:
                            Colors.white.withValues(alpha: 0.25),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Keep a steady routine to unlock more rewards.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.m),
                Wrap(
                  spacing: AppSpacing.s,
                  runSpacing: AppSpacing.s,
                  children: metrics
                      .map((metric) => _HeroMetricChip(metric: metric))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AvatarGlow extends StatelessWidget {
  const _AvatarGlow({
    required this.avatarImage,
    required this.isUploading,
    required this.onPressed,
  });

  final ImageProvider<Object>? avatarImage;
  final bool isUploading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: 44,
      backgroundColor: Colors.white.withValues(alpha: 0.2),
      backgroundImage: avatarImage,
      child: avatarImage == null
          ? const Icon(
              Icons.face_retouching_natural,
              color: Colors.white,
              size: 36,
            )
          : null,
    );

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.glassGradient,
            boxShadow: const [
              BoxShadow(
                color: Color(0x40C5A9E0),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: avatar,
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: IconButton(
            visualDensity: VisualDensity.compact,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.textPrimary,
              padding: const EdgeInsets.all(6),
            ),
            onPressed: onPressed,
            icon: isUploading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.camera_alt_outlined, size: 16),
          ),
        ),
      ],
    );
  }
}

class _HeroBadge {
  const _HeroBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;
}

class _HeroBadgeChip extends StatelessWidget {
  const _HeroBadgeChip({required this.badge});

  final _HeroBadge badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badge.icon, size: 16, color: badge.color),
          const SizedBox(width: AppSpacing.xs),
          Text(
            badge.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric {
  const _HeroMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
}

class _HeroMetricChip extends StatelessWidget {
  const _HeroMetricChip({required this.metric});

  final _HeroMetric metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.4),
            ),
            child: Icon(metric.icon, size: 16, color: metric.color),
          ),
          const SizedBox(width: AppSpacing.s),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metric.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              Text(
                metric.value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
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

class _EmptyHistoryState extends StatelessWidget {
  const _EmptyHistoryState();

  @override
  Widget build(BuildContext context) {
    return IllustratedMessage(
      illustration: IllustrationType.emptyHistory,
      title: 'No scan history yet',
      message:
          'Start your first skin analysis to track your progress and get personalized recommendations.',
      actionLabel: 'Start first scan',
      onAction: () => context.push('/scan/permission'),
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

class _ProfileMenu extends StatelessWidget {
  const _ProfileMenu({required this.onChangePassword});

  final VoidCallback onChangePassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Account Settings'),
        const SizedBox(height: AppSpacing.s),
        _buildMenuItem(
          context,
          icon: Icons.lock_outline,
          title: 'Change Password',
          subtitle: 'Update your security credentials',
          onTap: onChangePassword,
        ),
        const SizedBox(height: AppSpacing.l),
        _buildSectionTitle(context, 'Preferences'),
        const SizedBox(height: AppSpacing.s),
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            final isDark = themeProvider.isDark;
            return _buildMenuItem(
              context,
              icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              title: 'Appearance',
              subtitle: isDark ? 'Dark Mode' : 'Light Mode',
              trailing: Switch(
                value: isDark,
                onChanged: (_) async {
                  await Haptics.selection();
                  themeProvider.toggle();
                },
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.s),
        _buildMenuItem(
          context,
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Manage your alerts',
          onTap: () {}, // TODO: Implement notification settings
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.l),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap == null
            ? null
            : () async {
                await Haptics.selection();
                onTap();
              },
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l, vertical: AppSpacing.xs),
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.s),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              )
            : null,
        trailing: trailing ??
            const Icon(Icons.chevron_right,
                size: 20, color: AppColors.textTertiary),
      ),
    );
  }
}

class _GoalProgressBoard extends StatelessWidget {
  const _GoalProgressBoard({
    required this.goals,
    required this.completedScans,
  });

  final List<_GoalProgressData> goals;
  final int completedScans;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final toNextReward = (3 - (completedScans % 3)).clamp(1, 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skincare goals',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(
          'Visual trackers for habits and routines',
          style:
              theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.m),
        ...goals
            .map((goal) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s),
                  child: _GoalProgressTile(goal: goal),
                ))
            .toList(),
        const SizedBox(height: AppSpacing.s),
        Container(
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: BoxDecoration(
            gradient: AppColors.dewdropGradient,
            borderRadius: BorderRadius.circular(AppRadius.l),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.18),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.s),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
                child: const Icon(Icons.emoji_events_outlined),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Keep glowing!',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Complete $toNextReward more scans to unlock a celebration moment.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded,
                  color: AppColors.textPrimary),
            ],
          ),
        ),
      ],
    );
  }
}

class _GoalProgressTile extends StatelessWidget {
  const _GoalProgressTile({required this.goal});

  final _GoalProgressData goal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (goal.progress * 100).clamp(0, 100).round();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.s),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: goal.color.withValues(alpha: 0.12),
                ),
                child: Icon(goal.icon, color: goal.color, size: 18),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      goal.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: goal.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '$percent%',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: goal.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: goal.progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppColors.surfaceLight,
              valueColor: AlwaysStoppedAnimation<Color>(goal.color),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalProgressData {
  const _GoalProgressData({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final double progress;
  final IconData icon;
  final Color color;
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({
    required this.enabled,
    required this.timeOfDay,
    required this.onToggle,
    required this.onPickTime,
  });

  final bool enabled;
  final TimeOfDay timeOfDay;
  final ValueChanged<bool> onToggle;
  final VoidCallback onPickTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.l)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications_active_outlined,
                    color: AppColors.primary),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Routine reminders',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        enabled
                            ? 'Scheduled at ${timeOfDay.format(context)}'
                            : 'Turn on to get gentle nudges',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: enabled,
                  onChanged: (value) async {
                    await Haptics.selection();
                    onToggle(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            Row(
              children: [
                TextButton.icon(
                  onPressed: enabled
                      ? () async {
                          await Haptics.selection();
                          onPickTime();
                        }
                      : null,
                  icon: const Icon(Icons.schedule),
                  label: const Text('Adjust reminder time'),
                ),
                const Spacer(),
                Text(
                  'Mute anytime',
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
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
    final statusColor = switch (item.status) {
      'completed' => AppColors.success,
      'pending' => AppColors.warning,
      'failed' => AppColors.danger,
      _ => AppColors.textSecondary,
    };

    final summary = item.analysisResult?['summary'] as String? ??
        'Detailed summary will appear here once the analysis is complete.';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.l),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.pushNamed(
            'analysis-detail',
            pathParameters: {'id': item.id},
            extra: item,
          ),
          borderRadius: BorderRadius.circular(AppRadius.l),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.m),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: AppColors.surfaceElevated,
                    child: Image.asset(
                      AppAssets.analysisPlaceholder,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: statusColor.withValues(alpha: 0.1),
                        alignment: Alignment.center,
                        child: Icon(Icons.image_not_supported_outlined,
                            color: statusColor.withValues(alpha: 0.5)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(item.createdAt),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                            child: Text(
                              item.status?.toUpperCase() ?? 'UNKNOWN',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Skin Analysis',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                const Icon(Icons.chevron_right,
                    color: AppColors.textTertiary, size: 20),
              ],
            ),
          ),
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
