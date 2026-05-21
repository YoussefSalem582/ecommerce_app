# How to Add a New API Call

Use skill [`add-api`](../.agents/skills/add-api/SKILL.md).

1. Extend feature `*_remote_datasource.dart` with Dio call against `AppConfig.apiBaseUrl`
2. Parse JSON in `*_model.dart`
3. Expose on domain repository → impl with exception mapping
4. Add use case + BLoC handler
5. Register in injectable; run build_runner

Fake Store paths live in existing datasources (e.g. `fake_products_remote_datasource.dart`) — follow their style for new endpoints.
