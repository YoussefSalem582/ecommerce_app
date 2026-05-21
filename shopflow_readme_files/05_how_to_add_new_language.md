# How to Add or Update Languages

## Update EN + AR strings

1. Edit `assets/l10n/intl_en.arb` and `assets/l10n/intl_ar.arb`
2. `flutter gen-l10n`
3. Use `AppLocalizations.of(context).yourKey`

## Add a third locale

1. Add `assets/l10n/intl_<locale>.arb`
2. Update `l10n.yaml` if needed
3. Add locale to `ShopFlowApp` `supportedLocales`
4. `flutter gen-l10n`

Skill: [`add-language`](../.agents/skills/add-language/SKILL.md).
