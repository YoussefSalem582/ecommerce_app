# Documentation Update Summary

Reverse-chronological log of doc/agent-tooling changes (not app release notes — see [`../CHANGELOG.md`](../CHANGELOG.md)).

---

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
