import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/constants/storage_keys.dart';

/// Reads and writes auth tokens using [FlutterSecureStorage].
@lazySingleton
class TokenStorage {
  /// Creates secure token storage.
  TokenStorage(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  /// Cached bearer token, if any.
  Future<String?> get accessToken =>
      _secureStorage.read(key: StorageKeys.accessToken);

  /// Synchronous access for Dio interceptors (in-memory cache).
  String? _cachedAccessToken;

  /// In-memory access token mirror for synchronous interceptor reads.
  String? get accessTokenSync => _cachedAccessToken;

  /// Whether a non-empty access token exists.
  Future<bool> get hasToken async {
    final token = await accessToken;
    return token != null && token.trim().isNotEmpty;
  }

  /// Persists the access token used by [Authorization] headers.
  Future<void> setAccessToken(String token) async {
    _cachedAccessToken = token;
    await _secureStorage.write(key: StorageKeys.accessToken, value: token);
  }

  /// Clears stored access token.
  Future<void> clearAccessToken() async {
    _cachedAccessToken = null;
    await _secureStorage.delete(key: StorageKeys.accessToken);
  }

  /// Reads refresh token for rotation showcase.
  Future<String?> get refreshToken =>
      _secureStorage.read(key: StorageKeys.refreshToken);

  /// Persists refresh token alongside access token on login.
  Future<void> setRefreshToken(String token) async {
    await _secureStorage.write(key: StorageKeys.refreshToken, value: token);
  }

  /// Clears refresh token on logout.
  Future<void> clearRefreshToken() async {
    await _secureStorage.delete(key: StorageKeys.refreshToken);
  }

  /// Clears all secure credentials.
  Future<void> clearAll() async {
    _cachedAccessToken = null;
    await _secureStorage.delete(key: StorageKeys.accessToken);
    await _secureStorage.delete(key: StorageKeys.refreshToken);
  }

  /// Hydrates in-memory cache from secure storage at startup.
  Future<void> hydrate() async {
    _cachedAccessToken = await accessToken;
  }
}
