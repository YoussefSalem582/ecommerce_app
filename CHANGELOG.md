# Changelog

All notable changes to ShopFlow will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> Doc-map entry point: [`shopflow_readme_files/INDEX.md`](shopflow_readme_files/INDEX.md). Live status: [`shopflow_readme_files/CURRENT_STATUS.md`](shopflow_readme_files/CURRENT_STATUS.md). Per-change deep-dives: [`shopflow_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md`](shopflow_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md).

## [Unreleased]

### Added

- **Wishlist screen** — `/wishlist` route, `WishlistPageBloc`, home app-bar entry + profile link, EN/AR strings.
- **`.env.example`** — Documented env template; `.env` added to `.gitignore`.
- **ADRs 004–006** — Google Sign-In stub, JWT refresh stub, Stripe PaymentIntent workflow.
- **Widget & integration tests** — Wishlist page/bloc tests, `integration_test/catalog_cart_flow_test.dart`.
- **Demo GIF guide** — `docs/RECORD_DEMO.md`.

### Changed

- **README** — Accurate `APP_ENV=demo`, showcase limitations table, Stripe CLI steps, 15-screen inventory.
- **OfflineBanner** — Design tokens (`AppPalette.onPrimary`) instead of raw `Colors.white`.
- **Animation guards** — `kIsWeb` / `disableAnimations` on cart badge, fly-to-cart, shimmer.
- **AGENTS.md** — Profile cache documented as SharedPreferences (not Hive).

### Removed

- Stale l10n keys `addToCartComingSoon`, `cartCheckoutComingSoon`.

### Added (agent tooling batch)
- **AI agent tooling scaffold** — Canonical [`AGENTS.md`](AGENTS.md), per-tool shims, project skills, `shopflow_readme_files/`, CI docs workflow.
- **Official agent skills** — `npx skills add flutter/skills` + `dart-lang/skills` (19 universal skills, `skills-lock.json` updated).
- **Checkout integration test** — uses `TestKeys.orderSuccessTitle`; demo flow in `integration_test/checkout_flow_test.dart`.
- **Checkout layout tests** — `test/features/checkout/checkout_layout_test.dart` for mobile vs tablet form rows.
- **Coverage script** — `scripts/collect_coverage.ps1` → `coverage/lcov.info`.

### Changed

- **Pattern matching** — `splash_page`, `order_detail_page`, `product_detail_page`, `login_page`, `checkout_page` (sealed states).
- **Agent docs aligned to ShopFlow** — Rules, Cursor `.mdc` files, Claude slash commands, and project skills now reference `DioClient`, `AppConfig`, `AppRoutes`, `AppLocalizations`, Hive offline cache, and `lib/core/widgets/` (removed Tech 92 leftovers: `ApiClient`, `OfflineQueue`, `CachePolicy`, `EnvConfig`, `RouteNames`, etc.).

## [1.0.0] - 2026-05-21

Pubspec: `1.0.0+1`. Initial freelance showcase release.

### Added

- ShopFlow e-commerce app: auth, catalog, cart, checkout (Stripe), orders, profile, wishlist, onboarding, responsive shell, AR/EN l10n, Hive offline cache, Talker logging.
