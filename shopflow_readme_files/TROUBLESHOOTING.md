# Troubleshooting

## `flutter pub get` fails

- Run skill/workflow `dart-resolve-package-conflicts`
- Check SDK constraint in `pubspec.yaml` (^3.11.5)

## L10n not found after adding keys

```bash
flutter gen-l10n
```

Ensure keys exist in **both** `intl_en.arb` and `intl_ar.arb`.

## Injectable / GetIt missing registration

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Dio / SSL / emulator network

- `DioClient` sets mobile browser UA for some CDN paths
- Verify `AppConfig.apiBaseUrl` in env
- Check Talker logs (debug page / console)

## AI ignore files out of sync

```powershell
.\scripts\sync_ai_ignores.ps1
```
