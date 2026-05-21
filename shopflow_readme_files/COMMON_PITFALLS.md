# Common Pitfalls

| Don't | Do instead |
|-------|------------|
| `RouteNames`, `'/home'` | `AppRoutes.home` |
| `context.l10n` (no extension in this app) | `AppLocalizations.of(context).key` |
| `lib/l10n/arb/app_en.arb` | `assets/l10n/intl_en.arb` + `intl_ar.arb` |
| `EnvConfig`, `--dart-define` for all secrets | `AppConfig` + `dotenv` (`assets/env/default.env`, optional `.env`) |
| `ApiClient`, `ApiResponse`, `api_endpoints.dart` | `DioClient.dio`, paths in datasource |
| `OfflineQueue`, `CachePolicy` | Hive cache in repository + `ConnectivityCubit` banner |
| `AppLogger.logBlocTransition` | `TalkerBlocObserver` (global in `main.dart`) |
| `AppSpacing`, `AppTextStyles` (Tech 92 tokens) | `AppPalette`, `Theme.textTheme`, `AppTypography` |
| `lib/shared/widgets/` | `lib/core/widgets/` |
| `injection_container.dart`, `lib/app.dart` | `lib/core/di/injection.dart`, `lib/app/shop_flow_app.dart` |
| `UseCase<T, Params>` base class | `@injectable` class with `call()` |
| JWT in SharedPreferences | `TokenStorage` |
| Edit `.*ignore` by hand | `scripts/ai_ignore_template.txt` + `sync_ai_ignores.ps1` |
