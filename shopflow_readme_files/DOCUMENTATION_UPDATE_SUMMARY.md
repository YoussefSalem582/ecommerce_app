# Documentation Update Summary

Reverse-chronological log of doc/agent-tooling changes (not app release notes — see [`../CHANGELOG.md`](../CHANGELOG.md)).

---

## 2026-05-21 — AI agent scaffolding (initial)

- Added canonical [`AGENTS.md`](../AGENTS.md), [`CLAUDE.md`](../CLAUDE.md), `.agents/`, `.codex/`, `.github/copilot-instructions.md`, `.cursor/rules/`, `.claude/commands/`
- Added `shopflow_readme_files/` doc hub (this folder)
- Added project skills: `add-feature`, `add-api`, `add-language`
- Added `scripts/sync_ai_ignores.*`, `check_docs_freshness.*`, `check_skills_drift.*`, `skills-lock.json`, `.github/workflows/docs.yml`
- Synced all `.*ignore` files from `scripts/ai_ignore_template.txt`

## 2026-05-21 — ShopFlow-specific agent doc pass

- Rewrote all `.agents/rules/` and regenerated `.cursor/rules/*.mdc` for ShopFlow (DioClient, AppConfig, Hive, AppRoutes, AppLocalizations, no Tech 92 tokens)
- Rewrote `.claude/commands/*` (8 commands) to match real architecture
- Updated project skills `add-feature`, `add-api`, `add-language`
- Updated `shopflow_readme_files/02_architecture.md`, `04_how_to_add_new_api.md`, `COMMON_PITFALLS.md`
- Removed unrelated `scripts/ios_attendance_widget_setup.rb` from Tech 92 copy
