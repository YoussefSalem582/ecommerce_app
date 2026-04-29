# Flutter E-Commerce Template — Freelance Showcase

> **Stack:** Flutter · BLoC · Clean Architecture · Stripe · Hive (offline-first) · Talker · l10n · Animations

---

## Project Vision

A production-grade Flutter e-commerce template built as a **freelance showcase** for Youssef Salem Hassan. Every architectural decision is intentional, documented, and visible — the code itself is the portfolio piece. Clients browsing the repo or live demo should immediately see: Clean Architecture, real payment integration, offline resilience, and polished animations.

---

## Feature Scope

### Core MVP
| Feature | Details |
|---|---|
| Auth | Email/password + Google Sign-In, JWT refresh, secure storage |
| Product Catalog | List, grid toggle, search, category filter, PDP with image gallery |
| Cart | Add/remove, quantity update, persisted offline (Hive) |
| Wishlist | Toggle heart, persisted locally |
| Checkout | Stripe payment sheet, order summary, address form |
| Order History | List + detail, status timeline |
| Profile | Edit info, avatar upload, logout |
| Settings | Theme toggle (dark/light), language toggle (AR/EN), notifications |

### Showcase-Specific Extras
- Talker log console (debug overlay, shake to open)
- Network status banner (offline mode indicator)
- Skeleton loaders on every list
- Page transitions (shared element, slide, fade)
- Animated cart badge counter
- Pull-to-refresh with custom lottie/animation

---

## Folder Structure

```
lib/
├── core/
│   ├── di/                        # GetIt service locator
│   ├── error/                     # Failures, exceptions, Either
│   ├── network/                   # Dio client, interceptors, connectivity
│   ├── router/                    # GoRouter + auth guard
│   ├── theme/                     # AppTheme, AppColors, AppTypography
│   ├── l10n/                      # ARB files, AppLocalizations
│   ├── utils/                     # Extensions, helpers
│   └── widgets/                   # Shared widgets (buttons, loaders, snackbars)
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/       # remote_auth_datasource.dart, local_auth_datasource.dart
│   │   │   ├── models/            # user_model.dart
│   │   │   └── repositories/     # auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/          # user_entity.dart
│   │   │   ├── repositories/     # auth_repository.dart (abstract)
│   │   │   └── usecases/         # login_usecase.dart, logout_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/              # auth_bloc.dart, auth_event.dart, auth_state.dart
│   │       ├── pages/             # login_page.dart, register_page.dart
│   │       └── widgets/
│   │
│   ├── products/                  # same structure
│   ├── cart/                      # same structure
│   ├── checkout/                  # same structure
│   ├── orders/                    # same structure
│   └── profile/                   # same structure
│
└── main.dart
```

---

## Tech Stack & Packages

```yaml
# pubspec.yaml key packages

# State Management
flutter_bloc: ^8.1.5
bloc: ^8.1.4

# Navigation
go_router: ^13.2.0

# Networking
dio: ^5.4.3
pretty_dio_logger: ^1.3.1

# Offline / Local Storage
hive_flutter: ^1.1.0
hive: ^2.2.3
shared_preferences: ^2.2.3

# Payment
flutter_stripe: ^10.1.1

# DI
get_it: ^7.6.7
injectable: ^2.3.2

# Logging & Testing
talker_flutter: ^4.2.0
talker_bloc_observer: ^4.2.0
talker_dio_logger: ^4.2.0

# Localization
intl: ^0.19.0

# UI & Animations
lottie: ^3.1.0
shimmer: ^3.0.0
cached_network_image: ^3.3.1
flutter_animate: ^4.5.0
animations: ^2.0.11

# Functional programming
dartz: ^0.10.1

# Env & Config
flutter_dotenv: ^5.1.0

# Code generation
freezed: ^2.4.7
json_serializable: ^6.7.1
injectable_generator: ^2.4.1
hive_generator: ^2.0.1
build_runner: ^2.4.9
```

---

## Localization (AR/EN)

```
assets/l10n/
├── intl_en.arb
└── intl_ar.arb
```

**Text direction**: Full RTL support via `Directionality` widget and `TextDirection.rtl` for Arabic.

**Switching**: `LanguageCubit` emits `Locale`, `MaterialApp.router` listens to it — no restart needed.

---

## Theme System

```dart
// Two complete ThemeData objects — no hardcoded colors anywhere in feature code
abstract class AppColors {
  static const primary = Color(0xFF1565C0);      // deep blue
  static const accent  = Color(0xFFFF6D00);      // orange
  static const surface = Color(0xFFF8F9FA);
  // dark variants...
}

// ThemeCubit emits ThemeMode — persisted in SharedPreferences
```

---

## Offline-First Architecture

```
User requests products
       │
       ▼
Repository.getProducts()
       │
       ├─── Hive cache exists & fresh? ──► Return cached, trigger BG refresh
       │
       └─── No cache / stale? ─────────► Fetch remote → save to Hive → return
                                              │
                                         Network error?
                                              │
                                         Return cached (stale-while-error)
                                         + show offline banner
```

Cart is **always local-first** — synced to backend on connectivity restore via `ConnectivityCubit`.

---

## Talker Integration (Logging & Debug)

```dart
// main.dart — one TalkerFlutter instance wired everywhere
final talker = TalkerFlutter.init();

// BLoC observer
Bloc.observer = TalkerBlocObserver(talker: talker);

// Dio interceptor
dio.interceptors.add(TalkerDioLogger(talker: talker));

// In-app log viewer — shake to open (debug builds only)
TalkerScreen(talker: talker)  // accessible via router /debug-logs
```

Every BLoC transition, API call, cache hit/miss, and error is logged with context — reviewers and clients can see the full request lifecycle in real time.

---

## Animation & Transitions Map

| Screen/Element | Animation |
|---|---|
| Splash → Home | Fade + scale logo, slide up nav |
| Product card tap | Hero image transition to PDP |
| Add to cart | Fly-to-cart animation (item flies to badge) |
| Cart badge | Bounce + number count-up |
| Page route | `FadeTransition` default, `SlideTransition` for modals |
| Bottom nav switch | `AnimatedSwitcher` with fade |
| Skeleton loaders | `Shimmer` on all list/grid items |
| Success screen | Lottie checkmark after checkout |
| Pull to refresh | Custom `RefreshIndicator` with brand color |
| Button press | `ScaleTransition` micro-interaction |
| Error state | Slide-in from bottom with shake |

---

## Stripe Checkout Flow

```dart
// 1. Create payment intent on backend (or mock endpoint)
// 2. Init Stripe SDK with publishable key from .env
// 3. Present payment sheet
// 4. Handle success/failure in CheckoutBloc

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  // Events: InitiatePayment, PaymentSucceeded, PaymentFailed
  // States: Initial, Loading, PaymentSheetReady, Success, Failure
}
```

Test cards documented in README for reviewer convenience.

---

## Responsive Breakpoints

```dart
// LayoutBuilder-based responsive grid
// Mobile  (<600px): 1-2 columns
// Tablet  (600-900px): 3 columns  
// Desktop (>900px): 4 columns + side drawer nav

class AppBreakpoints {
  static const mobile  = 600.0;
  static const tablet  = 900.0;
  static const desktop = 1200.0;
}
```

Flutter web + desktop builds included — demonstrates cross-platform capability for clients.

---

## Screens Inventory (14 screens)

1. Splash
2. Onboarding (3 slides)
3. Login
4. Register
5. Home / Product Grid
6. Product Detail (PDP)
7. Search & Filter
8. Cart
9. Checkout (address + payment)
10. Order Success
11. Order History
12. Order Detail
13. Profile / Edit Profile
14. Settings (theme + language)

---

## README Structure (Showcase-Optimized)

```
README.md
├── Demo GIF
├── Architecture diagram (this doc)
├── Features checklist
├── Tech stack badges
├── How to run (with .env setup)
├── Stripe test cards
├── Folder structure
├── Key design decisions
└── Hire me / Contact section → links to Mostaql + LinkedIn
```

---
---
---

# CURSOR PROMPT
> Paste this entire block into Cursor's composer or system prompt

---

```
You are building a production-grade Flutter e-commerce template app 
named "ShopFlow" — a freelance showcase for a Flutter developer. 
Every implementation decision must reflect senior-level Clean Architecture 
standards. Follow these rules strictly at all times.

═══════════════════════════════════════════════
ARCHITECTURE — MANDATORY
═══════════════════════════════════════════════

Enforce Clean Architecture with 3 layers in every feature:

  Presentation  →  Domain  →  Data

Rules:
- Domain layer has ZERO Flutter imports. Pure Dart only.
- All repository definitions are abstract interfaces in domain/.
- Data layer implements domain interfaces.
- Presentation communicates with domain via use cases only — 
  never calls repositories directly.
- Use Either<Failure, T> (dartz) for all use case return types.
- Each feature is a self-contained folder: 
  features/{feature_name}/{data,domain,presentation}/
- Shared code goes in core/ only.

═══════════════════════════════════════════════
STATE MANAGEMENT — BLoC
═══════════════════════════════════════════════

- Use flutter_bloc for ALL state management.
- Every feature gets its own BLoC or Cubit.
- BLoC for complex event streams (products, cart, checkout).
- Cubit for simple toggle state (theme, language, connectivity).
- States must be immutable — use Equatable or Freezed.
- Events/States in separate files: *_bloc.dart, *_event.dart, *_state.dart
- Register a TalkerBlocObserver at app startup — log every transition.
- Never use setState() outside of a widget that has no business logic.
- Provide BLoCs via MultiBlocProvider in main.dart using GetIt.

═══════════════════════════════════════════════
DEPENDENCY INJECTION — GetIt + Injectable
═══════════════════════════════════════════════

- Use get_it with injectable annotations.
- Annotate: @singleton for repositories, @lazySingleton for services,
  @injectable for use cases and BLoCs.
- Run: flutter pub run build_runner build --delete-conflicting-outputs
  whenever new @injectable classes are added.
- All DI registration in core/di/injection.dart.
- Never use a service locator inside a widget — inject via constructor.

═══════════════════════════════════════════════
LOGGING — TALKER (non-negotiable)
═══════════════════════════════════════════════

- Initialize ONE TalkerFlutter instance in main.dart.
- Wire it to: TalkerBlocObserver, TalkerDioLogger, manual talker.info/
  talker.error calls for cache hits, auth events, payment steps.
- Add a /debug-logs route accessible via floating debug button 
  in DEBUG mode only (kDebugMode guard).
- Log format: include timestamp, feature name, and context.
- Every catch block must call talker.handle(error, stackTrace).
- Do NOT use print() anywhere — Talker only.

═══════════════════════════════════════════════
OFFLINE-FIRST — HIVE
═══════════════════════════════════════════════

- All list data (products, orders, cart) must be cached in Hive boxes.
- Repository implementation strategy:
    1. Try remote fetch.
    2. On success: write to Hive, return data.
    3. On failure: read from Hive, return stale data + emit OfflineState.
- Cart is local-first: always read/write Hive, sync to backend 
  when ConnectivityCubit emits ConnectedState.
- Use hive_generator and @HiveType/@HiveField annotations on all models.
- Open all Hive boxes in main() before runApp().
- ConnectivityCubit listens to connectivity_plus stream.
- Show a persistent amber banner when offline — dismiss on reconnect.

═══════════════════════════════════════════════
NETWORKING — DIO
═══════════════════════════════════════════════

- One Dio instance configured in core/network/dio_client.dart.
- Interceptors: AuthInterceptor (inject Bearer token), 
  TalkerDioLogger, RetryInterceptor (3 retries, exponential backoff).
- API base URL from .env via flutter_dotenv. Never hardcode URLs.
- All responses mapped to Either<NetworkFailure, T>.
- Create typed DioException handlers for: 401, 403, 404, 500, timeout.
- Separate ApiService class per feature (ProductApiService, 
  AuthApiService, OrderApiService).

═══════════════════════════════════════════════
PAYMENT — STRIPE
═══════════════════════════════════════════════

- Use flutter_stripe with Payment Sheet.
- STRIPE_PUBLISHABLE_KEY in .env — loaded at app startup.
- CheckoutBloc events: InitiatePayment, ConfirmPayment, 
  PaymentSucceeded, PaymentFailed, PaymentCanceled.
- Present Stripe.instance.presentPaymentSheet() from CheckoutBloc handler.
- After success: create Order entity, persist locally, sync to backend.
- Show Lottie success animation on OrderSuccessPage.
- Document test card numbers in README: 
  4242424242424242, 4000000000000002 (decline).

═══════════════════════════════════════════════
LOCALIZATION — AR / EN
═══════════════════════════════════════════════

- Use Flutter's official intl + arb approach.
- Files: assets/l10n/intl_en.arb and intl_ar.arb.
- Add generate: true to pubspec.yaml.
- All user-facing strings in ARB files. ZERO hardcoded strings in widgets.
- LanguageCubit stores Locale, persisted via SharedPreferences.
- MaterialApp.router: 
    locale: context.watch<LanguageCubit>().state,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates
- Arabic: enforce TextDirection.rtl using Directionality wrapper on root.
- Number formatting: use intl NumberFormat for prices in both locales.

═══════════════════════════════════════════════
THEMING — DARK / LIGHT
═══════════════════════════════════════════════

- Two complete ThemeData objects in core/theme/:
    AppTheme.light() and AppTheme.dark()
- AppColors class with named static constants (no raw hex in widgets).
- AppTypography class with all TextStyle definitions.
- ThemeCubit emits ThemeMode, persisted in SharedPreferences.
- MaterialApp.router:
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    themeMode: context.watch<ThemeCubit>().state
- Never use Theme.of(context).colorScheme.xxx directly in feature widgets — 
  use extension methods on BuildContext: context.appColors.primary.

═══════════════════════════════════════════════
ROUTING — GOROUTER
═══════════════════════════════════════════════

- All routes defined in core/router/app_router.dart.
- Named routes with path constants in AppRoutes class.
- AuthGuard redirect: unauthenticated users → /login.
- ShellRoute for bottom nav (Home, Cart, Orders, Profile tabs).
- Deep link support for /product/:id and /order/:id.
- Error route (404 page) for unknown paths.

═══════════════════════════════════════════════
ANIMATIONS & TRANSITIONS
═══════════════════════════════════════════════

- Use flutter_animate package for: fade-in lists, slide-in cards,
  staggered product grid loading.
- Use Hero widgets for product image transition (product card → PDP).
- Cart badge: AnimatedSwitcher with bounce curve on count change.
- Add to cart: fly-to-cart animation using OverlayEntry.
- Page transitions: 
    - Standard push: FadeTransition (300ms)
    - Modal/bottom sheets: SlideTransition from bottom
    - Back navigation: fade out
- Shimmer loading on all lists (shimmer package).
- Lottie success animation on checkout complete.
- Wrap all animated widgets with:
    if (!kIsWeb) Animate(...) else plain widget
  for web performance safety.
- Respect accessibility: wrap all animations in:
    MediaQuery.of(context).disableAnimations ? plainWidget : animatedWidget

═══════════════════════════════════════════════
RESPONSIVE DESIGN
═══════════════════════════════════════════════

- Use LayoutBuilder + custom AppBreakpoints class.
- Product grid: 2 cols mobile, 3 cols tablet, 4 cols desktop.
- Navigation: BottomNavigationBar on mobile, 
  NavigationRail on tablet, NavigationDrawer on desktop.
- Never hardcode pixel widths — use MediaQuery or Flexible/Expanded.
- Test all screens at 360px, 768px, 1280px widths.

═══════════════════════════════════════════════
CODE QUALITY — NON-NEGOTIABLE
═══════════════════════════════════════════════

- All classes, methods, and public fields: full dartdoc comments.
- analysis_options.yaml: very_good_analysis rules.
- No unused imports — run dart fix --apply before committing.
- Use const constructors wherever possible.
- Equatable on all BLoC events and states.
- freezed for complex state unions (CheckoutState, ProductState).
- All async operations wrapped in try/catch → Either.
- No business logic in Widget build() methods.
- No direct context usage inside BLoC — pass values as events.

═══════════════════════════════════════════════
FILE NAMING CONVENTIONS
═══════════════════════════════════════════════

- Files: snake_case.dart
- Classes: PascalCase
- BLoC files: product_bloc.dart, product_event.dart, product_state.dart
- Page files: product_list_page.dart, product_detail_page.dart
- Widget files: product_card_widget.dart
- Use case files: get_products_usecase.dart
- Repository files: product_repository.dart (abstract), 
  product_repository_impl.dart (concrete)

═══════════════════════════════════════════════
FEATURES TO IMPLEMENT (in order)
═══════════════════════════════════════════════

Phase 1 — Foundation
  1. Project setup: packages, GetIt, Talker, theme, router, l10n
  2. Hive initialization and box registration
  3. Dio client with interceptors
  4. ConnectivityCubit + offline banner widget

Phase 2 — Auth
  5. AuthBloc (login, register, logout, token refresh)
  6. Login + Register pages with form validation
  7. AuthGuard in GoRouter

Phase 3 — Products
  8. Product entity, model, repository (abstract + impl)
  9. GetProducts, GetProductById, SearchProducts use cases
  10. ProductListBloc + ProductDetailBloc
  11. Home page: grid with shimmer, filter, search
  12. Product detail page: Hero image, gallery, add to cart button

Phase 4 — Cart & Wishlist
  13. Cart entity (Hive-persisted), CartBloc
  14. WishlistCubit (Hive-persisted)
  15. Cart page with swipe-to-delete, quantity stepper
  16. Fly-to-cart animation

Phase 5 — Checkout & Orders
  17. Stripe integration, CheckoutBloc
  18. Address form page
  19. Order entity, OrderBloc, order history page
  20. Order detail + status timeline
  21. Order success Lottie animation page

Phase 6 — Profile & Settings
  22. Profile page + edit profile
  23. SettingsPage: ThemeCubit toggle, LanguageCubit toggle
  24. Debug log route (TalkerScreen, kDebugMode only)

Phase 7 — Polish
  25. Onboarding (3 slides, shown once via SharedPreferences flag)
  26. Splash screen with animated logo
  27. Empty states for all lists
  28. Error states with retry button
  29. Pull-to-refresh on all lists
  30. README with demo screenshots and architecture section

═══════════════════════════════════════════════
ENV FILE (.env — never commit)
═══════════════════════════════════════════════

BASE_URL=https://fakestoreapi.com
STRIPE_PUBLISHABLE_KEY=pk_test_xxxxxxxxxxxxx
APP_ENV=development

═══════════════════════════════════════════════
MOCK API
═══════════════════════════════════════════════

Use https://fakestoreapi.com for products and auth during development.
Document the swap-to-real-backend process in README.
All API calls behind interfaces — swapping the datasource 
requires zero changes to domain or presentation layers.

═══════════════════════════════════════════════
README REQUIREMENTS
═══════════════════════════════════════════════

The README must be showcase-quality and include:
- Animated GIF demo (placeholder link until recorded)
- Architecture diagram image
- Features checklist with emoji checkmarks
- Tech stack table with version numbers
- Setup instructions (clone → .env → run)
- Stripe test cards table
- Design decisions section (why BLoC, why Hive, why offline-first)
- Contact/hire section linking to Mostaql and LinkedIn profiles

This is a portfolio project. Every file should demonstrate 
that you know what you're doing and why.
```

