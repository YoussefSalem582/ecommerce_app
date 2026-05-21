/// Showcase display currency options with fixed FX rates from USD.
enum AppCurrency {
  /// United States dollar (base catalog currency).
  usd,

  /// Euro showcase conversion.
  eur,

  /// Saudi riyal showcase conversion.
  sar,
}

/// Fixed showcase exchange rates relative to Fake Store USD prices.
extension AppCurrencyRates on AppCurrency {
  /// Multiplier applied to USD catalog amounts.
  double get rateFromUsd {
    return switch (this) {
      AppCurrency.usd => 1,
      AppCurrency.eur => 0.92,
      AppCurrency.sar => 3.75,
    };
  }

  /// ISO 4217 code for [NumberFormat.currency].
  String get code {
    return switch (this) {
      AppCurrency.usd => 'USD',
      AppCurrency.eur => 'EUR',
      AppCurrency.sar => 'SAR',
    };
  }

  /// Display symbol for formatting.
  String get symbol {
    return switch (this) {
      AppCurrency.usd => r'$',
      AppCurrency.eur => '€',
      AppCurrency.sar => 'SR',
    };
  }

  /// Persisted preference token.
  String get storageToken => name;
}
