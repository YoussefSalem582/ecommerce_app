# Add New Feature

Scaffold a complete Clean Architecture feature module with all required layers.

## When to Use

- User asks to create a new feature, screen, or module
- User says "add feature", "create feature", "new feature"
- A new section of the app needs to be built from scratch

## Instructions

Follow these 13 steps in order. Reference `ecommerce_app/shopflow_readme_files/03_how_to_add_new_feature.md` for detailed examples.

### Step 1 â€” Create Folder Structure

```
lib/features/<feature_name>/
â”œâ”€â”€ data/
â”‚   â”œâ”€â”€ datasources/
â”‚   â”œâ”€â”€ models/
â”‚   â””â”€â”€ repositories/
â”œâ”€â”€ domain/
â”‚   â”œâ”€â”€ entities/
â”‚   â”œâ”€â”€ repositories/
â”‚   â””â”€â”€ usecases/
â””â”€â”€ presentation/
    â”œâ”€â”€ bloc/
    â”œâ”€â”€ pages/
    â””â”€â”€ widgets/
```

### Step 2 â€” Domain Entity

- File: `domain/entities/<name>_entity.dart`
- Extend `Equatable`
- No Flutter imports â€” pure Dart only
- No `fromJson`/`toJson`

### Step 3 â€” Domain Repository Contract

- File: `domain/repositories/<name>_repository.dart`
- Abstract class only
- Return `Either<Failure, T>` for every method

### Step 4 â€” Domain Use Cases

- One file per operation: `domain/usecases/<action>_usecase.dart`
- Extend `UseCase<ReturnType, Params>`
- Params class extends `Equatable`
- Use `NoParams` when no input needed

### Step 5 â€” Data Model

- File: `data/models/<name>_model.dart`
- Extends the entity
- Add `factory fromJson(Map<String, dynamic> json)` â€” map backend snake_case
- Add `Map<String, dynamic> toJson()`

### Step 6 â€” Data Source

- File: `data/datasources/<name>_remote_datasource.dart`
- Abstract class + implementation
- Use `ApiClient` for HTTP calls
- Parse with `ApiResponse.fromJson()`
- Add new endpoints to `lib/core/api/api_endpoints.dart`

### Step 7 â€” Repository Implementation

- File: `data/repositories/<name>_repository_impl.dart`
- Implements domain contract
- Wrap calls in try/catch with exception-to-failure mapping

### Step 8 â€” BLoC Events

- File: `presentation/bloc/<name>_event.dart`
- Abstract event extends `Equatable`

### Step 9 â€” BLoC States

- File: `presentation/bloc/<name>_state.dart`
- States: Initial, Loading, Loaded (with data), Error (with message)

### Step 10 â€” BLoC

- File: `presentation/bloc/<name>_bloc.dart`
- Inject use cases via constructor
- Register event handlers in `super` constructor
- Use `result.fold()` for Either handling
- Log transitions with `AppLogger.logBlocTransition()`
- **For read operations**: wrap with `CachePolicy.evaluate(cachedAt: ...)` â€” return cached data if fresh/stale, only call API when stale (background) or expired
- **For write operations**: inject `OfflineQueue`; check `ConnectivityCubit` state first; if offline, enqueue via `OfflineQueue` and emit optimistic state

### Step 11 â€” Pages & Widgets

- Pages: `presentation/pages/<name>_page.dart`
- Widgets: `presentation/widgets/`
- Use shared widgets from `lib/shared/widgets/`

### Step 12 â€” Register in DI

In `lib/core/di/injection.dart`:

- Data sources, repos, use cases â†’ `registerLazySingleton`
- BLoC â†’ `registerFactory`
- Add `BlocProvider` in `app.dart`

### Step 13 â€” Add Route & Translations

- Add route name to `lib/config/routes/route_names.dart`
- Add GoRoute to `lib/config/routes/app_router.dart`
- Add l10n keys to both `lib/l10n/arb/intl_en.arb` and `intl_ar.arb`
- Run `flutter gen-l10n`

## Post-Completion Checklist

- [ ] All 3 layers created (domain, data, presentation)
- [ ] DI registered in `core/di/injection.dart`
- [ ] BlocProvider added to `app.dart`
- [ ] Route added to `app_router.dart` with `AppRoutes` constant
- [ ] Endpoints added to `api_endpoints.dart`
- [ ] Translations added to both ARB files
- [ ] `flutter gen-l10n` executed
- [ ] Offline-first: reads use `CachePolicy`, writes check `ConnectivityCubit` + `OfflineQueue`
- [ ] CHANGELOG.md updated
- [ ] DOCUMENTATION_UPDATE_SUMMARY.md updated
- [ ] CURRENT_STATUS.md updated

