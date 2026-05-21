---
description: "Project scope — ShopFlow Flutter app only"
alwaysApply: true
---

# Project Scope

**Only work inside this repository** (`ecommerce_app` / ShopFlow).

## Project Overview

- **App**: Flutter e-commerce freelance showcase
- **Architecture**: Clean Architecture + BLoC (presentation → domain ← data)
- **State Management**: `flutter_bloc` + cubits for simple state
- **Routing**: GoRouter with `AppRoutes` constants
- **DI**: GetIt + injectable (`lib/core/di/injection.dart`)
- **Networking**: Dio (`DioClient`)
- **Local Storage**: Hive, SharedPreferences (prefs only), `FlutterSecureStorage` (tokens)
- **Secrets**: `flutter_dotenv` + `AppConfig` — never hardcode secrets
- **Auth**: Email/password + Google Sign-In showcase
- **Localization**: ARB (`assets/l10n/intl_en.arb`, `intl_ar.arb`)
- **Offline**: Hive cache + `ConnectivityCubit` + `OfflineBanner`

## Entry Points

| File | Purpose |
|------|---------|
| `lib/main.dart` | Hive, env, DI, Stripe, Talker |
| `lib/app/shop_flow_app.dart` | `MaterialApp.router` + providers |
| `lib/core/di/injection.dart` | GetIt registration |
| `lib/core/router/app_router.dart` | GoRouter |

## Key Directories

| Directory | Purpose |
|-----------|---------|
| `lib/core/` | DI, router, theme, network, l10n, widgets |
| `lib/features/` | Feature modules |
| `assets/l10n/` | ARB source files |
| `shopflow_readme_files/` | Extended docs for humans/agents |
