import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/core/logging/app_logger.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityService {
  ConnectivityService._();

  static final ConnectivityService instance = ConnectivityService._();

  final Connectivity _connectivity = Connectivity();
  final ValueNotifier<ConnectivityStatus> statusNotifier =
      ValueNotifier<ConnectivityStatus>(ConnectivityStatus.online);
  final Map<String, Future<void> Function()> _pendingRetries = {};

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Future<void> initialize() async {
    final results = await _connectivity.checkConnectivity();
    final first =
        results.isNotEmpty ? results.first : ConnectivityResult.none;
    _updateStatus(first);
    _subscription = _connectivity.onConnectivityChanged.listen(
      (results) {
        final first = results.isNotEmpty
            ? results.first
            : ConnectivityResult.none;
        _updateStatus(first);
      },
      onError: (e) {
        AppLogger.error('Connectivity stream error', error: e);
      },
    );
  }

  void dispose() {
    _subscription?.cancel();
  }

  bool get isOffline => statusNotifier.value == ConnectivityStatus.offline;

  void registerRetry(String key, Future<void> Function() action) {
    _pendingRetries[key] = action;
  }

  void clearRetry(String key) {
    _pendingRetries.remove(key);
  }

  Future<void> runQueuedRetries() => _runPendingRetries();

  void _updateStatus(ConnectivityResult result) {
    final next = _mapResult(result);
    if (statusNotifier.value != next) {
      statusNotifier.value = next;
      if (next == ConnectivityStatus.online) {
        _runPendingRetries();
      }
    }
  }

  ConnectivityStatus _mapResult(ConnectivityResult result) {
    return result == ConnectivityResult.none
        ? ConnectivityStatus.offline
        : ConnectivityStatus.online;
  }

  Future<void> _runPendingRetries() async {
    if (_pendingRetries.isEmpty) return;
    final actions =
        Map<String, Future<void> Function()>.from(_pendingRetries);
    _pendingRetries.clear();
    for (final entry in actions.entries) {
      try {
        await entry.value();
      } catch (error, stackTrace) {
        AppLogger.error(
          'Retry ${entry.key} failed',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }
}
