# Codex CLI Instructions — Shim

> **Canonical conventions live in [`../AGENTS.md`](../AGENTS.md).** Read the canonical doc first; this file contains **only Codex-specific runtime guidance**.

## Codex Runtime Conventions

- **Approval mode**: Default `auto-edit` for documentation, `suggest` for `lib/**`, `ios/**`, `android/**`.
- **Network**: May run `flutter pub get`, `flutter gen-l10n`, `flutter analyze`, `flutter test`, `dart format`, `dart run build_runner build`, `npx skills update`, and `scripts/*.ps1` without prompting. Other network/git commands need user approval.
- **Shell**: Windows 11 / PowerShell — prefer `.ps1` scripts over `.sh`.

## Workflow Tips

1. Plan file list before multi-file edits.
2. Edit domain → data → presentation per dependency rule.
3. Run `flutter analyze` between layers when refactoring.
4. Update docs last: `CHANGELOG.md`, `DOCUMENTATION_UPDATE_SUMMARY.md`, `CURRENT_STATUS.md`.

- **Prefer `apply_patch`** over shell sed for edits.
- **Use `flutter analyze`** as the project lint check.

## Hard Constraints (DO NOT)

- Do NOT hardcode secrets, API URLs, or hex colours — use `AppConfig`, `AppColors`, `AppPalette`.
- Do NOT use raw UI strings — ARB + `flutter gen-l10n`.
- Do NOT store JWT in `SharedPreferences`.
- Do NOT push or `--no-verify` without explicit permission.
- Do NOT manually edit official skills tracked in `skills-lock.json` — use `npx skills update`.

## Skills

Read [`../.agents/skills/`](../.agents/skills/). Prefer `add-feature`, `add-api`, `add-language` over generic Flutter skills.

## Where to look

| Need | File |
|------|------|
| Canonical conventions | [`../AGENTS.md`](../AGENTS.md) |
| Doc-map | [`../shopflow_readme_files/INDEX.md`](../shopflow_readme_files/INDEX.md) |
