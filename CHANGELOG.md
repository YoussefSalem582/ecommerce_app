# Changelog

All notable changes to ShopFlow will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> Doc-map entry point: [`shopflow_readme_files/INDEX.md`](shopflow_readme_files/INDEX.md). Live status: [`shopflow_readme_files/CURRENT_STATUS.md`](shopflow_readme_files/CURRENT_STATUS.md). Per-change deep-dives: [`shopflow_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md`](shopflow_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md).

## [Unreleased]

### Added

- **"Bold & Vibrant" redesign — Phase 1 (foundation + home)** — New brand identity built on an electric violet→pink gradient with a lime pop accent, replacing the emerald theme.
  - Token layer: reworked `AppColors` (light/dark brand + elevated-surface + semantic success/warning/error), `AppPalette` gains `brandGradient`, `onAccent`, `surfaceElevated`, `success`, `warning`; new `AppSpacing` and `AppRadius` scales.
  - Typography: Space Grotesk headings over Plus Jakarta Sans body with heavier display weights.
  - Components (`AppTheme`): 20px cards on an elevated surface token (drops hardcoded `Colors.white`), 16px pill-ish buttons (52px min height), pill chips, pill nav indicator, rounded sheets/dialogs/snackbars.
  - Shared widgets: new `AppGradientButton` CTA; restyled empty/error states and product shimmer.
  - Home: gradient promo carousel (`HomePromoBanner`, 3 slides + animated dots) and a redesigned product card (lime rating pill, springy press). New EN+AR banner strings.

- **"Bold & Vibrant" redesign — Phase 2 (purchase flow)** — Carried the new language into Product Detail, Cart, and Checkout.
  - Shared `RatingBadge` widget extracted from the catalog card and reused on the PDP; standalone review stars now use the amber `warning` token.
  - **Product Detail:** rounded gradient-tinted hero panel, bolder title/price, sticky bottom add-to-cart bar with a gradient CTA.
  - **Cart:** chunky line-item cards with a rounded pill quantity stepper, rounded swipe-to-delete, and a gradient checkout bar.
  - **Checkout:** gradient-tinted order-summary card with aligned subtotal/discount/total rows, a rounded amber demo banner, and a sticky gradient pay bar (inline spinner while submitting).
  - All `TestKeys`, responsive rules, and the submitting overlay preserved.

> **Note:** the theme change intentionally invalidates the golden snapshots — run `flutter test --update-goldens` to refresh `test/goldens/goldens/` before merging.

- **Showcase feature expansion** — Catalog sort/filter + categories browse page; recently viewed strip; PDP reviews (mock), related products, share (`share_plus`); checkout promo codes (`SAVE10`, `WELCOME5`) and saved addresses; settings currency (USD/EUR/SAR) and notification toggle; change-password showcase form.
- **Showcase enhancement pass** — Integration flows (`auth`, `catalog`, `orders`, `settings`, `stripe`), shared `flow_helpers.dart`, extended `TestKeys`, `TestBootstrapOptions`.
- **Golden tests** — Login, home grid, checkout form at mobile/tablet (`test/goldens/`).
- **Responsive polish** — Home max-width, cart side-by-side summary, auth card centering, orders/profile/settings wide layouts.
- **A11y & demo UX** — Nav tab semantics, product card labels, cart stepper touch targets, checkout demo banner, onboarding Stripe copy update.
- **Demo vs live doc** — [`shopflow_readme_files/10_demo_vs_live_paths.md`](shopflow_readme_files/10_demo_vs_live_paths.md).
- **CI test workflow** — [`.github/workflows/test.yml`](.github/workflows/test.yml) (analyze + `flutter test --coverage`).
- **Settings environment row** — Debug build shows `APP_ENV` and Stripe configuration status.

### Changed

- **Shell navigation** — Added Categories tab after Cart in main bottom nav / rail / drawer; removed home catalog bottom bar.
- **Home catalog bottom bar** — Categories browse row; list view and wishlist moved to app bar actions with icon + label.
- **Home screen refactor** — Split monolithic `home_page.dart` into `presentation/widgets/` (`HomeAppBar`, `HomeBody`, `CatalogSearchBar`, category chips, product viewport, etc.); polished search bar, FilterChip categories, welcome subtitle, and dedicated `catalogEmptyBody` copy.
- **Home sliver catalog UX** — `CustomScrollView` with pinned search header (`CatalogPinnedHeader`), `HomeScrollBody`, `CatalogProductSlivers`, extracted app bar widgets; app bar uses `IconButton` actions; recently viewed “Browse categories” link; `catalogBrowseCategories` l10n (EN+AR).
- **Checkout integration test** — Uses `flow_helpers` and cart nav tab path; targeted pumps instead of long `pumpAndSettle`.
- **Coverage baseline** — ~17.5% line coverage (690/3951 lines, widget tests).
- **`PriceFormatter`** — Reads `CurrencyCubit` for showcase FX conversion on all price labels.

### Fixed

- **Shell nav branch assertion** — Guard `goBranch` when tab index exceeds stale branch count (post–hot-reload); fallback `context.go` via `AppShellBranches`; home “Browse categories” uses `go` not `push`.
- **Duplicate Hero tags on home/PDP** — Recently viewed and related-product `ProductCard`s set `enableHero: false` so the same SKU is not tagged twice with `product-hero-{id}` alongside the catalog grid.

### Added (prior unreleased batch)
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
