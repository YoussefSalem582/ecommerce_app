# Common Pitfalls

| Don't | Do instead |
|-------|------------|
| Hardcode `'/home'` routes | `AppRoutes.home` |
| Raw `Text('Hello')` in UI | `AppLocalizations.of(context).key` |
| Store JWT in SharedPreferences | `TokenStorage` |
| `Color(0xFF059669)` in features | `AppColors` / `AppPalette` |
| Flutter imports in `domain/` | Keep domain pure Dart |
| Skip ARB Arabic file | Update `intl_en.arb` **and** `intl_ar.arb` |
| Edit `.*ignore` by hand | Edit `scripts/ai_ignore_template.txt` + sync script |
| Duplicate full `AGENTS.md` in shims | Edit root `AGENTS.md` only |
