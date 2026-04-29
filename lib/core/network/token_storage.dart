import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_flow/core/constants/storage_keys.dart';

/// Reads and writes auth tokens using [SharedPreferences] for synchronous access in Dio interceptors.
@lazySingleton
class TokenStorage {
  /// Creates token storage backed by [preferences].
  TokenStorage(this._preferences);

  final SharedPreferences _preferences;

  /// Cached bearer token, if any.
  String? get accessToken => _preferences.getString(StorageKeys.accessToken);

  /// Whether a non-empty access token exists.
  bool get hasToken =>
      accessToken != null && accessToken!.trim().isNotEmpty;

  /// Persists the access token used by [Authorization] headers.
  Future<void> setAccessToken(String token) async {
    await _preferences.setString(StorageKeys.accessToken, token);
  }

  /// Clears stored credentials (logout).
  Future<void> clearAccessToken() async {
    await _preferences.remove(StorageKeys.accessToken);
  }
}
