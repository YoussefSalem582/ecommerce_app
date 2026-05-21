# ShopFlow — Current Status

**Version:** `1.0.0+1` (from `pubspec.yaml`)  
**Last updated:** 2026-05-21

## Feature matrix

| Area | Status | Notes |
|------|--------|-------|
| Auth (email + session) | ✅ | Fake Store / showcase |
| Google Sign-In | ✅ | Stub — ADR 004 |
| JWT refresh | ✅ | Showcase — ADR 005 |
| Product catalog | ✅ | Hive cache, search, filters |
| Cart & wishlist | ✅ | Local-first; dedicated wishlist page |
| Checkout + Stripe | ✅ | Demo path; Payment Sheet when env set — ADR 006 |
| Orders | ✅ | Offline journal |
| Profile & settings | ✅ | Theme, locale, avatar (SharedPreferences) |
| Responsive shell | ✅ | Nav adapts by width |
| AR / EN l10n | ✅ | `assets/l10n/*.arb` |
| Agent tooling | ✅ | `AGENTS.md`, skills, CI docs workflow |

## Metrics

| Metric | Value |
|--------|-------|
| `flutter test` | 6+ widget/unit tests |
| Integration tests | 2 flows (checkout, catalog/cart/wishlist) |
| `dart analyze` | Run locally |

## Known gaps

- Demo GIF not yet recorded — see `docs/RECORD_DEMO.md`
- Production Google OAuth + Stripe backend left to consumer projects (documented in ADRs)
