# Write Tests

Add tests for ShopFlow using project conventions.

## Unit tests

- Path: `test/features/<feature>/...`
- Use `package:flutter_test` / `package:test`
- Mock `Dio` or repositories with manual fakes / `mocktail` if already in project
- Test use cases and repository mapping (`Either` left/right)

## Widget tests

- Follow skill `flutter-add-widget-test`
- Pump widget with `MaterialApp` + required `BlocProvider`s or mocked blocs
- Use `TestKeys` for `find.byKey`
- Load localizations: wrap with `MaterialApp(localizationsDelegates: [AppLocalizations.delegate, ...])`

## Do not assume

- `AppLogger`, `OfflineQueue`, `CachePolicy`, `mockito` codegen — not standard here
- `ApiClient` — use `Dio` / repository fakes

## Run

```bash
flutter test
```

## After adding tests

Update `CHANGELOG.md` if coverage is a notable milestone; optional note in `CURRENT_STATUS.md`.
