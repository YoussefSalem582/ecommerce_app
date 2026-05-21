# ADR 005: JWT refresh showcase stub

**Status:** Accepted  
**Date:** 2026-05-21

## Context

Production apps refresh access tokens on HTTP 401 via `TokenRefreshInterceptor`. Fake Store API does not expose a refresh endpoint.

## Decision

Implement the **full refresh pipeline** (interceptor, `RefreshTokenUseCase`, secure storage rotation) but use **showcase rotation** in demo mode and throw `UnsupportedError` when `APP_ENV=live` against Fake Store.

## Consequences

- Code reviewers see retry-on-401 behavior in Talker logs during demo sessions.
- Live Fake Store mode cannot refresh — users re-login on expiry (acceptable for API sandbox).
- Custom backend: implement `AuthRemoteDatasource.refreshAccessToken` with your `/auth/refresh` contract.

## Swap checklist

1. Add refresh endpoint to your backend OpenAPI/spec.
2. Map response in `remote_auth_datasource.dart`.
3. Document token TTL in `08_security_and_environment.md`.
4. Add integration test hitting forced 401 → refresh → retry.
