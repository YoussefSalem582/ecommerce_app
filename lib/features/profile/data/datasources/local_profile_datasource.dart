import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_flow/core/constants/storage_keys.dart';
import 'package:shop_flow/features/auth/data/datasources/local_auth_datasource.dart';
import 'package:shop_flow/features/auth/data/models/user_model.dart';
import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';

/// Local profile + avatar persistence backed by SharedPreferences.
@lazySingleton
class LocalProfileDatasource {
  /// Creates datasource with auth cache + preferences.
  LocalProfileDatasource(
    this._authLocal,
    this._preferences,
  );

  final LocalAuthDatasource _authLocal;
  final SharedPreferences _preferences;

  /// Loads cached user snapshot from auth layer.
  UserEntity? loadProfile() => _authLocal.loadCachedUser();

  /// Updates cached profile fields while preserving id/username.
  Future<UserEntity> updateProfile({
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    final current = _authLocal.loadCachedUser();
    final updated = UserEntity(
      id: current?.id ?? 0,
      username: current?.username ?? '',
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
    await _authLocal.cacheUser(UserModel.fromEntity(updated));
    return updated;
  }

  /// Returns persisted avatar filesystem path.
  String? loadAvatarPath() => _preferences.getString(StorageKeys.avatarPath);

  /// Persists avatar filesystem path.
  Future<void> saveAvatarPath(String path) async {
    await _preferences.setString(StorageKeys.avatarPath, path);
  }
}
