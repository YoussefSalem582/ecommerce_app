# API Endpoints (Fake Store / live HTTP)

Base URL: `AppConfig.apiBaseUrl` — default `https://fakestoreapi.com` from `BASE_URL` in env.

Paths are defined in feature **remote datasources** (not a central constants file). When `APP_ENV` is demo/development, **fake** datasources run instead (no HTTP).

## Auth (`RemoteAuthDatasource`)

| Method | Path | Purpose |
|--------|------|---------|
| POST | `/auth/login` | Email/password login |
| POST | `/users` | Register new user |

Implementation: `lib/features/auth/data/datasources/remote_auth_datasource.dart`

## Products (`RemoteProductsDatasource`)

| Method | Path | Purpose |
|--------|------|---------|
| GET | `/products` | Full catalog |
| GET | `/products/category/{category}` | Filter by category (URL-encoded) |
| GET | `/products/{id}` | Single product |
| GET | `/products/categories` | Category list |

Implementation: `lib/features/products/data/datasources/remote_products_datasource.dart`

## Local-only (no Fake Store HTTP)

| Feature | Storage |
|---------|---------|
| Cart | Hive / local datasource |
| Wishlist | Local |
| Orders | Local journal |
| Profile avatar | Local path + preferences |
| Checkout (demo) | Local + optional Stripe |

## Response format

Fake Store returns **raw JSON** (arrays or objects). There is no `{ success, data }` wrapper — parse directly in `*_model.fromJson`.

## Adding endpoints

See [04_how_to_add_new_api.md](04_how_to_add_new_api.md) and skill [`add-api`](../.agents/skills/add-api/SKILL.md).
