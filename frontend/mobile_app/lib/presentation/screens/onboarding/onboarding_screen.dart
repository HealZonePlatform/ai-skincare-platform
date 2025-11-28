import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_buttons.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/onboarding_1.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: AppColors.background),
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.6),
                  Colors.black.withValues(alpha: 0.9),
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.m,
                      vertical: AppSpacing.s,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                        const SizedBox(width: AppSpacing.s),
                        Text(
                          'AI-Powered Analysis',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.l),
                  Text(
                    'Your Personal\nSkincare Expert',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    'HealZone analyzes your skin to create a personalized routine that evolves with you.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push('/preferences/categories'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: AppColors.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.l),
                      ),
                      child: const Text('Get Started'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.l),
                ],
              ),
            ),
          ),
        ],
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
