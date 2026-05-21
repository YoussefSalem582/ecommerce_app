# ShopFlow — Current Status

**Version:** `1.0.0+1` (from `pubspec.yaml`)  
**Last updated:** 2026-05-21

## Feature matrix

| Area | Status | Notes |
|------|--------|-------|
| Auth (email + session) | ✅ | Fake Store / showcase |
| Google Sign-In | ✅ | Stub / showcase |
| Product catalog | ✅ | Hive cache, search, filters |
| Cart & wishlist | ✅ | Local-first |
| Checkout + Stripe | ✅ | When key configured |
| Orders | ✅ | Offline journal |
| Profile & settings | ✅ | Theme, locale, avatar |
| Responsive shell | ✅ | Nav adapts by width |
| AR / EN l10n | ✅ | `assets/l10n/*.arb` |
| Agent tooling | ✅ | `AGENTS.md`, skills, CI docs workflow |

## Metrics (fill as project grows)

| Metric | Value |
|--------|-------|
| `flutter test` | Run locally |
| Widget test coverage | TBD |
| `dart analyze` issues | Run locally |

## Known gaps

- Widget/integration test coverage still thin
- Production backend swap beyond Fake Store not documented in ADRs yet
