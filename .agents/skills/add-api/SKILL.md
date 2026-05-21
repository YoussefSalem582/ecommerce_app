---
name: add-api
description: Add a new API endpoint integration end-to-end through Dio, data source, model, repository, use case, and BLoC. Use when connecting a new HTTP endpoint.
---

# Add New API Endpoint

Connect a new HTTP call through Clean Architecture layers.

## When to Use

- User asks to integrate a new API endpoint or Fake Store path
- User says "add API", "connect endpoint"

## Instructions

Reference `shopflow_readme_files/04_how_to_add_new_api.md`.

### Step 1 — Data source

In `data/datasources/*_remote_datasource.dart`:

- Add method to abstract class + implementation
- Use injected `Dio` from `DioClient` (GET/POST/PUT/PATCH/DELETE)
- Base URL comes from `AppConfig.apiBaseUrl`
- Parse JSON into models; map snake_case keys

### Step 2 — Model / entity

- Update or create `data/models/*_model.dart` with `fromJson`

### Step 3 — Domain repository

- Add `Future<Either<Failure, T>>` method to abstract repository

### Step 4 — Repository impl

- try/catch → map `DioException` and app exceptions to `Failure` types in `lib/core/error/`

### Step 5 — Use case + BLoC

- New use case class
- New event/handler in feature BLoC
- For offline-sensitive reads: consult existing Hive datasource patterns in sibling features (`products`, `orders`)

### Step 6 — DI

- Annotate new classes; run build_runner
- Wire use case into BLoC constructor

### Step 7 — Connectivity

- If the UI must block when offline, read `ConnectivityCubit` before network-only mutations

## Dio reference

| Method | Usage |
|--------|--------|
| GET | `dio.get(path, queryParameters: ...)` |
| POST | `dio.post(path, data: ...)` |

Do not log sensitive auth bodies (see `DioClient` redaction rules).
