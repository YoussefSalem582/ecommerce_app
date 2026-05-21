# How to Add a New Feature

Use skill [`add-feature`](../.agents/skills/add-feature/SKILL.md) or follow:

1. Create `lib/features/<name>/` with `data`, `domain`, `presentation`
2. Implement entity → repository contract → use cases → models → datasources → repository impl
3. Add BLoC (event/state files separate)
4. Register with `@injectable`, run build_runner
5. Add `BlocProvider` in `shop_flow_app.dart` if needed
6. Add `AppRoutes` + `GoRoute`
7. Add ARB keys, `flutter gen-l10n`
8. Update `CHANGELOG.md` and status docs
