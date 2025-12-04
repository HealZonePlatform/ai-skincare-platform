
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ai_skincare_platform/core/utils/haptics.dart';
import 'package:ai_skincare_platform/presentation/providers/theme_provider.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_buttons.dart';
import 'package:ai_skincare_platform/presentation/widgets/illustrated_message.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

class ProfileOverviewScreen extends StatelessWidget {
  const ProfileOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const actions = [
      _ProfileAction(
        icon: Icons.person_outline,
        title: 'Basic information',
        subtitle: 'Name, birthday, gender',
        route: '/profile/basic',
        accent: AppColors.primary,
      ),
      _ProfileAction(
        icon: Icons.notifications_active_outlined,
        title: 'Care reminders',
        subtitle: 'Set routine and scan notifications',
        route: '/profile/reminders',
        accent: AppColors.secondary,
      ),
      _ProfileAction(
        icon: Icons.emoji_events_outlined,
        title: 'Skincare goals',
        subtitle: 'Track your improvement over time',
        route: '/profile/goals',
        accent: AppColors.accent,
      ),
      _ProfileAction(
        icon: Icons.favorite_outline,
        title: 'Lifestyle habits',
        subtitle: 'Sleep, hydration, nutrition',
        route: '/lifestyle',
        accent: AppColors.warning,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Profile overview')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.xl,
            AppSpacing.xl,
            AppSpacing.xxl,
          ),
          children: [
            const _ProfileHeroCard(
              name: 'Aquafina',
              email: 'aqua@example.com',
              skinType: 'Combination skin',
              routineStreak: 7,
              nextScanInDays: 2,
            ),
            const SizedBox(height: AppSpacing.xl),
            const _ThemeModeTile(),
            const SizedBox(height: AppSpacing.l),
            Wrap(
              spacing: AppSpacing.m,
              runSpacing: AppSpacing.m,
              children: actions
                  .map(
                    (action) => _ProfileActionTile(
                      icon: action.icon,
                      title: action.title,
                      subtitle: action.subtitle,
                      accent: action.accent,
                      onTap: () => context.push(action.route),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeroCard extends StatelessWidget {
  const _ProfileHeroCard({
    required this.name,
    required this.email,
    required this.skinType,
    required this.routineStreak,
    required this.nextScanInDays,
  });

  final String name;
  final String email;
  final String skinType;
  final int routineStreak;
  final int nextScanInDays;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = [
      _ProfileStat(
        icon: Icons.local_fire_department,
        label: 'Routine streak',
        value: '$routineStreak days',
        color: AppColors.secondary,
      ),
      _ProfileStat(
        icon: Icons.calendar_today_rounded,
        label: 'Next scan',
        value: '$nextScanInDays days',
        color: AppColors.accent,
      ),
      const _ProfileStat(
        icon: Icons.shield_moon_outlined,
        label: 'Sleep hygiene',
        value: 'On track',
        color: AppColors.primary,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: AppColors.sunriseGradient,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFEFF7), Color(0xFFE3D6F5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.spa_rounded,
                      color: AppColors.primary, size: 36),
                ),
              ),
              const SizedBox(width: AppSpacing.l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      email,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.m,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border:
                            Border.all(color: AppColors.border, width: 0.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.water_drop_outlined,
                              size: 16, color: AppColors.primary),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            skinType,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit profile',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.textPrimary,
                ),
                onPressed: () => context.push('/profile/basic'),
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.l),
          LayoutBuilder(
            builder: (context, constraints) {
              final available = constraints.maxWidth;
              final int itemsPerRow = available < 420
                  ? 2
                  : available < 640
                      ? 3
                      : 3;
              final tileWidth =
                  (available - (itemsPerRow - 1) * AppSpacing.s) / itemsPerRow;

              return Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.s,
                children: stats
                    .map(
                      (stat) => SizedBox(
                        width: tileWidth,
                        child: _ProfileStatTile(stat: stat),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileStat {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ProfileStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

class _ProfileStatTile extends StatelessWidget {
  const _ProfileStatTile({required this.stat});

  final _ProfileStat stat;

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
          Container(
            padding: const EdgeInsets.all(AppSpacing.s),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: stat.color.withValues(alpha: 0.12),
            ),
            child: Icon(stat.icon, color: stat.color, size: 18),
          ),
          const SizedBox(width: AppSpacing.s),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stat.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                stat.value,
                style: theme.textTheme.bodyMedium?.copyWith(
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

class _ThemeModeTile extends StatelessWidget {
  const _ThemeModeTile();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final currentMode = themeProvider.themeMode;

    String labelForMode(ThemeMode mode) {
      switch (mode) {
        case ThemeMode.dark:
          return 'Dark';
        case ThemeMode.light:
          return 'Light';
        case ThemeMode.system:
          return 'System';
      }
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.mild,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.m),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.dewdropGradient,
            ),
            child: Icon(
              currentMode == ThemeMode.dark
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Theme',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  'Light / Dark / Follow system',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          PopupMenuButton<ThemeMode>(
            tooltip: 'Change theme mode',
            onSelected: (mode) => themeProvider.setThemeMode(mode),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ThemeMode.system,
                child: Text('System default'),
              ),
              const PopupMenuItem(
                value: ThemeMode.light,
                child: Text('Light'),
              ),
              const PopupMenuItem(
                value: ThemeMode.dark,
                child: Text('Dark'),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.l,
                vertical: AppSpacing.s,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(color: AppColors.border),
                color: AppColors.surface,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(labelForMode(currentMode)),
                  const SizedBox(width: AppSpacing.s),
                  const Icon(Icons.expand_more_rounded),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaWidth = MediaQuery.of(context).size.width;
        final maxWidth =
            constraints.maxWidth.isFinite ? constraints.maxWidth : mediaWidth;
        final twoColumnWidth =
            (maxWidth - AppSpacing.m) / 2; // spacing accounted for
        final targetWidth = maxWidth < 520 ? maxWidth : twoColumnWidth;

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: targetWidth),
            child: Ink(
              padding: const EdgeInsets.all(AppSpacing.l),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accent.withValues(alpha: 0.18),
                    Colors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(color: AppColors.border),
                boxShadow: AppShadows.softGlow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent.withValues(alpha: 0.18),
                    ),
                    child: Icon(icon, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Row(
                    children: [
                      Text(
                        'Open',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      const Icon(Icons.arrow_outward_rounded, size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
class ProfileBasicScreen extends StatefulWidget {
  const ProfileBasicScreen({super.key});

  @override
  State<ProfileBasicScreen> createState() => _ProfileBasicScreenState();
}

class _ProfileBasicScreenState extends State<ProfileBasicScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Aquafina');
  final _phoneController = TextEditingController(text: '0909 000 000');
  DateTime? _dob;
  String? _gender = 'female';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic information')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.l),
                decoration: BoxDecoration(
                  gradient: AppColors.dewdropGradient,
                  borderRadius: BorderRadius.circular(AppRadius.l),
                  boxShadow: AppShadows.softGlow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Keep your profile fresh',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Accurate info helps tailor routines and scan reminders.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: 'Full name',
                        helperText: 'Use your real name for personalization',
                        prefixIcon: const Icon(Icons.person_outline),
                        suffixIcon: _nameController.text.trim().isEmpty
                            ? null
                            : const Icon(
                                Icons.check_circle,
                                color: AppColors.accent,
                                size: 18,
                              ),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Please enter your name'
                              : null,
                    ),
                    const SizedBox(height: AppSpacing.m),
                    TextFormField(
                      controller: _phoneController,
                      onChanged: (_) => setState(() {}),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone number',
                        helperText: 'Used for delivery and support only',
                        prefixIcon: const Icon(Icons.phone_outlined),
                        suffixIcon: _phoneController.text.trim().length >= 9
                            ? const Icon(Icons.check_circle,
                                color: AppColors.accent, size: 18)
                            : null,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.m),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _gender,
                            decoration: const InputDecoration(
                              labelText: 'Gender',
                              prefixIcon: Icon(Icons.wc_outlined),
                            ),
                            items: const [
                              DropdownMenuItem(
                                  value: 'female', child: Text('Female')),
                              DropdownMenuItem(
                                  value: 'male', child: Text('Male')),
                              DropdownMenuItem(
                                  value: 'other', child: Text('Other')),
                            ],
                            onChanged: (value) =>
                                setState(() => _gender = value),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.m),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(AppRadius.m),
                            onTap: _pickDob,
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Birthday',
                                prefixIcon: Icon(Icons.cake_outlined),
                              ),
                              child: Text(
                                _dob == null
                                    ? 'Select date'
                                    : '${_dob!.day}/${_dob!.month}/${_dob!.year}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              HzPrimaryButton(
                label: 'Save changes',
                icon: Icons.check,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 20),
      firstDate: DateTime(now.year - 80),
      lastDate: now,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated.')),
    );
    context.pop();
  }
}
class ProfileRemindersScreen extends StatefulWidget {
  const ProfileRemindersScreen({super.key});

  @override
  State<ProfileRemindersScreen> createState() => _ProfileRemindersScreenState();
}

class _ProfileRemindersScreenState extends State<ProfileRemindersScreen> {
  bool _dailyCare = true;
  TimeOfDay _dailyTime = const TimeOfDay(hour: 7, minute: 0);
  bool _nightCare = true;
  TimeOfDay _nightTime = const TimeOfDay(hour: 21, minute: 0);
  String _scanFrequency = 'weekly';

  @override
  Widget build(BuildContext context) {
    final frequencies = ['daily', 'weekly', 'biweekly', 'monthly'];
    return Scaffold(
      appBar: AppBar(title: const Text('Care reminders')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.l),
              decoration: BoxDecoration(
                gradient: AppColors.sunriseGradient,
                borderRadius: BorderRadius.circular(AppRadius.l),
              ),
              child: Wrap(
                spacing: AppSpacing.m,
                runSpacing: AppSpacing.s,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.m),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                    child: const Icon(Icons.notifications_active_outlined),
                  ),
                  SizedBox(
                    width: 260,
                    child: Text(
                      'Never miss a glow moment\nSmart reminders for morning care, night recovery and scans.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.25,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            _ReminderCard(
              title: 'Morning routine',
              subtitle: 'Daily hydration and SPF',
              active: _dailyCare,
              timeLabel: _dailyTime.format(context),
              icon: Icons.wb_sunny_outlined,
              accent: AppColors.secondary,
              onToggle: (value) async {
                await Haptics.selection();
                if (!mounted) return;
                setState(() => _dailyCare = value);
              },
              onChangeTime: () => _pickTime(isNight: false),
            ),
            const SizedBox(height: AppSpacing.m),
            _ReminderCard(
              title: 'Night recovery',
              subtitle: 'Treatment and calming mask',
              active: _nightCare,
              timeLabel: _nightTime.format(context),
              icon: Icons.nightlight_round,
              accent: AppColors.primary,
              onToggle: (value) async {
                await Haptics.selection();
                if (!mounted) return;
                setState(() => _nightCare = value);
              },
              onChangeTime: () => _pickTime(isNight: true),
            ),
            const SizedBox(height: AppSpacing.l),
            Text(
              'Scheduled skin scans',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.s),
            Wrap(
              spacing: AppSpacing.s,
              children: frequencies
                  .map(
                    (freq) => ChoiceChip(
                      label: Text(freq[0].toUpperCase() + freq.substring(1)),
                      selected: _scanFrequency == freq,
                      onSelected: (_) async {
                        await Haptics.selection();
                        if (!mounted) return;
                        setState(() => _scanFrequency = freq);
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.xl),
            HzPrimaryButton(
              label: 'Save changes',
              icon: Icons.save_outlined,
              onPressed: _saveChanges,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime({required bool isNight}) async {
    final selectedTime = isNight ? _nightTime : _dailyTime;
    final picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked == null) return;
    setState(() {
      if (isNight) {
        _nightTime = picked;
      } else {
        _dailyTime = picked;
      }
    });
  }

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reminders saved (demo mode).')),
    );
    context.pop();
  }
}
class ProfileGoalsScreen extends StatefulWidget {
  const ProfileGoalsScreen({super.key});

  @override
  State<ProfileGoalsScreen> createState() => _ProfileGoalsScreenState();
}

class _ProfileGoalsScreenState extends State<ProfileGoalsScreen> {
  final _controller = TextEditingController();
  final _goals = <_GoalItem>[
    const _GoalItem(
      title: 'Reduce active acne',
      focus: 'Clarity',
      progress: 0.42,
      color: AppColors.secondary,
      icon: Icons.spa_outlined,
    ),
    const _GoalItem(
      title: 'Fade dark spots',
      focus: 'Radiance',
      progress: 0.28,
      color: AppColors.accent,
      icon: Icons.wb_twilight,
    ),
  ];
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _completeGoal(int index) async {
    await Haptics.success();
    if (!mounted) return;
    setState(() {
      _goals[index] = _goals[index].copyWith(progress: 1.0, isCompleted: true);
    });
    _confettiController.play();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Goal "${_goals[index].title}" completed!'),
      ),
    );
  }

  void _addGoal() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _goals.add(
        _GoalItem(
          title: text,
          focus: 'Custom',
          progress: 0.1,
          color: AppColors.primary,
          icon: Icons.auto_awesome_outlined,
        ),
      );
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skincare goals')),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ListView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  decoration: BoxDecoration(
                    gradient: AppColors.dewdropGradient,
                    borderRadius: BorderRadius.circular(AppRadius.l),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.m),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        child: const Icon(Icons.emoji_events_outlined),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Micro wins matter',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Celebrate progress with visuals, not just checkboxes.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
                if (_goals.isEmpty)
                  const IllustratedMessage(
                    icon: Icons.flag_outlined,
                    title: 'No goals yet',
                    message:
                        'Set your first target to unlock personalized routines and progress streaks.',
                    illustration: IllustrationType.emptyGoals,
                  )
                else
                  ..._goals.asMap().entries.map(
                    (entry) {
                      final index = entry.key;
                      final goal = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.m),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.l),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius:
                                BorderRadius.circular(AppRadius.xl),
                            border: Border.all(color: AppColors.border),
                            boxShadow: AppShadows.mild,
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
                                      color: goal.color.withValues(alpha: 0.18),
                                    ),
                                    child: Icon(goal.icon,
                                        color: goal.color, size: 20),
                                  ),
                                  const SizedBox(width: AppSpacing.m),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          goal.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        Text(
                                          goal.focus,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppColors.textSecondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Remove',
                                    onPressed: () => setState(
                                        () => _goals.removeAt(index)),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.s),
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.full),
                                child: LinearProgressIndicator(
                                  value: goal.progress.clamp(0.0, 1.0),
                                  minHeight: 10,
                                  backgroundColor:
                                      AppColors.border.withValues(alpha: 0.6),
                                  valueColor: AlwaysStoppedAnimation(
                                      goal.color.withValues(alpha: 0.9)),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.s),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    goal.isCompleted
                                        ? 'Completed'
                                        : '${(goal.progress * 100).round()}% to go',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: goal.isCompleted
                                              ? AppColors.accentDark
                                              : AppColors.textSecondary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  TextButton.icon(
                                    onPressed: goal.isCompleted
                                        ? null
                                        : () => _completeGoal(index),
                                    icon: const Icon(Icons.check_circle_outline),
                                    label: Text(goal.isCompleted
                                        ? 'Done'
                                        : 'Mark complete'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: AppSpacing.m),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Add a new goal',
                    prefixIcon: Icon(Icons.add_task_outlined),
                  ),
                  onSubmitted: (_) => _addGoal(),
                ),
                const SizedBox(height: AppSpacing.m),
                HzPrimaryButton(
                  label: 'Add goal',
                  icon: Icons.add,
                  onPressed: _addGoal,
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppColors.primary,
                AppColors.secondary,
                AppColors.accent,
                AppColors.primaryDark,
                AppColors.secondaryDark,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class _ReminderCard extends StatelessWidget {
  const _ReminderCard({
    required this.title,
    required this.subtitle,
    required this.active,
    required this.timeLabel,
    required this.icon,
    required this.accent,
    required this.onToggle,
    required this.onChangeTime,
  });

  final String title;
  final String subtitle;
  final bool active;
  final String timeLabel;
  final IconData icon;
  final Color accent;
  final ValueChanged<bool> onToggle;
  final VoidCallback onChangeTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.mild,
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
                  color: accent.withValues(alpha: 0.16),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
              ],
            ),
          ),
          Switch.adaptive(
            value: active,
            onChanged: onToggle,
            thumbColor: WidgetStateProperty.all(accent),
            activeTrackColor: accent.withValues(alpha: 0.4),
          ),
        ],
      ),
          const SizedBox(height: AppSpacing.s),
          Wrap(
            spacing: AppSpacing.m,
            runSpacing: AppSpacing.s,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.s,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time, size: 18),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      timeLabel,
                      style: theme.textTheme.labelMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: onChangeTime,
                child: const Text('Adjust'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalItem {
  final String title;
  final String focus;
  final double progress;
  final Color color;
  final IconData icon;
  final bool isCompleted;

  const _GoalItem({
    required this.title,
    required this.focus,
    required this.progress,
    required this.color,
    required this.icon,
    this.isCompleted = false,
  });

  _GoalItem copyWith({
    String? title,
    String? focus,
    double? progress,
    Color? color,
    IconData? icon,
    bool? isCompleted,
  }) {
    return _GoalItem(
      title: title ?? this.title,
      focus: focus ?? this.focus,
      progress: progress ?? this.progress,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class _ProfileAction {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final Color accent;

  const _ProfileAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.accent,
  });
}

