# Add / Update Localization

## Steps

1. Edit `assets/l10n/intl_en.arb`
2. Edit `assets/l10n/intl_ar.arb` (same keys, translated values)
3. Run `flutter gen-l10n`
4. Use in widgets:

```dart
final l10n = AppLocalizations.of(context);
Text(l10n.yourKey)
```

## New locale

1. Add `assets/l10n/intl_<locale>.arb`
2. Update `l10n.yaml` if needed
3. Add locale to `AppLocalizations.supportedLocales` usage in `shop_flow_app.dart`
4. `flutter gen-l10n`

## Rules

- Never hardcode user-facing strings
- Always update both EN and AR files
- Keys: `camelCase`
