import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/core/network/connectivity_service.dart';

class ConnectivityProvider with ChangeNotifier {
  ConnectivityProvider({ConnectivityService? service})
      : _service = service ?? ConnectivityService.instance {
    _service.statusNotifier.addListener(_handleStatusChange);
  }

  final ConnectivityService _service;

  ConnectivityStatus get status => _service.statusNotifier.value;
  bool get isOffline => status == ConnectivityStatus.offline;

  void _handleStatusChange() {
    notifyListeners();
  }

  @override
  void dispose() {
    _service.statusNotifier.removeListener(_handleStatusChange);
    super.dispose();
  }
}
