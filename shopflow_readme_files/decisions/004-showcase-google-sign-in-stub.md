# ADR 004: Showcase Google Sign-In stub

**Status:** Accepted  
**Date:** 2026-05-21

## Context

The portfolio spec calls for Google Sign-In. A production implementation requires platform OAuth client IDs (Android SHA-1, iOS URL schemes, Web client ID) and a backend token exchange endpoint.

## Decision

Ship a **showcase stub** via `ShowcaseGoogleAuthDatasource` that returns a fixed demo user and JWT pair without the `google_sign_in` package. The UI (`GoogleSignInButton`) and use case pipeline mirror production wiring.

## Consequences

- Reviewers can tap Google Sign-In and reach the authenticated shell instantly.
- No Firebase/Google Cloud Console setup required for clone-and-run.
- To go production: add `google_sign_in`, configure platform OAuth, implement `GoogleAuthDatasource` with real ID token → backend exchange, register in `RegisterModule`.

## Swap checklist

1. Add `google_sign_in` to `pubspec.yaml`.
2. Implement `RemoteGoogleAuthDatasource` (or extend auth remote datasource).
3. Register live implementation when `AppConfig.isDemoEnv == false`.
4. Remove or gate showcase datasource behind `kDebugMode` only if desired.
