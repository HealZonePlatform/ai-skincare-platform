import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wrapper over [FlutterSecureStorage] that adds an encryption layer
/// for token payloads while keeping backward compatibility with
/// previously stored plain values.
class SecureTokenStorage {
  SecureTokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';
  static const _encryptionKeyKey = 'tokenEncryptionKey';

  Future<void> write({
    required String accessToken,
    required String refreshToken,
  }) async {
    final key = await _getOrCreateKey();
    await Future.wait([
      _storage.write(
        key: _accessTokenKey,
        value: _encrypt(accessToken, key),
      ),
      _storage.write(
        key: _refreshTokenKey,
        value: _encrypt(refreshToken, key),
      ),
    ]);
  }

  Future<Map<String, String>?> readTokens() async {
    final values = await _storage.readAll();
    final access = values[_accessTokenKey];
    final refresh = values[_refreshTokenKey];
    if (access == null || refresh == null) {
      return null;
    }

    final key = await _getOrCreateKey();
    try {
      return {
        'accessToken': _decrypt(access, key),
        'refreshToken': _decrypt(refresh, key),
      };
    } catch (_) {
      // Fallback for legacy unencrypted values.
      return {
        'accessToken': access,
        'refreshToken': refresh,
      };
    }
  }

  Future<String?> readAccessToken() async {
    final tokens = await readTokens();
    return tokens?['accessToken'];
  }

  Future<String?> readRefreshToken() async {
    final tokens = await readTokens();
    return tokens?['refreshToken'];
  }

  Future<void> clear() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  Future<String> _getOrCreateKey() async {
    final existing = await _storage.read(key: _encryptionKeyKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final keyBytes =
        List<int>.generate(32, (_) => Random.secure().nextInt(255));
    final key = base64UrlEncode(keyBytes);
    await _storage.write(key: _encryptionKeyKey, value: key);
    return key;
  }

  String _encrypt(String value, String base64Key) {
    final key = Key.fromBase64(base64Key);
    final ivBytes = Uint8List.fromList(
        List<int>.generate(16, (_) => Random.secure().nextInt(255)));
    final iv = IV(ivBytes);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(value, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  String _decrypt(String cipherText, String base64Key) {
    final key = Key.fromBase64(base64Key);
    final parts = cipherText.split(':');
    if (parts.length != 2) {
      throw const FormatException('Invalid cipher format');
    }
    final iv = IV.fromBase64(parts[0]);
    final encrypted = Encrypted.fromBase64(parts[1]);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
