---
name: add-feature
description: Scaffold a new Clean Architecture feature with all layers (domain, data, presentation), DI registration, routing, and translations. Use when creating a new feature module.
---

# Add New Feature

Scaffold a complete Clean Architecture feature module with all required layers.

## When to Use

- User asks to create a new feature, screen, or module
- User says "add feature", "create feature", "new feature"

## Instructions

Follow these steps in order. Reference `shopflow_readme_files/03_how_to_add_new_feature.md` for examples.

### Step 1 — Folder structure

```
lib/features/<feature_name>/
├── data/{datasources,models,repositories}/
├── domain/{entities,repositories,usecases}/
└── presentation/{bloc,pages,widgets}/
```

### Step 2–4 — Domain

- Entity: `Equatable`, no Flutter imports, no JSON
- Repository: abstract, `Either<Failure, T>`
- Use cases: one per operation

### Step 5–7 — Data

- Model extends entity + `fromJson`/`toJson`
- Remote datasource uses injected `Dio` / `DioClient`
- Local datasource uses Hive where offline reads matter
- Repository impl maps exceptions → `Failure`

### Step 8–10 — Presentation BLoC

- Separate `*_event.dart`, `*_state.dart`, `*_bloc.dart`
- `result.fold()` for `Either` handling

### Step 11 — UI

- Pages under `presentation/pages/`
- Reuse `lib/core/widgets/` where possible

### Step 12 — DI

- Add `@injectable` / `@lazySingleton` annotations
- Run `dart run build_runner build --delete-conflicting-outputs`
- Register `BlocProvider` in `lib/app/shop_flow_app.dart` if app-wide

### Step 13 — Routes & l10n

- Add constants to `lib/core/router/app_routes.dart`
- Add `GoRoute` in `lib/core/router/app_router.dart`
- Add keys to `assets/l10n/intl_en.arb` and `intl_ar.arb`
- Run `flutter gen-l10n`
- Use `AppLocalizations.of(context).keyName` in widgets

## Post-Completion Checklist

- [ ] Three layers + DI + route + ARB keys
- [ ] `flutter gen-l10n` and `flutter analyze` clean
- [ ] `CHANGELOG.md`, `DOCUMENTATION_UPDATE_SUMMARY.md`, `CURRENT_STATUS.md` updated
