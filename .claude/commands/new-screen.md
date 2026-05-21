# New Screen (existing feature)

Add a page + BLoC wiring to an **existing** feature module.

## Steps

1. Create `presentation/pages/<name>_page.dart`
2. Add events/states/handlers to existing BLoC (or new BLoC if isolated flow)
3. Add `AppRoutes` constant in `lib/core/router/app_routes.dart`
4. Add `GoRoute` in `lib/core/router/app_router.dart`
5. ARB keys in `assets/l10n/intl_en.arb` + `intl_ar.arb` → `flutter gen-l10n`
6. Use `AppPalette` / `textTheme` / `AppLocalizations.of(context)`

## Shell vs full-screen

- Tab content: nested under `StatefulShellRoute` in `app_router.dart`
- Modal flows (checkout, edit profile): top-level `GoRoute` outside shell

## Offline

- Reads: repository Hive fallback (see products feature)
- Writes: cart/orders patterns are local-first; use `ConnectivityCubit` only when UX requires blocking

## Checklist

- [ ] Route uses `AppRoutes`, not string literal
- [ ] Strings in both ARB files
- [ ] Docs updated if behavior is user-visible
