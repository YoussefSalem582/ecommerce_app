# ADR 006: Stripe PaymentIntent workflow

**Status:** Accepted  
**Date:** 2026-05-21

## Context

`flutter_stripe` Payment Sheet requires a **client secret** from a server-created PaymentIntent. Client-side secret creation is forbidden by Stripe.

## Decision

- **Demo path (default):** `CheckoutBloc` persists orders locally when Stripe keys are absent.
- **Live Payment Sheet:** Enable when both `STRIPE_PUBLISHABLE_KEY` and `STRIPE_PAYMENT_INTENT_CLIENT_SECRET` are set in env.
- Document **Stripe CLI** workflow for local testing; defer embedded backend to consumer projects.

## Consequences

- Portfolio reviewers run checkout without Stripe account setup.
- Real payments need a small backend (Node, Firebase Function, etc.) that creates PaymentIntents with the secret key server-side.

## Local testing (Stripe CLI)

```bash
stripe payment_intents create --amount=2000 --currency=usd
```

Set the returned `client_secret` in `.env` as `STRIPE_PAYMENT_INTENT_CLIENT_SECRET`.

## Production backend sketch

```
POST /checkout/payment-intent
Authorization: Bearer <user JWT>
Body: { "amountCents": 2000, "currency": "usd" }
Response: { "clientSecret": "pi_xxx_secret_xxx" }
```

Wire `CheckoutBloc` to fetch the secret from your API instead of reading it from env.
