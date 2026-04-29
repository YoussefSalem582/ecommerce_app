import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_flow/core/constants/storage_keys.dart';

/// Emits the active [Locale] and persists language code (`en` | `ar`).
@lazySingleton
class LanguageCubit extends Cubit<Locale> {
  /// Loads persisted locale or defaults to English.
  LanguageCubit(this._preferences) : super(const Locale('en')) {
    final code = _preferences.getString(StorageKeys.languageCode);
    if (code == null) {
      return;
    }
    if (code != 'ar' && code != 'en') {
      return;
    }
    emit(Locale(code));
  }

  final SharedPreferences _preferences;

  /// Persists and emits [locale].
  Future<void> setLocale(Locale locale) async {
    emit(locale);
    await _preferences.setString(
      StorageKeys.languageCode,
      locale.languageCode,
    );
  }
}
