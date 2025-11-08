// lib/core/security/secure_preferences.dart

import 'dart:convert';
import 'dart:math';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight helper that encrypts values before writing them into [SharedPreferences].
/// AES keys are generated once and stored inside [FlutterSecureStorage].
class SecurePreferences {
  SecurePreferences({
    SharedPreferences? preferences,
    FlutterSecureStorage? secureStorage,
  })  : _preferencesFuture = preferences != null
            ? Future.value(preferences)
            : SharedPreferences.getInstance(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _keyStoreKey = 'hz.secure_prefs.key';

  final Future<SharedPreferences> _preferencesFuture;
  final FlutterSecureStorage _secureStorage;

  Future<void> saveJson(String key, Map<String, dynamic> value) {
    return saveString(key, jsonEncode(value));
  }

  Future<void> saveList(String key, List<Map<String, dynamic>> value) {
    return saveString(key, jsonEncode(value));
  }

  Future<String?> readRaw(String key) async {
    final prefs = await _preferencesFuture;
    return prefs.getString(key);
  }

  Future<Map<String, dynamic>?> readJson(String key) async {
    final decrypted = await readString(key);
    if (decrypted == null || decrypted.isEmpty) {
      return null;
    }
    return jsonDecode(decrypted) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> readList(String key) async {
    final decrypted = await readString(key);
    if (decrypted == null || decrypted.isEmpty) {
      return [];
    }
    final decoded = jsonDecode(decrypted) as List<dynamic>;
    return decoded
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  Future<void> saveString(String key, String value) async {
    final prefs = await _preferencesFuture;
    final payload = await _encrypt(value);
    await prefs.setString(key, payload);
  }

  Future<String?> readString(String key) async {
    final prefs = await _preferencesFuture;
    final payload = prefs.getString(key);
    if (payload == null) {
      return null;
    }
    try {
      return await _decrypt(payload);
    } catch (_) {
      await remove(key);
      return null;
    }
  }

  Future<void> remove(String key) async {
    final prefs = await _preferencesFuture;
    await prefs.remove(key);
  }

  Future<String> _encrypt(String value) async {
    final key = encrypt.Key.fromBase64(await _fetchOrCreateKey());
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(value, iv: iv);
    return jsonEncode({
      'iv': iv.base64,
      'value': encrypted.base64,
    });
  }

  Future<String> _decrypt(String payload) async {
    final parsed = jsonDecode(payload) as Map<String, dynamic>;
    final key = encrypt.Key.fromBase64(await _fetchOrCreateKey());
    final iv = encrypt.IV.fromBase64(parsed['iv'] as String);
    final cipherText = encrypt.Encrypted.fromBase64(parsed['value'] as String);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return encrypter.decrypt(cipherText, iv: iv);
  }

  Future<String> _fetchOrCreateKey() async {
    final existing = await _secureStorage.read(key: _keyStoreKey);
    if (existing != null) {
      return existing;
    }
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    final encoded = base64UrlEncode(bytes);
    await _secureStorage.write(key: _keyStoreKey, value: encoded);
    return encoded;
  }
}
