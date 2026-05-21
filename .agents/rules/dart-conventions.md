---
description: "Dart/Flutter code conventions for the Technology 92 app"
globs: "ecommerce_app/**/*.dart"
alwaysApply: false
---

# Dart & Flutter Conventions

## Design Tokens â€” Never Hardcode

- **Colors**: Use `AppColors.primary`, `AppColors.error`, etc. â€” never `Color(0xFF...)` or `Colors.blue`
- **Typography**: Use `AppTextStyles.bodyLarge`, `AppTextStyles.titleMedium`, etc.
- **Spacing**: Use `AppSpacing.verticalBase`, `AppSpacing.paddingAll16`, `AppSpacing.pagePadding`
- **Radius**: Use `AppRadius.md`, `AppRadius.lg`, etc.
- **Assets**: Use `AppImages.logo`, `AppIcons.settings` â€” never hardcode asset paths
- **Routes**: Use `AppRoutes.home`, `AppRoutes.login` â€” never hardcode path strings

## Localization

- All user-facing strings go through `context.l10n.someKey`
- Add keys to BOTH `assets/l10n/intl_en.arb` and `lib/l10n/arb/intl_ar.arb`
- Run `flutter gen-l10n` after adding keys

## Import Order

1. Dart SDK (`dart:`)
2. Flutter SDK (`package:flutter/`)
3. Third-party packages (`package:`)
4. Project imports (relative)

## Naming

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/functions: `camelCase`
- Constants: `camelCase` (Dart convention, not SCREAMING_CASE)
- Private members: `_prefixed`

## Shared Widgets

Always check `lib/core/widgets/` before creating new widgets:
- `AppButton` â€” Elevated/outlined/text/icon/loading button
- `AppTextField` â€” Text field, password field, dropdown
- `AppPhoneField` â€” Phone input with country code picker
- `AppDropdownField` â€” Dropdown selector
- `AppSearchableDropdownField` â€” Searchable dropdown selector
- `AppDateField` â€” Date input field
- `AppDateInputSheet` â€” Date input bottom sheet
- `AppCard` â€” Themed Card wrapper
- `AppLoading` â€” Spinner, overlay, shimmer
- `AppErrorWidget` â€” Error display with retry
- `EmptyStateWidget` â€” Illustration + title + action
- `CustomAppBar` â€” Themed AppBar
- `AppBottomSheet` â€” Bottom sheet helper
- `UnsavedChangesDialog` â€” Unsaved changes confirmation
- `PdfViewerPage` â€” Full-screen PDF viewer
- `VideoPlayerPage` â€” In-app video player
- `PhotoPickerBottomSheet` â€” Photo picker sheet
- `ResponsiveLayout` â€” Breakpoint builder
- `AuthPatternBackground` â€” Auth page background pattern
- `ConnectivityBanner` â€” Online/offline status banner
- `OfflineBanner` â€” Offline notification banner
- `AppToast` â€” Toast notification
- `TranslationPendingBanner` â€” Translation pending indicator
- `AppDateFilter` â€” Date range filter widget
- `FilterIconButton` â€” Filter icon button
- `FilterSheetActions` â€” Filter sheet action buttons

## Error Extensions

Use `context.showError()`, `context.showSuccess()` from `context_extensions.dart`.

## Storage Keys

Centralize all storage key strings in `core/constants/storage_keys.dart`.

