# ShopFlow — Agent Instructions

<!-- canonical-banner:start -->
> **Canonical source of truth for AI agents.**
> This file is the single authoritative guide for every agent (Cursor, Claude Code, Codex CLI, GitHub Copilot, Gemini, Aider, Windsurf, generic). The per-tool instruction files below are **thin shims** that pull in tool-specific runtime conventions and reference this document for everything else — do **not** duplicate content from this file into them.
>
> | Tool | Shim file | What lives only in the shim |
> |------|-----------|------------------------------|
> | All / generic | [.agents/AGENTS.md](.agents/AGENTS.md) | Skill folder location, `npx skills` workflow |
> | Claude Code | [CLAUDE.md](CLAUDE.md) | Tool-use rules, response style, slash-commands (`.claude/commands/`) |
> | OpenAI Codex CLI | [.codex/AGENTS.md](.codex/AGENTS.md) | Approval-mode mapping, `apply_patch` preference |
> | GitHub Copilot | [.github/copilot-instructions.md](.github/copilot-instructions.md) | Inline-completion + Copilot-Chat conventions |
> | Cursor | [.cursor/rules/](.cursor/rules/) `*.mdc` | Auto-attached rule scopes |
>
> **If you edit project conventions, edit this file.** Shims should never grow back into full mirrors.
<!-- canonical-banner:end -->

> **Scope**: Only modify files inside this repository (`ecommerce_app/` / ShopFlow Flutter app).

## Table of Contents

- [Project Overview](#project-overview)
- [Key Entry Points](#key-entry-points)
- [Feature Architecture](#feature-architecture)
- [Design Tokens — Never Hardcode](#design-tokens--never-hardcode)
- [State Management (BLoC)](#state-management-bloc)
- [Offline & Local Storage](#offline--local-storage)
- [API Integration](#api-integration)
- [DI Registration](#di-registration)
- [Localization](#localization)
- [Security](#security)
- [Shared Widgets](#shared-widgets)
- [Naming Conventions](#naming-conventions)
- [Mandatory Documentation (after every change)](#mandatory-documentation-after-every-change)
- [Approved Commands (no user prompt required)](#approved-commands-no-user-prompt-required)
- [Available Skills](#available-skills)

## Project Overview

Flutter e-commerce **freelance showcase** (Android, iOS, Web, desktop). Current version: **`1.0.0+1`** (`pubspec.yaml`).

- **Architecture**: Clean Architecture + BLoC
- **State**: `flutter_bloc` (BLoC for features, Cubit for simple state e.g. wishlist, connectivity, theme, language)
- **Routing**: GoRouter — use `AppRoutes` constants, never hardcode paths
- **DI**: GetIt + injectable — `lib/core/di/injection.dart` (+ generated `injection.config.dart`)
- **Networking**: Dio via `DioClient` with auth/retry/logging interceptors
- **Local cache**: Hive (`hive_flutter`) for products, cart, orders, profile
- **Secrets**: `assets/env/default.env` + optional gitignored `.env` via `flutter_dotenv` — access via `AppConfig`, never hardcode
- **Auth**: Email/password + Google Sign-In showcase + JWT in `TokenStorage` (`flutter_secure_storage`)
- **Payments**: `flutter_stripe` Payment Sheet when publishable key is configured
- **Localization**: ARB-based (English + Arabic) via `AppLocalizations.of(context)`
- **Logging**: Talker + `TalkerBlocObserver` + optional debug logs page (shake / FAB)
- **Connectivity**: `ConnectivityCubit` + `OfflineBanner` — reads are Hive-backed where implemented
- **Responsive UI**: `ResponsiveAppNav`, `AppBreakpoints` — bottom nav / rail / drawer by width
- **Platform**: Windows 11 development (PowerShell-first scripts; `.sh` mirrors for CI / macOS)

## Key Entry Points

| File | Purpose |
|------|---------|
| `lib/main.dart` | App start: Hive, dotenv, DI, Stripe, Talker |
| `lib/app/shop_flow_app.dart` | `MaterialApp.router` + global `BlocProvider`s |
| `lib/core/di/injection.dart` | GetIt `configureDependencies()` |
| `lib/core/router/app_router.dart` | GoRouter + auth redirects |
| `lib/core/router/app_routes.dart` | All route path constants |
| `lib/core/config/app_config.dart` | Env-derived API URL, Stripe key, demo flags |
| `lib/core/network/dio_client.dart` | Shared Dio instance |

## Feature Architecture

Every feature lives under `lib/features/<name>/` with three layers:

```
features/<name>/
├── data/
│   ├── datasources/     # Remote (Dio) + local (Hive / SharedPreferences)
│   ├── models/          # Extend entities; add fromJson/toJson
│   └── repositories/    # Implement domain contracts
├── domain/
│   ├── entities/        # Pure Dart + Equatable — no serialization
│   ├── repositories/    # Abstract contracts → Either<Failure, T>
│   └── usecases/        # One file per operation
└── presentation/
    ├── bloc/            # *_bloc.dart, *_event.dart, *_state.dart (or cubit)
    ├── pages/
    └── widgets/
```

**Dependency rule**: Presentation → Domain ← Data. Domain has zero Flutter imports.

**Existing features**: `auth`, `products`, `cart`, `checkout`, `orders`, `profile`, `wishlist`, `home`, `onboarding`, `splash`.

## Design Tokens — Never Hardcode

| Category | Use | Never |
|----------|-----|-------|
| Colors | `AppColors.primary`, `Theme.of(context).extension<AppPalette>()!` | `Color(0xFF...)`, raw `Colors.*` in features |
| Typography | `AppTypography` / theme `textTheme` | ad-hoc `TextStyle` with hardcoded sizes |
| Theme semantics | `AppTheme`, `theme_extensions.dart` | one-off brightness checks scattered in widgets |
| Routes | `AppRoutes.home`, `AppRoutes.product(id)` | `'/home'`, `'/product/1'` |
| Spacing | `ThemeData` padding, `EdgeInsets` from layout constants in widgets | magic numbers without comment |
| Test keys | `TestKeys` in `core/constants/test_keys.dart` | raw `Key('...')` in production widgets |

Brand palette lives in `lib/core/theme/app_colors.dart`. Prefer `AppPalette` from theme extensions in UI code.

## State Management (BLoC)

```dart
// Event
abstract class FeatureEvent extends Equatable { const FeatureEvent(); }

// State
abstract class FeatureState extends Equatable { const FeatureState(); }

// BLoC handler
result.fold(
  (failure) => emit(FeatureError(message: failure.message)),
  (data) => emit(FeatureLoaded(data: data)),
);
```

- `BlocBuilder` for UI rebuilds, `BlocListener` for side effects, `BlocConsumer` for both
- `context.read<FeatureBloc>().add(event)` to dispatch
- Register blocs in `ShopFlowApp` via `BlocProvider` (factory from GetIt where injectable)

## Offline & Local Storage

- `ConnectivityCubit` is provided at app root — use for banners and disabling network-only actions
- **Hive** boxes back product catalog, cart, orders, and profile cache in data layers
- **Cart / wishlist** are local-first; sync to API when online where implemented
- **Tokens**: `TokenStorage` + `FlutterSecureStorage` only — never `SharedPreferences` for JWT
- Storage key strings: `lib/core/constants/storage_keys.dart`

## API Integration

1. Add path or helper on the feature's remote datasource (Fake Store / custom backend via `AppConfig.apiBaseUrl`)
2. Use `DioClient` / injected `Dio` — parse JSON into `data/models/*_model.dart`
3. Map snake_case JSON keys to camelCase Dart fields
4. Add method to domain repository contract: `Future<Either<Failure, T>>`
5. Implement in `*_repository_impl.dart` with exception → `Failure` mapping (`lib/core/error/`)
6. Create use case, wire into BLoC, register in injectable module / `injection.dart`
7. Add route in `app_router.dart` if a new screen is needed

## DI Registration

- Annotate with `@injectable`, `@lazySingleton`, `@singleton` as appropriate
- Run `dart run build_runner build --delete-conflicting-outputs` after new registrations
- BLoCs used per-route: typically `@injectable` factory; app-wide cubits: `@lazySingleton`

## Localization

- ARB files: `assets/l10n/intl_en.arb` and `assets/l10n/intl_ar.arb`
- Generated: `lib/core/l10n/gen/app_localizations.dart`
- Config: `l10n.yaml` — run `flutter gen-l10n` after ARB edits
- Never use raw user-facing strings in widgets

## Security

- Never hardcode API URLs, Stripe keys, or tokens in Dart source
- Optional `.env` at project root (gitignored); defaults in `assets/env/default.env`
- Auth tokens → `FlutterSecureStorage` via `TokenStorage`
- Do not log request bodies for `/auth/login` or registration passwords (`DioClient` redaction)

## Shared Widgets

Check `lib/core/widgets/` before building new UI:

- `AppLoadingView`, `AppErrorView`, `AppEmptyView`
- `OfflineBanner`, `ProductGridShimmer`
- `ResponsiveAppNav`, `ContinueShoppingButton`, `GoogleSignInButton`
- `FlyToCartOverlay` (cart animation)

Feature-specific widgets stay under `lib/features/<name>/presentation/widgets/`.

## Naming Conventions

| Item | Convention |
|------|-----------|
| Files | `snake_case.dart` |
| Classes | `PascalCase` |
| Variables/functions | `camelCase` |
| Constants | `camelCase` |
| Private members | `_prefixed` |

## Mandatory Documentation (after every change)

1. `CHANGELOG.md` — add entry under `[Unreleased]` or current version (Keep a Changelog)
2. `shopflow_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md` — dated entry at top
3. `shopflow_readme_files/CURRENT_STATUS.md` — update feature status and version

## Approved Commands (no user prompt required)

| Category | Command |
|----------|---------|
| Dart/Flutter | `flutter pub get`, `flutter gen-l10n`, `flutter analyze`, `flutter test`, `dart format <path>`, `dart run build_runner build --delete-conflicting-outputs` |
| Doc tooling | `.\scripts\sync_ai_ignores.ps1`, `.\scripts\sync_ai_ignores.ps1 -Check`, `.\scripts\check_docs_freshness.ps1`, `.\scripts\check_skills_drift.ps1` |
| Skills sync | `npx skills update`, `npx skills check` |
| Lint | `npx markdownlint-cli2 "**/*.md"` |

Anything outside this list — especially `git push`, destructive git ops, or `--no-verify` — requires explicit user permission.

## Available Skills

All skill prompts live in `.agents/skills/` (universal agent format).

### Project-tuned skills

| Skill | When to use |
|-------|------------|
| `add-feature` | Scaffold Clean Architecture feature + DI + routing + l10n |
| `add-api` | Wire a new HTTP endpoint through Dio → repository → BLoC |
| `add-language` | Add/update ARB strings + `flutter gen-l10n` |

### Official Flutter skills (`npx skills add`)

Prefer project-tuned skills when workflows overlap.

| Skill | When to use |
|-------|------------|
| `flutter-add-integration-test` | `integration_test` package flows |
| `flutter-add-widget-test` | `WidgetTester` component tests |
| `flutter-add-widget-preview` | Widget previews |
| `flutter-build-responsive-layout` | Breakpoints — pair with `ResponsiveAppNav` / `AppBreakpoints` |
| `flutter-fix-layout-issues` | Overflow / constraint errors |
| `flutter-apply-architecture-best-practices` | Generic sanity check only |
| `flutter-implement-json-serialization` | Hand-written JSON (we mostly use manual models) |
| `flutter-setup-declarative-routing` | **Skip** — GoRouter configured |
| `flutter-setup-localization` | **Skip** — use `add-language` |
| `flutter-use-http-package` | **Skip** — we use Dio |

### Official Dart skills

| Skill | When to use |
|-------|------------|
| `dart-add-unit-test` | `package:test` unit tests |
| `dart-collect-coverage` | LCOV coverage reports |
| `dart-fix-runtime-errors` | Stack trace → fix via MCP |
| `dart-resolve-package-conflicts` | `pub get` failures |
| `dart-run-static-analysis` | `dart analyze` / `dart fix --apply` |
| `dart-use-pattern-matching` | Dart 3 patterns |
| `dart-generate-test-mocks` | **Skip** — prefer manual fakes unless requested |
| `dart-migrate-to-checks-package` | **Skip** |
| `dart-build-cli-app` | **Skip** |

```bash
npx skills update
```

Pulls latest official skills; leaves `add-feature`, `add-api`, `add-language` untouched. Hashes tracked in `skills-lock.json`.
