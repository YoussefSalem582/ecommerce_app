# Architecture

```
Presentation (BLoC/Cubit) → Domain (use cases) → Data (repositories → Dio / Hive)
```

## Layers

| Layer | Location | Rules |
|-------|----------|--------|
| Presentation | `features/*/presentation/` | Flutter UI, BLoC, no direct Dio |
| Domain | `features/*/domain/` | Entities, contracts, use cases; no Flutter |
| Data | `features/*/data/` | Dio, Hive, models, repository impls |

## State

- **BLoC**: auth, products, cart, checkout, orders, profile
- **Cubit**: wishlist, theme, language, connectivity

App-wide providers: `lib/app/shop_flow_app.dart`.

## Networking

- `DioClient` singleton with auth, logging, refresh, retry interceptors
- Fake Store JSON or in-memory fakes when `AppConfig.isDemoEnv`

## Offline

- **Products**: Hive catalog cache + repository fallback (`ProductsRepositoryImpl`)
- **Cart / orders / wishlist**: local-first storage
- **UI**: `OfflineBanner` driven by `ConnectivityCubit`

There is no global `OfflineQueue` or `CachePolicy` tier system.

## DI

GetIt + injectable (`configureDependencies()` in `main.dart`).

See ADRs in [`decisions/`](decisions/).
