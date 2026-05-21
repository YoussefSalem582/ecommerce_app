import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_flow/core/constants/storage_keys.dart';

/// Showcase order-update notification preference (no FCM delivery).
@lazySingleton
class NotificationPrefsCubit extends Cubit<bool> {
  /// Loads persisted toggle (defaults to off).
  NotificationPrefsCubit(this._preferences) : super(false) {
    emit(_preferences.getBool(StorageKeys.orderUpdatesEnabled) ?? false);
  }

  final SharedPreferences _preferences;

  /// Persists notification preference.
  Future<void> setOrderUpdatesEnabled(bool enabled) async {
    emit(enabled);
    await _preferences.setBool(StorageKeys.orderUpdatesEnabled, enabled);
  }
}
