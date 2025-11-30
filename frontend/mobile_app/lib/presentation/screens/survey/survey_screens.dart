import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_buttons.dart';

class SurveySkinTypeScreen extends StatefulWidget {
  const SurveySkinTypeScreen({super.key});

  @override
  State<SurveySkinTypeScreen> createState() => _SurveySkinTypeScreenState();
}

class _SurveySkinTypeScreenState extends State<SurveySkinTypeScreen> {
  String? _selected;
  final _options = const [
    'Normal skin',
    'Sensitive skin',
    'Oily skin',
    'Dry skin',
    'Combination skin',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your skin type')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Which skin type best describes you?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.m),
              Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.s,
                children: [
                  for (final option in _options)
                    ChoiceChip(
                      label: Text(option),
                      selected: _selected == option,
                      onSelected: (_) => setState(() => _selected = option),
                    ),
                ],
              ),
              const Spacer(),
              HzPrimaryButton(
                label: 'Continue',
                icon: Icons.navigate_next,
                onPressed: _selected == null
                    ? null
                    : () => context.push('/survey/concerns'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SurveyConcernsScreen extends StatefulWidget {
  const SurveyConcernsScreen({super.key});

  @override
  State<SurveyConcernsScreen> createState() => _SurveyConcernsScreenState();
}

class _SurveyConcernsScreenState extends State<SurveyConcernsScreen> {
  final _selected = <String>{};
  final _items = const [
    'Inflamed acne',
    'Clogged pores',
    'Blackheads',
    'Dry or tight skin',
    'Dark spots',
    'Redness or irritation',
    'Enlarged pores',
    'Dull tone',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your current concerns')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select up to 4 concerns you are experiencing.',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.m),
              Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.s,
                children: [
                  for (final item in _items)
                    FilterChip(
                      label: Text(item),
                      selected: _selected.contains(item),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            if (_selected.length < 4) {
                              _selected.add(item);
                            }
                          } else {
                            _selected.remove(item);
                          }
                        });
                      },
                    ),
                ],
              ),
              const Spacer(),
              HzPrimaryButton(
                label: 'Finish survey',
                icon: Icons.check_circle_outline,
                onPressed: _selected.isEmpty ? null : () => context.go('/home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
