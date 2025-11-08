import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan history')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.xl),
        itemBuilder: (context, index) {
          final score = 80 - index * 3;
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              child: Text('${index + 1}'),
            ),
            title: Text('Scan session ${index + 1}'),
            subtitle: Text('Overall score: $score • ${14 + index} days ago'),
            trailing: IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {},
            ),
          );
        },
        separatorBuilder: (_, __) => const Divider(),
        itemCount: 6,
      ),
    );
  }
}
