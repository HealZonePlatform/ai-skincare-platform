import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class SpecStore {
  SpecStore._internal();
  static final SpecStore instance = SpecStore._internal();

  bool _initialized = false;

  // Tokens
  Map<String, dynamic>? _tokens;

  // Navigation
  Map<String, dynamic>? _navigation;

  // Screens mapping: route -> asset path
  final Map<String, String> _routeToAsset = {};

  Map<String, dynamic>? get tokens => _tokens;
  Map<String, dynamic>? get navigation => _navigation;

  Future<void> init() async {
    if (_initialized) return;

    // Load tokens.json
    try {
      final tokenStr = await rootBundle.loadString('healzone_spec/tokens.json');
      _tokens = json.decode(tokenStr) as Map<String, dynamic>;
    } catch (_) {}

    // Load navigation.json
    try {
      final navStr = await rootBundle.loadString('healzone_spec/navigation.json');
      _navigation = json.decode(navStr) as Map<String, dynamic>;
    } catch (_) {}

    // Build route map from all screen specs listed in AssetManifest
    try {
      final manifestStr = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifest = json.decode(manifestStr);

      final entries = manifest.keys.where((k) => k.startsWith('healzone_spec/screens/') && k.endsWith('.json'));
      for (final assetPath in entries) {
        try {
          final s = await rootBundle.loadString(assetPath);
          final data = json.decode(s) as Map<String, dynamic>;
          final route = data['route'] as String?;
          if (route != null && route.isNotEmpty) {
            _routeToAsset[route] = assetPath;
          }
        } catch (_) {
          // ignore malformed spec
        }
      }
    } catch (_) {}

    _initialized = true;
  }

  /// Returns the best matching spec asset for a given location.
  /// Supports dynamic segments like ":id".
  String? resolveSpecForLocation(String location) {
    if (!_initialized) return null;
    if (_routeToAsset.containsKey(location)) return _routeToAsset[location];

    // Try wildcard match for routes with params
    final locSegs = location.split('/');
    for (final entry in _routeToAsset.entries) {
      final pattern = entry.key;
      final pSegs = pattern.split('/');
      if (pSegs.length != locSegs.length) continue;
      var ok = true;
      for (var i = 0; i < pSegs.length; i++) {
        final p = pSegs[i];
        final l = locSegs[i];
        if (p.isEmpty && l.isEmpty) continue;
        if (p.startsWith(':')) continue; // wildcard segment
        if (p != l) {
          ok = false;
          break;
        }
      }
      if (ok) return entry.value;
    }
    return null;
  }
}

