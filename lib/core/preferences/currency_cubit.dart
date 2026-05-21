import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_flow/core/constants/storage_keys.dart';
import 'package:shop_flow/core/preferences/app_currency.dart';

/// Persists shopper currency display preference.
@lazySingleton
class CurrencyCubit extends Cubit<AppCurrency> {
  /// Loads saved currency or defaults to USD.
  CurrencyCubit(this._preferences) : super(AppCurrency.usd) {
    final saved = _preferences.getString(StorageKeys.currencyCode);
    if (saved != null) {
      for (final AppCurrency currency in AppCurrency.values) {
        if (currency.storageToken == saved) {
          emit(currency);
          break;
        }
      }
    }
  }

  final SharedPreferences _preferences;

  /// Updates currency and persists selection.
  Future<void> setCurrency(AppCurrency currency) async {
    emit(currency);
    await _preferences.setString(StorageKeys.currencyCode, currency.storageToken);
  }
}
