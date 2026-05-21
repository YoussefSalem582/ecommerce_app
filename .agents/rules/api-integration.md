---
description: "API integration patterns â€” endpoints, data sources, response parsing, error handling"
alwaysApply: false
---

# API Integration

## Adding a New Endpoint

1. Define path in `lib/core/api/api_endpoints.dart`
   - Static: `static const String name = '/path';`
   - Dynamic: `static String name(int id) => '/path/$id';`
   - Group related endpoints under comment banners
   - Paths do NOT include base URL or `/api/v1` prefix (handled by DioClient)

2. Add HTTP call to remote data source using `DioClient`
3. Parse response with `ApiResponse.fromJson()`
4. Create/update model with `fromJson`/`toJson`
5. Add method to domain repository contract (returns `Either<Failure, T>`)
6. Implement in repository impl with exception-to-failure mapping
7. Create use case
8. Wire into BLoC
9. Register in `injection_container.dart`

## DioClient Methods

| Method | Signature |
|--------|-----------|
| GET | `DioClient.get(path, {queryParameters})` |
| POST | `DioClient.post(path, {data})` |
| PUT | `DioClient.put(path, {data})` |
| PATCH | `DioClient.patch(path, {data})` |
| DELETE | `DioClient.delete(path)` |
| Upload | `DioClient.uploadFile(path, {file, fieldName, data})` |

All return `Response<dynamic>`. Parse with `ApiResponse.fromJson()`.

## Backend Response Format

Success: `{ "success": true, "message": "...", "data": ..., "pagination": {...} }`
Error: `{ "success": false, "message": "...", "errors": {} }`
Validation (422): `{ "message": "...", "errors": { "field": ["msg"] } }`

## Error Flow

API error â†’ `DioClient` catches `DioException` â†’ maps to Exception (`ServerException`, `AuthException`, `NetworkException`) â†’ Repository catches Exception â†’ maps to Failure â†’ wrapped in `Left<Failure, T>` â†’ BLoC folds into error state â†’ UI displays error

## Interceptors (automatic)

1. **Auth**: Adds `Authorization: Bearer <token>` from SecureStorage
2. **Language**: Adds `lang` and `Accept-Language` headers
3. **Logging**: `TalkerDioLogger` (disabled in production)
4. **Retry**: `RetryInterceptor` â€” auto-retries failed GET requests (2 retries, 1s/3s backoff) on transient network errors and 5xx responses. Mutations are NOT retried; they go through `Hive local cache`.

## Offline-First

- **Reads**: Wrap fetches with `Hive TTL where implemented.evaluate(cachedAt: ...)` â€” return cached data if fresh/stale, only call API when stale (background) or expired
- **Writes**: Check `ConnectivityCubit` state first; if offline, enqueue via `Hive local cache` and emit an optimistic state instead of calling the API
- See `core/network/cache_policy.dart` and `core/network/offline_queue.dart`

