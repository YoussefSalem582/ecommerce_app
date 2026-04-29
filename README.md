# ShopFlow

Production-grade Flutter e-commerce showcase (Clean Architecture, BLoC, Hive, Stripe, Talker). See `ShopFlow_Flutter_Plan_and_Cursor_Prompt.md` for the full architecture and roadmap.

## Run

1. Install packages:

   ```bash
   flutter pub get
   ```

2. Default API and env keys load from `assets/env/default.env`. For local overrides, add an untracked env file and load it from `main.dart` instead — never commit real Stripe keys.

3. Regenerate DI after changing `@injectable` classes:

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Run the app:

   ```bash
   flutter run
   ```

## Auth and network troubleshooting

- **Protected routes** (`/home`, cart, etc.) require **`AuthAuthenticated`**, which only happens after **`POST /auth/login`** (or demo mode below) returns a token. Until then, GoRouter keeps you on **`/login`** or **`/register`**.
- **“Connection reset by peer”** during login is usually **not** a Flutter/Dio-only bug. Verify from your **PC** (same machine as the emulator):

  ```bash
  curl -X POST "https://fakestoreapi.com/auth/login" ^
    -H "Content-Type: application/json" ^
    --data-raw "{\"username\":\"mor_2314\",\"password\":\"83r5^_\"}"
  ```

  If **curl** also resets or fails, fix **VPN, firewall, antivirus HTTPS scanning**, or try another network before chasing app code.
- Many emulator images **do not ship `curl`**. Use the host command above, or try a **physical device** / **API 34** system image if previews misbehave.

### Demo auth (`APP_ENV=demo`)

When **`fakestoreapi.com` is unreachable**, set in your env file:

```env
APP_ENV=demo
```

Then **login** and **register** use **`FakeAuthRemoteDatasource`** (no HTTP): you can pass auth screens for UI demos. **Catalog and cart APIs still call `BASE_URL`** unless cached offline.

## Tests

Widget tests mock `SharedPreferences` and use a temporary Hive directory.

```bash
flutter test
```
