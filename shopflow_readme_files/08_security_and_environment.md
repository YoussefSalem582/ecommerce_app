# Security & Environment

- Defaults: `assets/env/default.env` (committed)
- Template: `.env.example` at repo root (committed — copy to `.env` for local overrides)
- Overrides: `.env` at repo root (gitignored, optional)
- Access secrets only via `AppConfig` after `dotenv.load` in `main.dart`
- JWT: `TokenStorage` + `flutter_secure_storage` — never `SharedPreferences`
- Keys: `lib/core/constants/storage_keys.dart`
- Stripe publishable key: `AppConfig.stripePublishableKey` — set in env for real checkout

Do not commit real API keys or Stripe secrets.
