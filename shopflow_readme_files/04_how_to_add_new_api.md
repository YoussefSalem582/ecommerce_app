# How to Add a New API Call

## HTTP (live / Fake Store)

1. Open or create `data/datasources/*_remote_datasource.dart`
2. Inject `DioClient`, call `_dioClient.dio.get/post/...`
3. Paths are relative to `BASE_URL` (default `https://fakestoreapi.com`), e.g. `/products`, `/auth/login`
4. Parse JSON in models — Fake Store returns **raw** JSON, not a wrapped envelope
5. On `DioException`, throw `ServerException` with a safe message

## Repository

```dart
try {
  final data = await _remote.fetch();
  await _local.save(...); // optional Hive cache
  return Right(data);
} on ServerException catch (e, st) {
  _talker.handle(e, st);
  return _serveCached(...); // optional
}
```

Map to `ServerFailure`, `CacheFailure`, `NetworkFailure`, or `UnexpectedFailure`.

## Demo stub

When `AppConfig.isDemoEnv`, DI should bind `Fake*RemoteDatasource` (see `FakeProductsRemoteDatasource`, `FakeAuthRemoteDatasource`).

## Register

`@injectable` on datasource, repository, use case → `dart run build_runner build --delete-conflicting-outputs`

Skill: [`add-api`](../.agents/skills/add-api/SKILL.md).
