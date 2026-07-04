# Documentation Update Summary

Reverse-chronological log of doc/agent-tooling changes (not app release notes — see [`../CHANGELOG.md`](../CHANGELOG.md)).

---

## 2026-07-03 — "Bold & Vibrant" redesign (Phase 3)

- Auth (login/register/change-password), onboarding, splash, profile/settings, edit-profile, addresses, orders, order-detail/success redesigned
- New shared `BrandBadge` (`core/widgets/brand_badge.dart`) gradient medallion; primary CTAs across these screens → `AppGradientButton`
- Profile gradient header card; settings section cards; order status pills; order-detail green completed timeline
- login/register breakpoint literal → `AppBreakpoints.mobile`; all TestKeys + reduced-motion preserved
- **Redesign sweep complete (Phases 1–3).** Remaining: regenerate goldens (`flutter test --update-goldens`); unit-test pyramid still thin (deferred).

## 2026-07-03 — "Bold & Vibrant" redesign (Phase 2)

- Purchase flow redesigned: Product Detail, Cart, Checkout
- Shared `RatingBadge` (`core/widgets/rating_badge.dart`) extracted from the catalog card; review stars → amber `warning`
- PDP: gradient hero panel + sticky add-to-cart bar; Cart: chunky line cards + pill stepper + gradient checkout bar; Checkout: gradient summary card + sticky pay bar + amber demo banner
- All TestKeys / responsive `rowFields` / `wide` rules and the submitting overlay preserved
- **Follow-up:** regenerate goldens (`flutter test --update-goldens`). Phase 3 (auth/onboarding/splash/profile/orders) still pending.

## 2026-07-03 — "Bold & Vibrant" redesign (Phase 1)

- New brand: violet→pink gradient + lime accent; `AppColors`/`AppPalette` reworked with `brandGradient`, `onAccent`, `surfaceElevated`, `success`, `warning`
- New token files `app_spacing.dart` + `app_radius.dart`; typography swapped to Space Grotesk / Plus Jakarta Sans
- Chunky component themes in `app_theme.dart`; new `AppGradientButton`; restyled empty/error/shimmer
- Home gains `HomePromoBanner` gradient carousel + redesigned product card; EN+AR banner strings added
- **Follow-up:** regenerate goldens (`flutter test --update-goldens`). Phases 2–3 (PDP/cart/checkout, then auth/profile/orders) still pending.

## 2026-05-21 — Home sliver catalog + widget split

- Replaced `HomeBody` / `CatalogProductViewport` with `HomeScrollBody`, `CatalogPinnedHeader`, `CatalogProductSlivers`, `CatalogFiltersSection`
- Extracted `HomeAppBarTitle`, `HomeAppBarAction`, `HomeDebugFab`; app bar actions are icon-only with badges
- Pinned search row; pull-to-refresh on full scroll; shell bottom sliver padding
- Added `catalogBrowseCategories` (EN+AR); `HomeSpacing.pinnedSearchHeight`, `shellBottomClearance`

## 2026-05-21 — Categories shell tab

- Categories added to main shell nav after Cart (Home · Cart · Categories · Orders · Profile)
- Removed `HomeCatalogBottomBar`; `categoriesNavTab` test key on shell tab

## 2026-05-21 — Home catalog bottom bar

- Removed catalog actions from `HomeAppBar` (title + welcome only)
- Added `CatalogSortSheet`; sort (`Icons.sort_rounded`) and filter (`Icons.tune_rounded`) buttons on search bar open bottom sheets
- `HomeCatalogBottomBar` now: categories, view toggle, wishlist only
- Extended main shell bottom nav to viewports `< 900px` (was `< 600px`)

## 2026-05-21 — Home screen widget refactor

- Extracted `lib/features/home/presentation/widgets/` (8 files): `HomeAppBar`, `HomeBody`, `CatalogSearchBar`, `CatalogCategoryChips`, `CatalogClearFiltersChip`, `CatalogProductViewport`, `HomeRecentlyViewedSection`, `HomeSpacing`
- Slimmed `home_page.dart` to orchestration (~95 lines); preserved all catalog `TestKeys`
- UX: unified search field with clear/submit suffix, `FilterChip` categories, muted welcome subtitle, `catalogEmptyBody` l10n (EN+AR)
- Updated `01_folder_structure.md` home widgets note

## 2026-05-21 — Showcase feature expansion (11 features)

- **Catalog:** client-side sort/filter, categories browse page, recently viewed Hive strip
- **PDP:** mock reviews, related products, share via `share_plus`
- **Checkout:** promo codes (`SAVE10`, `WELCOME5`), saved addresses (Hive) + picker
- **Settings:** currency cubit (USD/EUR/SAR), notification prefs toggle
- **Profile:** addresses CRUD, change-password showcase form
- New routes: `/categories`, `/addresses`, `/add-address`, `/change-password`
- Extended `TestKeys`, ARB (~40 keys EN+AR), `test/features/showcase/showcase_features_test.dart`
- Updated `CURRENT_STATUS.md` feature matrix

## 2026-05-21 — Showcase enhancement pass

- Added 5 integration flows + `flow_helpers.dart`, extended `TestKeys`, golden tests (login/home/checkout)
- Responsive layouts: home, cart, auth, orders, profile, settings
- A11y: nav semantics, product cards, cart steppers; checkout demo banner; l10n keys (EN+AR)
- Added `10_demo_vs_live_paths.md`, settings env indicator, `stripe_checkout_test.dart` (`@Tags(['stripe'])`)
- Added `.github/workflows/test.yml`; coverage baseline ~17.5%

## 2026-05-21 — Spec audit gap closure

- Added wishlist screen, route, l10n, tests
- Added `.env.example`, `.env` in `.gitignore`, security doc alignment
- Added ADRs 004–006 (Google stub, JWT refresh, Stripe workflow)
- Updated README (showcase limitations, Stripe CLI, 15 screens, `APP_ENV=demo`)
- Fixed OfflineBanner design tokens; animation accessibility guards
- Added `docs/RECORD_DEMO.md`

## 2026-05-21 — AI agent scaffolding (initial)

- Added canonical [`AGENTS.md`](../AGENTS.md), [`CLAUDE.md`](../CLAUDE.md), `.agents/`, `.codex/`, `.github/copilot-instructions.md`, `.cursor/rules/`, `.claude/commands/`
- Added `shopflow_readme_files/` doc hub (this folder)
- Added project skills: `add-feature`, `add-api`, `add-language`
- Added `scripts/sync_ai_ignores.*`, `check_docs_freshness.*`, `check_skills_drift.*`, `skills-lock.json`, `.github/workflows/docs.yml`
- Synced all `.*ignore` files from `scripts/ai_ignore_template.txt`

## 2026-05-21 — ShopFlow-specific agent doc pass

- Rewrote all `.agents/rules/` and regenerated `.cursor/rules/*.mdc` for ShopFlow (DioClient, AppConfig, Hive, AppRoutes, AppLocalizations, no Tech 92 tokens)
- Rewrote `.claude/commands/*` (8 commands) to match real architecture
- Updated project skills `add-feature`, `add-api`, `add-language`
- Updated `shopflow_readme_files/02_architecture.md`, `04_how_to_add_new_api.md`, `COMMON_PITFALLS.md`
- Removed unrelated `scripts/ios_attendance_widget_setup.rb` from Tech 92 copy
