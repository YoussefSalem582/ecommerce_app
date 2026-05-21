# How to Add a New Feature

Use skill [`add-feature`](../.agents/skills/add-feature/SKILL.md) or follow:

1. Create `lib/features/<name>/` with `data`, `domain`, `presentation`
2. Implement entity → repository contract → use cases → models → datasources → repository impl
3. Add BLoC (event/state files separate)
4. Register with `@injectable`, run build_runner
5. Add `BlocProvider` in `shop_flow_app.dart` if needed
6. Add `AppRoutes` + `GoRoute`
7. Add ARB keys to `assets/l10n/intl_en.arb` + `intl_ar.arb`, then `flutter gen-l10n`
8. UI strings: `final l10n = AppLocalizations.of(context);` — not raw literals
9. Update `CHANGELOG.md`, `DOCUMENTATION_UPDATE_SUMMARY.md`, `CURRENT_STATUS.md`
