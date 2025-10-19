import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'package:ai_skincare_platform/widgets/hz_buttons.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> with SingleTickerProviderStateMixin {
  late final TabController _controller = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routine cá nhân'),
        bottom: TabBar(
          controller: _controller,
          tabs: const [
            Tab(text: 'Buổi sáng'),
            Tab(text: 'Buổi tối'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: const [
          _RoutineTab(steps: ['Tẩy trang nước', 'Sữa rửa mặt dịu nhẹ', 'Toner hoa cúc', 'Serum vitamin C', 'Kem chống nắng']),
          _RoutineTab(steps: ['Tẩy trang dầu', 'Sữa rửa mặt gel', 'Toner BHA', 'Serum phục hồi', 'Kem dưỡng khóa ẩm']),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.l),
        child: HzSecondaryButton(
          label: 'Xuất routine dạng PDF (sắp ra mắt)',
          icon: Icons.picture_as_pdf_outlined,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tính năng sẽ được phát hành trong bản cập nhật tới.')),
            );
          },
        ),
      ),
    );
  }
}

class _RoutineTab extends StatelessWidget {
  const _RoutineTab({required this.steps});
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.xl),
      itemBuilder: (context, index) {
        final name = steps[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.m)),
          child: ListTile(
            leading: CircleAvatar(radius: 18, child: Text('${index + 1}')),
            title: Text(name),
            subtitle: const Text('Gợi ý thay thế'),
            trailing: TextButton(onPressed: () {}, child: const Text('Sản phẩm khác')),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
      itemCount: steps.length,
    );
  }
}
