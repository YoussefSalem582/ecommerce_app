# Changelog

All notable changes to ShopFlow will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> Doc-map entry point: [`shopflow_readme_files/INDEX.md`](shopflow_readme_files/INDEX.md). Live status: [`shopflow_readme_files/CURRENT_STATUS.md`](shopflow_readme_files/CURRENT_STATUS.md). Per-change deep-dives: [`shopflow_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md`](shopflow_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md).

## [Unreleased]

### Added

- **AI agent tooling scaffold** — Canonical [`AGENTS.md`](AGENTS.md), per-tool shims (`.agents/`, `.codex/`, `.github/copilot-instructions.md`, [`CLAUDE.md`](CLAUDE.md), `.cursor/rules/`), project-tuned skills (`add-feature`, `add-api`, `add-language`), `shopflow_readme_files/` doc hub, synced AI ignore files, and CI docs workflow.

### Changed

- **Agent docs aligned to ShopFlow** — Rules, Cursor `.mdc` files, Claude slash commands, and project skills now reference `DioClient`, `AppConfig`, `AppRoutes`, `AppLocalizations`, Hive offline cache, and `lib/core/widgets/` (removed Tech 92 leftovers: `ApiClient`, `OfflineQueue`, `CachePolicy`, `EnvConfig`, `RouteNames`, etc.).

## [1.0.0] - 2026-05-21

Pubspec: `1.0.0+1`. Initial freelance showcase release.

### Added

- ShopFlow e-commerce app: auth, catalog, cart, checkout (Stripe), orders, profile, wishlist, onboarding, responsive shell, AR/EN l10n, Hive offline cache, Talker logging.
