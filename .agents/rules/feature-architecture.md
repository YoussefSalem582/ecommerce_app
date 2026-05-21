---
description: "Clean Architecture feature modules for ShopFlow"
alwaysApply: false
---

# Feature Architecture

Each feature under `lib/features/<name>/`:

```
data/       → datasources (remote + local), models, repositories
domain/     → entities, repository contracts, usecases
presentation/ → bloc or cubit, pages, widgets
```

**Dependency rule:** Presentation → Domain ← Data. Domain has **no** Flutter imports.

## Domain

- Entities: `Equatable`, pure Dart, no JSON
- Repositories: abstract, `Future<Either<Failure, T>>`
- Use cases: `@injectable` class with `call(...)` — **no** shared `UseCase` base class in this repo

## Data

- Models extend entities + `fromJson` / `toJson`
- Remote: `DioClient.dio` or `Fake*RemoteDatasource` when `AppConfig.isDemoEnv`
- Local: Hive / SharedPreferences datasources where needed
- Repository impl: try/catch, map `ServerException` / `CacheException` → `Failure`

## Presentation

- BLoC: separate `*_event.dart`, `*_state.dart`, `*_bloc.dart`
- Cubit: for simple state (`WishlistCubit`, `ThemeCubit`, `LanguageCubit`, `ConnectivityCubit`)
- `result.fold()` in handlers

## DI & app wiring

- Annotate with `@injectable`, `@lazySingleton`, `@singleton`
- Run `dart run build_runner build --delete-conflicting-outputs`
- App-wide blocs: `BlocProvider.value` in `lib/app/shop_flow_app.dart` (from `getIt<...>()`)

## Existing features

`auth`, `products`, `cart`, `checkout`, `orders`, `profile`, `wishlist`, `home`, `onboarding`, `splash`
