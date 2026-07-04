# ShopFlow — Current Status

**Version:** `1.0.0+1` (from `pubspec.yaml`)  
**Last updated:** 2026-07-03

> **UI:** "Bold & Vibrant" redesign **complete (Phases 1–3)** on `feat/bold-vibrant-redesign` — new violet→pink gradient brand, lime accent, Space Grotesk / Plus Jakarta type, chunky rounded components, gradient CTAs (`AppGradientButton`), sticky action bars, shared `RatingBadge` + `BrandBadge`, gradient profile/PDP headers, settings section cards, order status pills. Every screen now carries the new language. **Follow-ups:** regenerate goldens (`flutter test --update-goldens`); BLoC/repository unit-test pyramid still thin (deferred).

## Feature matrix

| Area | Status | Notes |
|------|--------|-------|
| Auth (email + session) | ✅ | Fake Store / showcase |
| Google Sign-In | ✅ | Stub — ADR 004; conditional test path |
| JWT refresh | ✅ | Showcase — ADR 005 |
| Product catalog | ✅ | Hive cache, search, **sliver home catalog** (pinned search), category FilterChips, sort/filter, categories page, recently viewed |
| Product detail | ✅ | Hero gallery, wishlist, **mock reviews**, **related products**, **share** |
| Cart & wishlist | ✅ | Local-first; dedicated wishlist page |
| Checkout + Stripe | ✅ | Demo path + banner; **promo codes**, **saved addresses**; Payment Sheet when env set — ADR 006 |
| Orders | ✅ | Offline journal; order-success demo notification when prefs enabled |
| Profile & settings | ✅ | Theme, locale, avatar; **currency**, **notifications**, **addresses**, **change password**; env row in debug |
| Responsive shell | ✅ | Bottom nav: Home · Cart · Categories · Orders · Profile (`< 900px`) |
| AR / EN l10n | ✅ | `assets/l10n/*.arb` (~40 new showcase strings) |
| Agent tooling | ✅ | `AGENTS.md`, skills, CI docs + test workflows |
| Showcase tests | ✅ | 16 widget/golden/layout tests; 6 integration flows |

## Metrics

| Metric | Value |
|--------|-------|
| `flutter test` | 16 passing (widget + golden + layout + showcase) |
| Line coverage | ~17.5% baseline (re-run `scripts/collect_coverage.ps1` after expansion) |
| Integration tests | 6 flows (`checkout`, `auth`, `catalog`, `orders`, `settings`, `stripe`) |
| Golden tests | 7 PNGs (`test/goldens/goldens/`) |
| CI | `docs.yml` + `test.yml` (analyze + coverage on PR) |

## Known gaps

- Demo GIF not yet recorded — see `docs/RECORD_DEMO.md`
- Production Google OAuth + Stripe backend left to consumer projects (see `10_demo_vs_live_paths.md`, ADRs 004–006)
- BLoC/repository unit test pyramid still thin (deferred)
- Push notifications / live FX / password API intentionally showcase-only
