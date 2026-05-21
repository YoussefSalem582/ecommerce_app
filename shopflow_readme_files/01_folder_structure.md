# Folder Structure

```
lib/
├── app/                 # ShopFlowApp, MaterialApp.router
├── core/
│   ├── config/          # AppConfig (env)
│   ├── constants/       # StorageKeys, TestKeys
│   ├── di/              # GetIt + injectable
│   ├── error/           # Failures, exceptions
│   ├── l10n/gen/        # Generated localizations
│   ├── network/         # DioClient, interceptors, connectivity
│   ├── router/          # GoRouter, AppRoutes, shell
│   ├── theme/           # AppColors, AppTheme, extensions
│   └── widgets/         # Shared UI
└── features/
    └── <name>/          # data / domain / presentation
assets/
├── l10n/                # intl_en.arb, intl_ar.arb
├── env/                 # default.env
└── lottie/
```
