import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ai_skincare_platform/providers/auth_provider.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final headline = Theme.of(context).textTheme.titleLarge;
    return Scaffold(
      appBar: AppBar(
        title: const Text('HealZone'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Profile',
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.l),
          children: [
            Text('Hello, Aquafina!', style: headline?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.xs),
            const Text('Your routine for today is ready. Remember to run skin scans regularly to track progress.'),
            const SizedBox(height: AppSpacing.m),
            const _SkinScoreCard(),
            const SizedBox(height: AppSpacing.l),
            const _RoutineStrip(title: 'Morning routine', steps: ['Cleanser', 'Toner', 'Serum', 'Moisturizer', 'Sunscreen']),
            const SizedBox(height: AppSpacing.m),
            const _RoutineStrip(title: 'Night routine', steps: ['Makeup remover', 'Cleanser', 'Serum', 'Recovery cream']),
            const SizedBox(height: AppSpacing.xl),
            _SectionHeader(title: 'Latest stories', onSeeAll: () => context.push('/community')),
            _HorizontalCardList(items: const [
              _CardInfo(title: 'How often should you change your face towel?', subtitle: 'HealZone experts share quick tips.', route: '/community/detail/1'),
              _CardInfo(title: 'Five steps for combination skin', subtitle: 'A morning routine adjusted for busy days.', route: '/community/detail/2'),
            ]),
            const SizedBox(height: AppSpacing.xl),
            _SectionHeader(title: 'Suggested products', onSeeAll: () => context.push('/products')),
            _HorizontalCardList(items: const [
              _CardInfo(title: 'Senka Perfect Whip', subtitle: 'Gentle cleanser with rich foam.', route: '/products/1'),
              _CardInfo(title: 'Kiehl’s Toner', subtitle: 'Balances hydration after cleansing.', route: '/products/2'),
              _CardInfo(title: 'Skin1004 Serum', subtitle: 'Supports blemish care and fading spots.', route: '/products/3'),
            ]),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _SkinScoreCard extends StatelessWidget {
  const _SkinScoreCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.mild,
      ),
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Skin score', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
              Text('Last scan: 2 weeks ago', style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: const [
              _MetricChip(label: 'Acne: 73'),
              _MetricChip(label: 'Dark spots: 80'),
              _MetricChip(label: 'Hydration: 68'),
              _MetricChip(label: 'Oil level: 62'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
      decoration: BoxDecoration(
        color: AppColors.chipBg,
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
      child: Text(label),
    );
  }
}

class _RoutineStrip extends StatelessWidget {
  const _RoutineStrip({required this.title, required this.steps});

  final String title;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppSpacing.s),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final step in steps)
                Container(
                  margin: const EdgeInsets.only(right: AppSpacing.s),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.m),
                    border: Border.all(color: AppColors.textSecondary.withOpacityFraction(0.2)),
                    color: Colors.white,
                  ),
                  child: Text(step),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: const Text('See all'),
          ),
      ],
    );
  }
}

class _CardInfo {
  const _CardInfo({required this.title, required this.subtitle, this.route});

  final String title;
  final String subtitle;
  final String? route;
}

class _HorizontalCardList extends StatelessWidget {
  const _HorizontalCardList({required this.items});

  final List<_CardInfo> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.m),
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 220,
            padding: const EdgeInsets.all(AppSpacing.l),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.l),
              boxShadow: AppShadows.mild,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.s),
                Expanded(
                  child: Text(
                    item.subtitle,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: item.route == null ? null : () => context.push(item.route!),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
