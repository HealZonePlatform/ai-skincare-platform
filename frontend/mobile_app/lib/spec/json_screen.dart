import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../providers/auth_provider.dart';
import 'spec_store.dart';
import 'widget_factory.dart';

class JsonScreen extends StatefulWidget {
  const JsonScreen({super.key, required this.routePath});

  final String routePath;

  @override
  State<JsonScreen> createState() => _JsonScreenState();
}

class _JsonScreenState extends State<JsonScreen> {
  late final Map<String, dynamic> values = {};

  void _handleAction(String action) async {
    final ctx = context;
    final auth = Provider.of<AuthProvider>(ctx, listen: false);
    if (action.startsWith('oauth:')) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('OAuth chưa được cấu hình')),
      );
      return;
    }
    if (action.startsWith('select:')) {
      // select:key:value
      final parts = action.split(':');
      if (parts.length >= 3) {
        final key = parts[1];
        final val = parts.sublist(2).join(':');
        values[key] = val;
        setState(() {});
      }
      return;
    }
    if (action.startsWith('toggle:')) {
      // toggle:key:item
      final parts = action.split(':');
      if (parts.length >= 3) {
        final key = parts[1];
        final item = parts.sublist(2).join(':');
        final list = (values[key] as List<dynamic>? ?? <String>[]).cast<String>();
        if (list.contains(item)) {
          list.remove(item);
        } else {
          list.add(item);
        }
        values[key] = list;
        setState(() {});
      }
      return;
    }

    switch (action) {
      case 'signin':
        final email = values['email']?.toString() ?? '';
        final password = values['password']?.toString() ?? '';
        if (email.isEmpty || password.isEmpty) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(content: Text('Vui lòng nhập email và mật khẩu')),
          );
          return;
        }
        final ok = await auth.login(email, password);
        if (ok && mounted) context.go('/home');
        return;
      case 'signup':
        final email = values['email']?.toString() ?? '';
        final password = values['password']?.toString() ?? '';
        if (email.isEmpty || password.isEmpty) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(content: Text('Vui lòng nhập email và mật khẩu')),
          );
          return;
        }
        final ok = await auth.register({'email': email, 'password': password});
        if (ok && mounted) context.go('/survey/skin-type');
        return;
      case 'next':
        _handleNextRoute();
        return;
      default:
        // If action is an absolute route, navigate.
        if (action.startsWith('/')) {
          if (mounted) context.go(action);
        } else if (action == 'buy' || action == 'addToRoutine' || action == 'altProducts') {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text('Đang xử lý: $action')),
          );
        } else {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text('Chưa hỗ trợ action: $action')),
          );
        }
    }
  }

  void _handleNextRoute() {
    final loc = widget.routePath;
    if (loc == '/survey/skin-type') {
      context.go('/survey/concerns');
    } else if (loc == '/survey/concerns') {
      context.go('/home');
    } else if (loc == '/checkout/method') {
      final method = (values['paymentMethod']?.toString() ?? 'card_international');
      if (method == 'e_wallet') {
        context.go('/checkout/qr');
      } else {
        context.go('/checkout/card');
      }
    } else if (loc == '/scan/prepare') {
      context.go('/scan/capture');
    } else if (loc == '/scan/capture') {
      context.go('/scan/result');
    } else if (loc == '/scan/result') {
      context.go('/advice');
    } else {
      // Default fallback
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: SpecStore.instance.init(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final asset = SpecStore.instance.resolveSpecForLocation(widget.routePath);
        if (asset == null) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.routePath)),
            body: Center(
              child: Text('No spec for "${widget.routePath}"'),
            ),
          );
        }
        return FutureBuilder<String>(
          future: rootBundle.loadString(asset),
          builder: (context, snap2) {
            if (!snap2.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            final data = json.decode(snap2.data!) as Map<String, dynamic>;
            _ensurePermissionsIfNeeded(data);
            final title = (data['title'] as String?) ?? widget.routePath;
            final widgets = (data['layout']?['widgets'] as List<dynamic>? ?? const [])
                .cast<Map>()
                .map((e) => e.cast<String, dynamic>())
                .toList();
            final factory = WidgetFactory(context, values: values, onAction: _handleAction);

            return Scaffold(
              appBar: AppBar(title: Text(title)),
              body: ListView.builder(
                itemCount: widgets.length,
                itemBuilder: (context, index) => factory.buildFromSpec(widgets[index]),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _ensurePermissionsIfNeeded(Map<String, dynamic> spec) async {
    final perms = spec['permissions'];
    if (perms is List) {
      if (perms.contains('camera')) {
        final status = await Permission.camera.status;
        if (!status.isGranted) {
          await Permission.camera.request();
        }
      }
    }
  }
}
