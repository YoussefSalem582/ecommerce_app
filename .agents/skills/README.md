# ShopFlow skills

## Use these first (project-tuned)

| Skill | Use when |
|-------|----------|
| [`add-feature`](add-feature/SKILL.md) | New feature module |
| [`add-api`](add-api/SKILL.md) | New Dio / Fake Store call |
| [`add-language`](add-language/SKILL.md) | ARB strings EN + AR |

These match ShopFlow: `DioClient`, `AppConfig`, `AppRoutes`, `AppLocalizations`, Hive, injectable.

## Official skills (from `npx skills add`)

Tracked in [`skills-lock.json`](../../skills-lock.json). **Do not edit** locked folders by hand — run `npx skills update`.

When an official skill disagrees with ShopFlow, **ignore the official skill** and follow [`AGENTS.md`](../../AGENTS.md) + project skills above.

| Official skill | ShopFlow override |
|----------------|-------------------|
| `flutter-setup-localization` | Already configured — use `add-language` |
| `flutter-setup-declarative-routing` | GoRouter exists — use `AppRoutes` |
| `flutter-use-http-package` | Use Dio (`DioClient`) |
| `flutter-apply-architecture-best-practices` | Generic `ApiClient` — use `add-feature` |
| `dart-generate-test-mocks` | Mock `Dio` or repositories, not `ApiClient` |
| `dart-build-cli-app` | N/A — mobile app |

Full catalog: [`AGENTS.md`](../../AGENTS.md) § Available Skills.
