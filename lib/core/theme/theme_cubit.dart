import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_flow/core/constants/storage_keys.dart';

/// Controls [ThemeMode] and persists it to [SharedPreferences].
@lazySingleton
class ThemeCubit extends Cubit<ThemeMode> {
  /// Loads persisted theme mode if present.
  ThemeCubit(this._preferences) : super(ThemeMode.system) {
    final saved = _preferences.getString(StorageKeys.themeMode);
    if (saved != null) {
      for (final mode in ThemeMode.values) {
        if (mode.name == saved) {
          emit(mode);
          break;
        }
      }
    }
  }

  final SharedPreferences _preferences;

  /// Updates theme mode and persists it.
  Future<void> setTheme(ThemeMode mode) async {
    emit(mode);
    await _preferences.setString(StorageKeys.themeMode, mode.name);
  }
}
