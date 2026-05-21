# Review Code

Audit against ShopFlow conventions in `AGENTS.md` and `.agents/rules/`.

## Check

### Architecture

- Domain imports Flutter or data layer
- Widget calls repository directly (must use BLoC → use case)
- Entity with `fromJson` in domain

### Design tokens

- Raw `Color(0xFF...)` instead of `AppColors` / `AppPalette`
- Inline `TextStyle` instead of `Theme.of(context).textTheme`
- Hardcoded routes instead of `AppRoutes`

### Localization

- Raw user-facing strings
- Key in only one ARB file

### Security

- Hardcoded `BASE_URL`, Stripe keys, tokens
- JWT in `SharedPreferences`
- Storage keys not in `StorageKeys`

### BLoC

- States missing `Equatable` / `props`
- References to non-existent `AppLogger`, `OfflineQueue`, `CachePolicy`

### DI

- Missing `@injectable` / build_runner after new types
- BLoC not provided in `shop_flow_app.dart` when app-wide

### API

- References to `ApiClient`, `api_endpoints.dart`, envelope `ApiResponse` (Tech 92 leftovers)
- Dio calls bypassing `DioClient`

### Offline

- Read path with no Hive fallback when feature is catalog-like
- Invented mutation queue instead of local-first cart/order patterns

## Output

```
[SEVERITY] path:line — issue
  Rule: ...
  Fix: ...
```

Severity: `ERROR` | `WARNING` | `INFO`
