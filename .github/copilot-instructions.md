# Copilot Instructions — Shim

> **Canonical conventions live in [`../AGENTS.md`](../AGENTS.md).**
> Read that file first for architecture, design tokens, BLoC, API, security, documentation requirements, and skills.
>
> This file contains **only Copilot-specific runtime guidance**.

## Copilot-specific behavior

### Inline completion

- **Never invent** `Color(0xFF…)`, hardcoded route strings, or API paths. Use `AppColors`, `AppPalette`, `AppRoutes`, `AppConfig`.
- **Never** suggest user-facing string literals — use generated l10n from `assets/l10n/intl_*.arb`.
- **Never** suggest `SharedPreferences` for JWT — use `TokenStorage`.
- Respect Clean Architecture layers — no Flutter imports in `domain/`.

### Copilot Chat

- For new endpoints/features: use `.agents/skills/add-api` or `add-feature`.
- For tests: `flutter-add-widget-test` / `dart-add-unit-test`.
- Check `shopflow_readme_files/decisions/` for rationale.

### Comment-trigger generation

- New BLoC: separate `*_event.dart`, `*_state.dart`, `Either` in repository.
- New route: `AppRoutes` + `app_router.dart`.
- New strings: both ARB files + `flutter gen-l10n`.

### Windows / PowerShell

- Suggest `scripts/*.ps1`, not bash-only one-liners.

## Where to look

| Need | Location |
|------|----------|
| Conventions | [`../AGENTS.md`](../AGENTS.md) |
| Skills | [`../.agents/skills/`](../.agents/skills/) |
| Doc-map | [`../shopflow_readme_files/INDEX.md`](../shopflow_readme_files/INDEX.md) |
| Pitfalls | [`../shopflow_readme_files/COMMON_PITFALLS.md`](../shopflow_readme_files/COMMON_PITFALLS.md) |
