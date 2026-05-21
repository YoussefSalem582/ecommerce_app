import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shop_flow/core/preferences/app_currency.dart';
import 'package:shop_flow/core/preferences/currency_cubit.dart';

/// Locale-aware price formatting with showcase currency conversion.
abstract final class PriceFormatter {
  /// Formats USD catalog [amount] using active [AppCurrency] from cubit.
  static String formatUsd(BuildContext context, double amount) {
    final AppCurrency currency = context.read<CurrencyCubit>().state;
    final locale = Localizations.localeOf(context).toString();
    final converted = amount * currency.rateFromUsd;
    return NumberFormat.currency(
      locale: locale,
      name: currency.code,
      symbol: currency.symbol,
    ).format(converted);
  }
}
