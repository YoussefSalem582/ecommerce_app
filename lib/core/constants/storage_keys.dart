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
}
