# Add New API Endpoint

Connect a new backend endpoint end-to-end through all Clean Architecture layers.

## When to Use

- User asks to integrate a new API endpoint
- User says "add API", "connect endpoint", "call backend"
- A new HTTP call needs to be added to an existing or new feature

## Instructions

Reference `ecommerce_app/shopflow_readme_files/04_how_to_add_new_api.md` for detailed examples.

### Step 1 â€” Define Endpoint

In `lib/core/api/api_endpoints.dart`:

**Static:** `static const String name = '/path';`
**Dynamic:** `static String name(int id) => '/path/$id';`

Conventions:

- Group related endpoints under comment banners
- Paths do NOT include base URL or `/api/v1` prefix

### Step 2 â€” Add HTTP Call to Data Source

In the feature's `data/datasources/*_remote_datasource.dart`:

- Add method to abstract class
- Implement using `ApiClient` (get, post, put, patch, delete, uploadFile)
- Parse response with `ApiResponse.fromJson()`
- Return model(s)

### Step 3 â€” Add/Update Model

If the API returns a new data shape:

- Create or update `data/models/*_model.dart`
- Extend entity, add `fromJson`/`toJson`
- Map backend snake_case keys

### Step 4 â€” Update Domain Contract

Add method signature to abstract repository:

- Return type: `Future<Either<Failure, T>>`

### Step 5 â€” Implement in Repository

In `data/repositories/*_repository_impl.dart`:

- Wrap in try/catch
- Map exceptions to failures (Auth, Network, Server, Unexpected)

### Step 6 â€” Create Use Case

New file: `domain/usecases/<action>_usecase.dart`

- Extend `UseCase<ReturnType, Params>`
- Single responsibility

### Step 7 â€” Wire into BLoC

- Add event class
- Add handler method
- Add state if needed
- **For reads**: wrap the fetch with `CachePolicy.evaluate(cachedAt: ...)` â€” return cached data if fresh/stale, only call API when stale (background) or expired
- **For writes**: check `ConnectivityCubit` state first; if offline, enqueue via `OfflineQueue` and emit an optimistic state instead of calling the API

### Step 8 â€” Register in DI

In `core/di/injection.dart`:

- Register new use case as `registerLazySingleton`
- Update BLoC factory to inject new use case

## API Response Reference

Success: `{ "success": true, "message": "...", "data": ..., "pagination": {...} }`
Error: `{ "success": false, "message": "...", "errors": {} }`
Validation (422): `{ "message": "...", "errors": { "field": ["msg"] } }`

## ApiClient Methods

| Method | Signature |
|--------|-----------|
| GET | `apiClient.get(path, {queryParameters})` |
| POST | `apiClient.post(path, {data})` |
| PUT | `apiClient.put(path, {data})` |
| PATCH | `apiClient.patch(path, {data})` |
| DELETE | `apiClient.delete(path)` |
| Upload | `apiClient.uploadFile(path, {file, fieldName, data})` |

