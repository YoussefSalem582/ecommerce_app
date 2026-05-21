# Add / Update Localization

Manage ARB-based internationalization for the Technology 92 app.

## When to Use

- User asks to add new strings or translations
- User says "add language", "translate", "localize", "add text"
- New user-facing text is introduced in any feature
- A new language needs to be supported

## Adding New Strings

### Step 1 â€” Add keys to English ARB

Edit `ecommerce_app/lib/l10n/arb/intl_en.arb`:

```json
"featureTitle": "Feature Title",
"featureDescription": "Description text here"
```

### Step 2 â€” Add keys to Arabic ARB

Edit `ecommerce_app/lib/l10n/arb/intl_ar.arb`:

```json
"featureTitle": "Ø¹Ù†ÙˆØ§Ù† Ø§Ù„Ù…ÙŠØ²Ø©",
"featureDescription": "Ù†Øµ Ø§Ù„ÙˆØµÙ Ù‡Ù†Ø§"
```

### Step 3 â€” Generate

Run: `flutter gen-l10n`

### Step 4 â€” Use in Code

Access via the `context.l10n` extension:

```dart
Text(context.l10n.featureTitle)
```

## Adding a New Language

Reference `ecommerce_app/shopflow_readme_files/05_how_to_add_new_language.md`.

1. Create new ARB file: `lib/l10n/arb/app_<locale>.arb`
2. Copy all keys from `intl_en.arb` and translate values
3. Update `l10n.yaml` if needed
4. Run `flutter gen-l10n`
5. Update `app.dart` to include new locale in `supportedLocales`

## Rules

- NEVER hardcode user-facing strings â€” always use ARB keys
- ALWAYS add keys to ALL ARB files (currently `intl_en.arb` and `intl_ar.arb`)
- Key naming: `camelCase`, descriptive, prefixed by feature when ambiguous
- Run `flutter gen-l10n` after every ARB change

