import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellScaffold extends StatelessWidget {
  const ShellScaffold({super.key, required this.child});

  final Widget child;

  static const _tabs = <_TabItem>[
    _TabItem(route: '/home', icon: Icons.home, label: 'Trang chủ'),
    _TabItem(
        route: '/community',
        icon: Icons.people_alt_rounded,
        label: 'Cộng đồng'),
    _TabItem(route: '/history', icon: Icons.calendar_month, label: 'Lịch sử'),
    _TabItem(route: '/profile', icon: Icons.person, label: 'Hồ sơ'),
  ];

  static const _fabRoute = '/scan/prepare';

  int _currentIndex(String location) {
    for (var i = 0; i < _tabs.length; i++) {
      if (location == _tabs[i].route ||
          location.startsWith('${_tabs[i].route}/')) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _currentIndex(location);

    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(_fabRoute),
        child: const Icon(Icons.document_scanner_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < _tabs.length; i++)
                IconButton(
                  tooltip: _tabs[i].label,
                  onPressed: () => context.go(_tabs[i].route),
                  icon: Icon(
                    _tabs[i].icon,
                    color: i == currentIndex
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha((0.6 * 255).round()),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  final String route;
  final IconData icon;
  final String label;
  const _TabItem(
      {required this.route, required this.icon, required this.label});
}
