# ShopFlow — Current Status

**Version:** `1.0.0+1` (from `pubspec.yaml`)  
**Last updated:** 2026-05-21

## Feature matrix

| Area | Status | Notes |
|------|--------|-------|
| Auth (email + session) | ✅ | Fake Store / showcase |
| Google Sign-In | ✅ | Stub — ADR 004; conditional test path |
| JWT refresh | ✅ | Showcase — ADR 005 |
| Product catalog | ✅ | Hive cache, search, filters |
| Cart & wishlist | ✅ | Local-first; dedicated wishlist page |
| Checkout + Stripe | ✅ | Demo path + banner; Payment Sheet when env set — ADR 006 |
| Orders | ✅ | Offline journal |
| Profile & settings | ✅ | Theme, locale, avatar; env row in debug |
| Responsive shell | ✅ | Nav adapts by width; wide cart/checkout/profile |
| AR / EN l10n | ✅ | `assets/l10n/*.arb` |
| Agent tooling | ✅ | `AGENTS.md`, skills, CI docs + test workflows |
| Showcase tests | ✅ | 14 widget/golden tests; 6 integration flows |

## Metrics

| Metric | Value |
|--------|-------|
| `flutter test` | 14 passing (widget + golden + layout) |
| Line coverage | ~17.5% (690 / 3951 lines, `coverage/lcov.info`) |
| Integration tests | 6 flows (`checkout`, `auth`, `catalog`, `orders`, `settings`, `stripe`) |
| Golden tests | 7 PNGs (`test/goldens/goldens/`) |
| CI | `docs.yml` + `test.yml` (analyze + coverage on PR) |

## Known gaps

- Demo GIF not yet recorded — see `docs/RECORD_DEMO.md`
- Production Google OAuth + Stripe backend left to consumer projects (see `10_demo_vs_live_paths.md`, ADRs 004–006)
- BLoC/repository unit test pyramid still thin (deferred)
