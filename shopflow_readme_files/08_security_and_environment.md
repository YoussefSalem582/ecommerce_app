# Security & Environment

- Defaults: `assets/env/default.env` (committed)
- Overrides: `.env` at repo root (gitignored, optional)
- Access secrets only via `AppConfig` after `dotenv.load` in `main.dart`
- JWT: `TokenStorage` + `flutter_secure_storage` — never `SharedPreferences`
- Keys: `lib/core/constants/storage_keys.dart`
- Stripe publishable key: `AppConfig.stripePublishableKey` — set in env for real checkout

Do not commit real API keys or Stripe secrets.
