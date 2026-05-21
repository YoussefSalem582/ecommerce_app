---
name: add-language
description: Add or update localization strings for ShopFlow (EN + AR). Use when adding user-facing text or translations.
---

# Add / Update Localization

ARB-based i18n for ShopFlow.

## Adding new strings

### Step 1 — English ARB

Edit `assets/l10n/intl_en.arb`:

```json
"featureTitle": "Feature Title"
```

### Step 2 — Arabic ARB

Edit `assets/l10n/intl_ar.arb` with translated values.

### Step 3 — Generate

```bash
flutter gen-l10n
```

Output: `lib/core/l10n/gen/app_localizations.dart`

### Step 4 — Use in widgets

```dart
final l10n = AppLocalizations.of(context);
Text(l10n.featureTitle)
```

## Rules

- Never hardcode user-facing strings
- Always update **both** ARB files
- Keys: `camelCase`, feature-prefixed when ambiguous
- Config: `l10n.yaml` — do not use `flutter-setup-localization` skill (already wired)

## New locale

See `shopflow_readme_files/05_how_to_add_new_language.md`.
