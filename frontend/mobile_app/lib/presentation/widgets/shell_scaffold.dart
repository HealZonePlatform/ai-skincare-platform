import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellScaffold extends StatelessWidget {
  const ShellScaffold({super.key, required this.child});

  final Widget child;

  static const _tabs = <_TabItem>[
    _TabItem(route: '/home', icon: Icons.home, label: 'Trang ch��'),
    _TabItem(
        route: '/community',
        icon: Icons.people_alt_rounded,
        label: 'C��Tng �`��"ng'),
    _TabItem(
        route: '/history', icon: Icons.calendar_month, label: 'L��<ch s��-'),
    _TabItem(route: '/profile', icon: Icons.person, label: 'H��" s��'),
  ];

  static const _fabRoute = '/scan/permission';

  int _currentIndex(String location) {
    for (var i = 0; i < _tabs.length; i++) {
      if (location == _tabs[i].route) {
        return i;
      }
    }
    for (var i = 0; i < _tabs.length; i++) {
      if (location.startsWith('${_tabs[i].route}/')) {
        return i;
      }
    }
    if (location.startsWith('/scan')) return 0;
    if (location.startsWith('/products')) return 0;
    if (location.startsWith('/advice')) return 0;
    if (location.startsWith('/routine')) return 2;
    return 0;
  }

  bool _isScanRoute(String location) {
    return location.startsWith('/scan');
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _currentIndex(location);

    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isScanRoute(location)) {
            context.go('/home');
          } else {
            context.go(_fabRoute);
          }
        },
        child: Icon(
          _isScanRoute(location)
              ? Icons.close_rounded
              : Icons.document_scanner_outlined,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < _tabs.length; i++)
                Expanded(
                  child: InkResponse(
                    onTap: () => context.go(_tabs[i].route),
                    radius: 32,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _tabs[i].icon,
                          color: i == currentIndex
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withAlpha((0.6 * 255).round()),
                        ),
                        const SizedBox(height: 6),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 3,
                          width: 18,
                          decoration: BoxDecoration(
                            color: i == currentIndex
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        )
                      ],
                    ),
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
