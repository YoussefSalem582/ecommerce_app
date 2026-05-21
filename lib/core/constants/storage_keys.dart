/// Shared preference and secure storage key names used across the app.
abstract final class StorageKeys {
  /// Persisted access token (JWT) key.
  static const accessToken = 'access_token';

  /// Persisted theme mode name (`ThemeMode.system.name`, etc.).
  static const themeMode = 'theme_mode';

  /// Persisted locale language code (`en`, `ar`).
  static const languageCode = 'language_code';

  /// Whether onboarding carousel has been completed.
  static const onboardingComplete = 'onboarding_complete';

  /// Cached signed-in user JSON snapshot for cold-start restoration.
  static const cachedUserJson = 'cached_user_json';

  /// Opaque refresh token for JWT rotation showcase.
  static const refreshToken = 'refresh_token';

  /// Local avatar image filesystem path.
  static const avatarPath = 'avatar_path';

  /// Persisted display currency token (`usd`, `eur`, `sar`).
  static const currencyCode = 'currency_code';

  /// Showcase order-update notification toggle.
  static const orderUpdatesEnabled = 'order_updates_enabled';
}
