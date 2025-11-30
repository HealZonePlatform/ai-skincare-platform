import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_buttons.dart';

class AdviceScreen extends StatelessWidget {
  const AdviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analysis & suggestions')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.l)),
              child: const Padding(
                padding: EdgeInsets.all(AppSpacing.l),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Summary of your skin',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                    SizedBox(height: AppSpacing.s),
                    Text(
                        '- T-zone is oily while the cheeks are dehydrated\n- 3 new inflamed acne spots detected\n- Light dark spots around the cheeks'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Recommended routine',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.m),
            const _RoutineList(
              title: 'Morning',
              steps: [
                'Micellar water',
                'Gentle cleanser',
                'Chamomile toner',
                'Niacinamide 10%',
                'SPF50 sunscreen'
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            const _RoutineList(
              title: 'Evening',
              steps: [
                'Oil cleanser',
                'Gel cleanser',
                'Mild BHA toner',
                'Recovery serum',
                'Nourishing night cream'
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Suggested products',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.m),
            const _ProductSuggestion(
                name: 'Skin1004 Madagascar Centella Ampoule',
                benefit: 'Soothes and reduces redness'),
            const _ProductSuggestion(
                name: 'La Roche-Posay Effaclar Duo+',
                benefit: 'Targets breakouts and fades marks'),
            const SizedBox(height: AppSpacing.xl),
            HzPrimaryButton(
              label: 'Start this routine',
              icon: Icons.play_circle_outline,
              onPressed: () => context.push('/routine'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutineList extends StatelessWidget {
  const _RoutineList({required this.title, required this.steps});
  final String title;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.m)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.s),
            for (final step in steps)
              ListTile(
                leading: const Icon(Icons.spa_outlined),
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(step),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProductSuggestion extends StatelessWidget {
  const _ProductSuggestion({required this.name, required this.benefit});
  final String name;
  final String benefit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.m)),
      child: ListTile(
        leading: const Icon(Icons.shopping_bag_outlined),
        title: Text(name),
        subtitle: Text(benefit),
        trailing: TextButton(
            onPressed: () => context.push('/products/1'),
            child: const Text('Details')),
      ),
    );
  }
}
