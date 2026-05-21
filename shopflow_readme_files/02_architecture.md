# Architecture

ShopFlow uses **Clean Architecture** with **BLoC** in presentation.

```
Widget → BLoC → UseCase → Repository → DataSource (Dio / Hive)
```

- **Domain** has no Flutter imports; returns `Either<Failure, T>` via `dartz`
- **Data** implements repositories; remote + local datasources
- **Presentation** dispatches events; rebuilds from states

## Offline pattern

- Product/order reads: Hive-backed caches in repositories
- `ConnectivityCubit` drives `OfflineBanner`
- Cart/wishlist: local-first

See [`decisions/001-clean-architecture-bloc.md`](decisions/001-clean-architecture-bloc.md).
