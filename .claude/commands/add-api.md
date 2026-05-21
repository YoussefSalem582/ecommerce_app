# Add New API Endpoint

Wire HTTP for ShopFlow through existing Dio + repository patterns.

Reference: `shopflow_readme_files/04_how_to_add_new_api.md` and `.agents/skills/add-api/SKILL.md`.

## Steps

1. Add method to `*_remote_datasource.dart` using `_dioClient.dio.get/post/...` with Fake Store-style paths (e.g. `/products`, `/products/$id`)
2. Map `DioException` → `ServerException` in datasource
3. Update model `fromJson` if response shape is new
4. Domain repository + impl with `Either<Failure, T>`
5. `@injectable` use case + BLoC event/handler
6. build_runner + analyze

## Offline reads

If catalog-like: add `local_*_datasource.dart` (Hive) and fall back in repository on remote failure — mirror `ProductsRepositoryImpl`.

## Demo mode

Provide `Fake*RemoteDatasource` when `AppConfig.isDemoEnv` is true; register in DI module.

## Checklist

- [ ] No `api_endpoints.dart` (paths live in datasource)
- [ ] No `ApiClient` / `ApiResponse` envelope (Fake Store returns raw JSON)
- [ ] Docs updated per `AGENTS.md`
