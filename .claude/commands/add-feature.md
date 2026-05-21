# Add New Feature

Scaffold a Clean Architecture feature for ShopFlow.

Reference: `shopflow_readme_files/03_how_to_add_new_feature.md` and skill `.agents/skills/add-feature/SKILL.md`.

## Steps

1. Create `lib/features/<name>/` with `data/`, `domain/`, `presentation/`
2. Domain: entity, abstract repository (`Either<Failure, T>`), `@injectable` use case(s) with `call()`
3. Data: model + remote datasource (`DioClient.dio` or `Fake*` for demo) + local Hive datasource if reads should survive offline
4. Repository impl: map `ServerException` / `CacheException` → `Failure`
5. BLoC: `*_event.dart`, `*_state.dart`, `*_bloc.dart` with `result.fold()`
6. Pages/widgets; reuse `lib/core/widgets/`
7. `@injectable` annotations → `dart run build_runner build --delete-conflicting-outputs`
8. `BlocProvider` in `lib/app/shop_flow_app.dart` if app-scoped
9. `AppRoutes` + route in `lib/core/router/app_router.dart`
10. `assets/l10n/intl_en.arb` + `intl_ar.arb` → `flutter gen-l10n`
11. Use `AppLocalizations.of(context)` in UI

## Checklist

- [ ] No Flutter imports in `domain/`
- [ ] No `AppLogger`, `OfflineQueue`, or `CachePolicy` (not in this app)
- [ ] `CHANGELOG.md` + doc summary + `CURRENT_STATUS.md` updated
