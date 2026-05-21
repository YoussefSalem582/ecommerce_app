# Agent Instructions — Generic Shim

> **Canonical conventions live in [`../AGENTS.md`](../AGENTS.md).** Read it first.
> This file is a thin shim for generic agents reading from `.agents/`. It contains only the **skill catalog pointer** + folder map.

## Scope

- Edit files **only** inside this repository (ShopFlow / `ecommerce_app`).

## Skills (in this directory)

All skill prompts live in [`./skills/`](./skills/) in universal SKILL.md format.

- **3 project-tuned** (prefer over official skills for overlapping workflows):
  - `add-feature` — Clean Architecture feature + DI + GoRouter + ARB l10n
  - `add-api` — Dio → repository → BLoC
  - `add-language` — `intl_en.arb` / `intl_ar.arb` + `flutter gen-l10n`
- **Official Flutter & Dart skills** — see [`../AGENTS.md`](../AGENTS.md) § Available Skills.

### Updating official skills

```bash
npx skills update
```

Hashes in [`../skills-lock.json`](../skills-lock.json); verified by `scripts/check_skills_drift.ps1`.

## Where to look

| Need | File |
|------|------|
| Project conventions | [`../AGENTS.md`](../AGENTS.md) |
| Doc-map | [`../shopflow_readme_files/INDEX.md`](../shopflow_readme_files/INDEX.md) |
| Troubleshooting | [`../shopflow_readme_files/TROUBLESHOOTING.md`](../shopflow_readme_files/TROUBLESHOOTING.md) |
| Pitfalls | [`../shopflow_readme_files/COMMON_PITFALLS.md`](../shopflow_readme_files/COMMON_PITFALLS.md) |
| ADRs | [`../shopflow_readme_files/decisions/`](../shopflow_readme_files/decisions/) |
