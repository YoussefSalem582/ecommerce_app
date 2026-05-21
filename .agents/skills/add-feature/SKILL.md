---
name: add-feature
description: Scaffold a Clean Architecture feature for ShopFlow with DI, GoRouter, and ARB l10n.
---

# Add New Feature — ShopFlow

Reference: `shopflow_readme_files/03_how_to_add_new_feature.md`

## Structure

```
lib/features/<name>/
├── data/{datasources,models,repositories}/
├── domain/{entities,repositories,usecases}/
└── presentation/{bloc,pages,widgets}/
```

## Domain

- `*_entity.dart` — `Equatable`, no Flutter, no JSON
- `*_repository.dart` — abstract, `Either<Failure, T>`
- `*_usecase.dart` — `@injectable`, method `call(...)`

## Data

- `*_model.dart` — extends entity, `fromJson`/`toJson`
- `*_remote_datasource.dart` — `DioClient.dio` + `Fake*` impl for `AppConfig.isDemoEnv`
- `local_*_datasource.dart` — Hive when offline catalog-style reads matter
- `*_repository_impl.dart` — exceptions → `ServerFailure` / `CacheFailure` / etc.

## Presentation

- BLoC trio or Cubit for trivial state
- Reuse `lib/core/widgets/`
- `AppLocalizations.of(context)` for strings

## Wire-up

1. `@injectable` + `dart run build_runner build --delete-conflicting-outputs`
2. `BlocProvider` in `lib/app/shop_flow_app.dart` if global
3. `AppRoutes` + `lib/core/router/app_router.dart`
4. `assets/l10n/intl_en.arb` + `intl_ar.arb` → `flutter gen-l10n`
5. Update `CHANGELOG.md`, `DOCUMENTATION_UPDATE_SUMMARY.md`, `CURRENT_STATUS.md`

## Not in this project

- `AppLogger`, `OfflineQueue`, `CachePolicy`, `RouteNames`, `injection_container.dart`, `lib/shared/widgets/`
