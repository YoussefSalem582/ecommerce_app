# Onboarding — ShopFlow

## Day 1

1. Read [`../README.md`](../README.md) — install Flutter 3.11+, run `flutter pub get`
2. Copy env: optional `.env` at repo root; defaults in `assets/env/default.env`
3. Read [`../AGENTS.md`](../AGENTS.md) if you use AI coding tools
4. Run `flutter run` (pick device)
5. Skim [`02_architecture.md`](02_architecture.md) and [`01_folder_structure.md`](01_folder_structure.md)

## Where to look for X

| Question | Location |
|----------|----------|
| Routes | `lib/core/router/app_routes.dart`, `app_router.dart` |
| DI | `lib/core/di/injection.dart` |
| Theme | `lib/core/theme/` |
| API / Dio | `lib/core/network/dio_client.dart`, feature `*_remote_datasource.dart` |
| Strings | `assets/l10n/intl_en.arb`, `intl_ar.arb` |
| Tests | `test/` |

## Approved local commands

See [`../AGENTS.md`](../AGENTS.md) § Approved Commands.
