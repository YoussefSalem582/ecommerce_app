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
        └── presentation/
            ├── pages/
            └── widgets/ # feature-specific UI (e.g. home/, products/, profile/)
assets/
├── l10n/                # intl_en.arb, intl_ar.arb
├── env/                 # default.env
└── lottie/
```

**Home catalog** — `lib/features/home/presentation/pages/home_page.dart` (orchestration); widgets: `home_scroll_body`, `catalog_pinned_header`, `catalog_search_bar`, `catalog_filters_section`, `catalog_product_slivers`, `catalog_category_chips`, `catalog_clear_filters_chip`, `home_app_bar` (+ `home_app_bar_title`, `home_app_bar_action`), `home_recently_viewed_section`, `home_debug_fab`, `home_spacing`.
