import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_buttons.dart';

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
      ),
      _ProfileAction(
        icon: Icons.notifications_active_outlined,
        title: 'Care reminders',
        subtitle: 'Set routine and scan notifications',
        route: '/profile/reminders',
      ),
      _ProfileAction(
        icon: Icons.emoji_events_outlined,
        title: 'Skincare goals',
        subtitle: 'Track your improvement over time',
        route: '/profile/goals',
      ),
      _ProfileAction(
        icon: Icons.favorite_outline,
        title: 'Lifestyle habits',
        subtitle: 'Sleep, hydration, nutrition',
        route: '/lifestyle',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Profile overview')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          const _ProfileHeader(
            name: 'Aquafina',
            email: 'aqua@example.com',
            skinType: 'Combination skin',
          ),
          const SizedBox(height: AppSpacing.xl),
          for (final action in actions)
            _ProfileActionTile(
              icon: action.icon,
              title: action.title,
              subtitle: action.subtitle,
              onTap: () => context.push(action.route),
            ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.name, required this.email, required this.skinType});

  final String name;
  final String email;
  final String skinType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.l),
        boxShadow: AppShadows.mild,
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 30)),
          const SizedBox(width: AppSpacing.l),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                Text(email, style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.s),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s / 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.s),
                  ),
                  child: Text('Skin type: $skinType'),
                ),
              ],
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
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.m)),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class ProfileBasicScreen extends StatefulWidget {
  const ProfileBasicScreen({super.key});

  @override
  State<ProfileBasicScreen> createState() => _ProfileBasicScreenState();
}

class _ProfileBasicScreenState extends State<ProfileBasicScreen> {
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
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full name'),
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone number'),
              ),
              const SizedBox(height: AppSpacing.m),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _gender,
                      decoration: const InputDecoration(labelText: 'Gender'),
                      items: const [
                        DropdownMenuItem(value: 'female', child: Text('Female')),
                        DropdownMenuItem(value: 'male', child: Text('Male')),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (value) => setState(() => _gender = value),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _dob ?? DateTime(now.year - 20),
                          firstDate: DateTime(now.year - 80),
                          lastDate: now,
                        );
                        if (picked != null) setState(() => _dob = picked);
                      },
                      child: Text(_dob == null
                          ? 'Birthday'
                          : '${_dob!.day}/${_dob!.month}/${_dob!.year}'),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              HzPrimaryButton(
                label: 'Save',
                icon: Icons.check,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Changes saved.')),
                  );
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
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
    return Scaffold(
      appBar: AppBar(title: const Text('Care reminders')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            SwitchListTile(
              title: const Text('Daily care reminder'),
              subtitle: Text('Reminder time: ${_dailyTime.format(context)}'),
              value: _dailyCare,
              onChanged: (value) => setState(() => _dailyCare = value),
            ),
            ListTile(
              title: const Text('Choose reminder time'),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final picked = await showTimePicker(context: context, initialTime: _dailyTime);
                if (picked != null) setState(() => _dailyTime = picked);
              },
            ),
            SwitchListTile(
              title: const Text('Nightly treatment reminder'),
              subtitle: Text('Reminder time: ${_nightTime.format(context)}'),
              value: _nightCare,
              onChanged: (value) => setState(() => _nightCare = value),
            ),
            ListTile(
              title: const Text('Choose night reminder time'),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final picked = await showTimePicker(context: context, initialTime: _nightTime);
                if (picked != null) setState(() => _nightTime = picked);
              },
            ),
            const Divider(),
            const Text('Scheduled skin scans'),
            const SizedBox(height: AppSpacing.s),
            DropdownButtonFormField<String>(
              initialValue: _scanFrequency,
              decoration: const InputDecoration(labelText: 'Frequency'),
              items: const [
                DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                DropdownMenuItem(value: 'biweekly', child: Text('Every 2 weeks')),
                DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
              ],
              onChanged: (value) => setState(() => _scanFrequency = value ?? 'weekly'),
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
  final _goals = <String>['Reduce active acne', 'Fade dark spots'];
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skincare goals')), 
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: _goals.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final goal = _goals[index];
                    return ListTile(
                      leading: const Icon(Icons.check_circle_outline),
                      title: Text(goal),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => setState(() => _goals.removeAt(index)),
                      ),
                    );
                  },
                ),
              ),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Add a new goal'),
              ),
              const SizedBox(height: AppSpacing.m),
              HzPrimaryButton(
                label: 'Add goal',
                icon: Icons.add,
                onPressed: () {
                  if (_controller.text.trim().isEmpty) return;
                  setState(() {
                    _goals.add(_controller.text.trim());
                    _controller.clear();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileAction {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  const _ProfileAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}
