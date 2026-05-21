---
name: add-api
description: Wire a new Dio HTTP call through ShopFlow datasources, repositories, use cases, and BLoC.
---

# Add API — ShopFlow

Reference: `shopflow_readme_files/04_how_to_add_new_api.md`

## Steps

1. **Datasource** — add method using `DioClient.dio`:
   ```dart
   final response = await _dioClient.dio.get<List<dynamic>>('/your-path');
   ```
   Map `DioException` → `ServerException`.

2. **Model** — parse Fake Store JSON (usually direct array/map, no `{success,data}` wrapper).

3. **Repository** — `Either<Failure, T>`; on read failures try Hive cache like `ProductsRepositoryImpl`.

4. **Use case** — `@injectable` with `call()`.

5. **BLoC** — event + `result.fold()`.

6. **DI** — build_runner.

## Paths

Keep URL paths in the datasource file (no `api_endpoints.dart`).

Base URL: `AppConfig.apiBaseUrl` (via `DioClient` `BaseOptions`).

## Demo

Add parallel `Fake*RemoteDatasource` for `isDemoEnv` and register in `register_module.dart`.
