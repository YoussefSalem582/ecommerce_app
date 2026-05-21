# Clean Build

Reset generated artifacts and dependencies:

```powershell
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze
```

Do not commit `.dart_tool/` or `build/` output.
