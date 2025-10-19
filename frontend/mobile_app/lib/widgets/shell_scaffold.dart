import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../spec/spec_store.dart';

class ShellScaffold extends StatefulWidget {
  const ShellScaffold({super.key, required this.child});

  final Widget child;

  @override
  State<ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends State<ShellScaffold> {
  List<_TabItem> _tabs = const [];

  @override
  void initState() {
    super.initState();
    _initTabs();
  }

  Future<void> _initTabs() async {
    await SpecStore.instance.init();
    final nav = SpecStore.instance.navigation;
    final tabs = <_TabItem>[];
    if (nav != null && nav['tabs'] is List) {
      for (final t in (nav['tabs'] as List)) {
        final m = (t as Map).cast<String, dynamic>();
        final isFab = m['isFab'] == true;
        final route = m['route']?.toString() ?? '';
        final iconKey = m['icon']?.toString() ?? '';
        if (isFab) continue;
        tabs.add(_TabItem(
          route: route,
          icon: _iconFor(iconKey),
          label: (m['key'] as String?) ?? '',
        ));
      }
    } else {
      // Fallback
      _tabs = const [
        _TabItem(route: '/home', icon: Icons.home, label: 'home'),
        _TabItem(route: '/community', icon: Icons.group, label: 'community'),
        _TabItem(route: '/history', icon: Icons.calendar_today, label: 'history'),
        _TabItem(route: '/profile', icon: Icons.person, label: 'profile'),
      ];
      if (mounted) setState(() {});
      return;
    }
    _tabs = tabs;
    if (mounted) setState(() {});
  }

  static IconData _iconFor(String key) {
    switch (key) {
      case 'home':
        return Icons.home;
      case 'users':
        return Icons.group;
      case 'scan':
        return Icons.document_scanner_outlined;
      case 'calendar':
        return Icons.calendar_today;
      case 'user':
      default:
        return Icons.person;
    }
  }

  int _currentIndex(String location) {
    for (var i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].route)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final index = _currentIndex(location);
    return FutureBuilder<void>(
      future: SpecStore.instance.init(),
      builder: (context, _) {
        final nav = SpecStore.instance.navigation;
        final fabRoute = _extractFabRoute(nav);
        return Scaffold(
          body: widget.child,
          floatingActionButton: fabRoute == null
              ? null
              : FloatingActionButton(
                  onPressed: () => context.go(fabRoute),
                  child: const Icon(Icons.document_scanner_outlined),
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (var i = 0; i < _tabs.length; i++)
                    IconButton(
                      tooltip: _tabs[i].label,
                      onPressed: () => context.go(_tabs[i].route),
                      icon: Icon(
                        _tabs[i].icon,
                        color: i == index ? Theme.of(context).colorScheme.primary : null,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String? _extractFabRoute(Map<String, dynamic>? nav) {
    if (nav == null) return '/scan/prepare';
    final tabs = nav['tabs'];
    if (tabs is List) {
      for (final t in tabs) {
        final m = (t as Map).cast<String, dynamic>();
        if (m['isFab'] == true) return m['route']?.toString();
      }
    }
    return null;
  }
}

class _TabItem {
  final String route;
  final IconData icon;
  final String label;
  const _TabItem({required this.route, required this.icon, required this.label});
}
