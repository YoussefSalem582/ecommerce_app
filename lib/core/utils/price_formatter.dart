import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Locale-aware USD formatting for Fake Store catalog prices.
abstract final class PriceFormatter {
  /// Formats [amount] as USD using the active widget [locale].
  static String formatUsd(BuildContext context, double amount) {
    final locale = Localizations.localeOf(context).toString();
    return NumberFormat.currency(
      locale: locale,
      name: 'USD',
      symbol: r'$',
    ).format(amount);
  }
}
