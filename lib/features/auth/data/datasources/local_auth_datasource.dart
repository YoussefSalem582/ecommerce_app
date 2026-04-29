import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_flow/core/constants/storage_keys.dart';
import 'package:shop_flow/features/auth/data/models/user_model.dart';
import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';

/// Persists non-sensitive profile snapshots alongside JWT handling.
@lazySingleton
class LocalAuthDatasource {
  /// Local cache backed by [SharedPreferences].
  LocalAuthDatasource(this._preferences);

  final SharedPreferences _preferences;

  /// Writes encoded profile JSON used on cold start.
  Future<void> cacheUser(UserEntity user) async {
    final map = <String, dynamic>{
      'id': user.id,
      'username': user.username,
      'email': user.email,
      'firstname': user.firstName,
      'lastname': user.lastName,
    };
    await _preferences.setString(
      StorageKeys.cachedUserJson,
      jsonEncode(map),
    );
  }

  /// Clears cached profile snapshot.
  Future<void> clearCachedUser() async {
    await _preferences.remove(StorageKeys.cachedUserJson);
  }

  /// Reads persisted profile when token hydration succeeds.
  UserEntity? loadCachedUser() {
    final raw = _preferences.getString(StorageKeys.cachedUserJson);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      return UserModel.fromStorage(raw);
    } on Object {
      return null;
    }
  }
}
