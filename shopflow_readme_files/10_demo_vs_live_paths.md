# Demo vs live paths

ShopFlow defaults to **demo/showcase mode** so freelancers can run the app without secrets. Set environment variables to exercise live Fake Store HTTP, Google Sign-In, or Stripe Payment Sheet.

## Environment matrix

| Variable | Default (demo) | Live / configured behavior |
|----------|----------------|----------------------------|
| `APP_ENV` | unset, `demo`, or `development` → in-memory fake auth & catalog | `live` or `production` → Fake Store HTTP via Dio |
| `STRIPE_PUBLISHABLE_KEY` | empty → local demo checkout (no Payment Sheet) | non-empty → Stripe Payment Sheet in checkout |
| `STRIPE_PAYMENT_INTENT_CLIENT_SECRET` | empty | required with publishable key for Payment Sheet |
| Google Sign-In | showcase stub (`ShowcaseGoogleAuthDatasource`) | real `GoogleAuthDatasource` when platform OAuth is configured |

Sources: [`lib/core/config/app_config.dart`](../lib/core/config/app_config.dart), [`lib/core/di/register_module.dart`](../lib/core/di/register_module.dart).

## Demo mode (default)

- **Auth / catalog**: `FakeAuthRemoteDatasource`, `FakeProductsRemoteDatasource` — no network.
- **Checkout**: saves orders to Hive; shows demo banner when Stripe is not configured.
- **Google button**: instant showcase sign-in stub.

Run with committed defaults:

```powershell
flutter run
```

## Live Fake Store HTTP

Create optional `.env` at repo root (gitignored) or edit `assets/env/default.env` for local testing:

```env
APP_ENV=live
BASE_URL=https://fakestoreapi.com
```

Then:

```powershell
flutter run
```

## Stripe Payment Sheet

Add to `.env`:

```env
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_PAYMENT_INTENT_CLIENT_SECRET=pi_..._secret_...
```

Checkout opens Payment Sheet when both keys are present. See [`lib/features/checkout/data/stripe_checkout_gateway.dart`](../lib/features/checkout/data/stripe_checkout_gateway.dart).

## Integration tests

| Test file | When to run |
|-----------|-------------|
| `integration_test/checkout_flow_test.dart` | Always — demo checkout path |
| `integration_test/auth_flow_test.dart` | Branches on Google vs email login |
| `integration_test/stripe_checkout_test.dart` | Only when Stripe keys are set (`@Tags(['stripe'])`) |

Demo path (widget + integration tests):

```powershell
flutter test
```

Stripe-tagged test (requires device + secrets):

```powershell
flutter test integration_test/stripe_checkout_test.dart --tags stripe
```

Full integration on device:

```powershell
flutter test integration_test
```

## Settings screen

In **debug/profile builds**, Settings shows read-only environment row: `APP_ENV` label and whether Stripe is configured — useful when narrating demos.

## Related docs

- [`08_security_and_environment.md`](08_security_and_environment.md)
- [`09_api_endpoints.md`](09_api_endpoints.md)
- [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md)
