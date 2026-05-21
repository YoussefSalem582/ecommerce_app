---
name: add-language
description: Add or update ShopFlow ARB strings (EN + AR) and regenerate l10n.
---

# Add Language — ShopFlow

## New strings

1. `assets/l10n/intl_en.arb`
2. `assets/l10n/intl_ar.arb`
3. `flutter gen-l10n`
4. `AppLocalizations.of(context).keyName`

## Config

- `l10n.yaml` — output `lib/core/l10n/gen/`
- Do **not** run `flutter-setup-localization` skill (already configured)

## New locale

See `shopflow_readme_files/05_how_to_add_new_language.md`.
