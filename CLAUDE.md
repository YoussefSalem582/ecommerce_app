# Claude Code Instructions — Shim

> **Canonical conventions live in [`AGENTS.md`](AGENTS.md).** Read it first.
> This file contains **only Claude-Code-specific runtime guidance** (tool-use rules, response style, slash-commands, approved commands). Architecture, design tokens, BLoC, API, offline storage, security, and the full skill catalog all live in the canonical doc.

## Response Guidelines

- Be concise — lead with the action or answer, skip preamble.
- Do not summarize what you just did; the diff speaks for itself.
- Reference files with relative paths (e.g., `lib/core/router/app_routes.dart`).
- Ask before creating new files that aren't required by the task.
- One task at a time — complete it fully before moving on.
- After every meaningful change: update `CHANGELOG.md`, `shopflow_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md`, and `shopflow_readme_files/CURRENT_STATUS.md` (per canonical doc § Mandatory Documentation).

## Environment

- **Platform**: Windows 11 — use PowerShell syntax in Bash commands, not Unix shell.
- **Shell scripts**: Use `.ps1` equivalents (`scripts/sync_ai_ignores.ps1`, `scripts/check_docs_freshness.ps1`, `scripts/check_skills_drift.ps1`).
- **Flutter**: SDK on PATH; run via `flutter <command>`.
- **Approved commands** (no prompt needed):
  - Build / codegen: `flutter pub get`, `flutter gen-l10n`, `flutter analyze`, `flutter test`, `dart format`, `dart run build_runner build --delete-conflicting-outputs`
  - Doc tooling: `.\scripts\sync_ai_ignores.ps1`, `.\scripts\sync_ai_ignores.ps1 -Check`, `.\scripts\check_docs_freshness.ps1`, `.\scripts\check_skills_drift.ps1`
  - Skills sync: `npx skills update`, `npx skills check`

## Tool-use rules

- **Read before edit**: always read a file before modifying it.
- **Prefer targeted edits** over full rewrites unless warranted.
- **Never bypass design tokens**: use `AppColors`, `AppPalette`, theme `textTheme`.
- **Never hardcode user-facing strings**: add to `assets/l10n/intl_en.arb` + `intl_ar.arb`, run `flutter gen-l10n`.
- **Never store auth tokens in `SharedPreferences`**: use `TokenStorage` / `FlutterSecureStorage`.
- **Bash on Windows**: PowerShell-native syntax — no `&&` chaining (use `;` or separate calls).
- **Don't run interactive commands**: no `git rebase -i`, no unfilled `flutter create` prompts.

## Slash commands (`.claude/commands/`)

| Command | Purpose |
|---------|---------|
| `/add-feature` | Scaffold a Clean Architecture feature — alias of skill `add-feature` |
| `/add-api` | Wire an HTTP endpoint end-to-end — alias of skill `add-api` |
| `/add-language` | Add or update localization strings — alias of skill `add-language` |
| `/new-screen` | Add a page + BLoC to an existing feature |
| `/review` | Audit code against `AGENTS.md` |
| `/test` | Write unit/widget tests (`flutter-add-widget-test` / `dart-add-unit-test`) |
| `/update-docs` | Update `CHANGELOG.md` + doc summary + `CURRENT_STATUS.md` |
| `/clean-build` | `flutter clean` + `pub get` + `build_runner` + `gen-l10n` |

## Skill catalog (full)

19+ skills in [`.agents/skills/`](.agents/skills/) (3 project-tuned + official Flutter & Dart). Full catalog: [`AGENTS.md`](AGENTS.md) § Available Skills.

## Where to look

| Need | File |
|------|------|
| Project conventions | [`AGENTS.md`](AGENTS.md) |
| Onboarding & doc-map | [`shopflow_readme_files/INDEX.md`](shopflow_readme_files/INDEX.md) |
| Troubleshooting | [`shopflow_readme_files/TROUBLESHOOTING.md`](shopflow_readme_files/TROUBLESHOOTING.md) |
| Common pitfalls | [`shopflow_readme_files/COMMON_PITFALLS.md`](shopflow_readme_files/COMMON_PITFALLS.md) |
| Architecture decisions | [`shopflow_readme_files/decisions/`](shopflow_readme_files/decisions/) |
