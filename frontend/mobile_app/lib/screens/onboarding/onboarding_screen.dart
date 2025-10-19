import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'package:ai_skincare_platform/widgets/hz_buttons.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to HealZone')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Personalize your skincare routine',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: AppSpacing.l),
                    Text(
                      'Answer a few short questions about your skin and daily habits. HealZone will craft routines and reminders tailored to you.',
                    ),
                    Spacer(),
                    _StepHighlight(
                      icon: Icons.recommend_outlined,
                      title: 'Smart routines',
                      caption: 'Morning and evening steps with flexible alternatives.',
                    ),
                    SizedBox(height: AppSpacing.m),
                    _StepHighlight(
                      icon: Icons.camera_enhance_outlined,
                      title: 'AI skin analysis',
                      caption: 'Track scan history and monitor progress.',
                    ),
                    SizedBox(height: AppSpacing.m),
                    _StepHighlight(
                      icon: Icons.notifications_active_outlined,
                      title: 'Right-time reminders',
                      caption: 'Never miss a routine or follow-up appointment.',
                    ),
                    Spacer(),
                  ],
                ),
              ),
              HzPrimaryButton(
                label: 'Get started',
                icon: Icons.arrow_forward,
                onPressed: () => context.push('/preferences/categories'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PreferencesCategoriesScreen extends StatefulWidget {
  const PreferencesCategoriesScreen({super.key});

  @override
  State<PreferencesCategoriesScreen> createState() => _PreferencesCategoriesScreenState();
}

class _PreferencesCategoriesScreenState extends State<PreferencesCategoriesScreen> {
  final _selected = <String>{};
  final _options = const [
    'Everyday care',
    'Acne control',
    'Deep hydration',
    'Anti-aging',
    'Brightening',
    'Wedding prep',
  ];

  @override
  Widget build(BuildContext context) {
    final canContinue = _selected.isNotEmpty;
    return Scaffold(
      appBar: AppBar(title: const Text('What are you focusing on?')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pick up to 3 interests so we can tailor recommendations.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.l),
              Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.s,
                children: [
                  for (final option in _options)
                    ChoiceChip(
                      label: Text(option),
                      selected: _selected.contains(option),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            if (_selected.length < 3) {
                              _selected.add(option);
                            }
                          } else {
                            _selected.remove(option);
                          }
                        });
                      },
                    ),
                ],
              ),
              const Spacer(),
              Text('Selected: ${_selected.length}/3', style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.s),
              HzPrimaryButton(
                label: 'Continue',
                icon: Icons.navigate_next,
                onPressed: canContinue ? () => context.push('/survey/skin-type') : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepHighlight extends StatelessWidget {
  const _StepHighlight({required this.icon, required this.title, required this.caption});

  final IconData icon;
  final String title;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primary.withOpacityFraction(0.12),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.xs),
              Text(caption),
            ],
          ),
        ),
      ],
    );
  }
}
