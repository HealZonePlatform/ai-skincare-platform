// lib/core/network/network_config.dart

import 'package:ai_skincare_platform/config/environment.dart';

class NetworkConfig {
  NetworkConfig._();

  static Duration get defaultTimeout => Environment.connectTimeout;
  static Duration get uploadTimeout => const Duration(minutes: 2);
  static Duration get downloadTimeout => const Duration(minutes: 1);
}
