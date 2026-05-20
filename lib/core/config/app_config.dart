import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

/// Environment-backed configuration (`.env` loaded before DI resolves).
@singleton
class AppConfig {
  /// Base URL for REST APIs (`BASE_URL`).
  String get apiBaseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://fakestoreapi.com';

  /// Stripe publishable key (`STRIPE_PUBLISHABLE_KEY`), if configured.
  String? get stripePublishableKey {
    final key = dotenv.env['STRIPE_PUBLISHABLE_KEY'];
    if (key == null || key.isEmpty) {
      return null;
    }
    return key;
  }

  /// PaymentIntent client secret for Payment Sheet (`STRIPE_PAYMENT_INTENT_CLIENT_SECRET`).
  ///
  /// **Requires your backend** (or Stripe CLI) — demo builds leave this empty to use local checkout only.
  String? get stripePaymentIntentClientSecret {
    final secret = dotenv.env['STRIPE_PAYMENT_INTENT_CLIENT_SECRET'];
    if (secret == null || secret.trim().isEmpty) {
      return null;
    }
    return secret.trim();
  }

  /// Application environment label (`APP_ENV`). Defaults to `demo` for offline showcase.
  String get appEnv {
    final raw = dotenv.env['APP_ENV']?.trim();
    if (raw == null || raw.isEmpty) {
      return 'demo';
    }
    return raw;
  }

  /// Whether the app runs with in-memory auth/catalog stubs (no Fake Store HTTP).
  ///
  /// Demo mode is on for `demo`, `development`, and unset env values.
  /// Set `APP_ENV=live` to force real Fake Store HTTP.
  bool get isDemoEnv {
    switch (appEnv.toLowerCase()) {
      case 'live':
      case 'production':
        return false;
      default:
        return true;
    }
  }
}
