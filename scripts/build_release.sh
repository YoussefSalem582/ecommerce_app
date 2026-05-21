#!/usr/bin/env bash
set -euo pipefail

# â”€â”€â”€ Secure Release Build Script â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
# Obfuscated release build with env vars passed as --dart-define.
#
# Usage (from project root OR scripts/ folder):
#   ./scripts/build_release.sh apk          â†’ Build release APK
#   ./scripts/build_release.sh appbundle     â†’ Build release App Bundle (Play Store)
#   ./scripts/build_release.sh ios           â†’ Build release iOS
#   ./scripts/build_release.sh apk --flavor prod -t lib/main_prod.dart
#
# All extra flags after the platform are forwarded to flutter build.
#
# Env vars (loaded from .env if present):
#   API_BASE_URL
#   API_VERSION
#   GOOGLE_SERVER_CLIENT_ID
#   GOOGLE_CLIENT_SECRET
# â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}/.."

PLATFORM="${1:-apk}"
shift || true   # remove platform arg; remaining "$@" forwarded to flutter

SYMBOLS_DIR="build/symbols"
mkdir -p "$SYMBOLS_DIR"

# â”€â”€ Load .env (only exports vars not already set) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
if [[ -f ".env" ]]; then
  while IFS='=' read -r key value; do
    [[ -z "${key}" ]] && continue
    [[ "${key}" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${value}" ]] && continue
    if [[ -z "${!key:-}" ]]; then
      export "${key}=${value}"
    fi
  done < .env
else
  echo "âš ï¸  .env file not found â€” using environment variables or defaults."
fi

# â”€â”€ Build --dart-define list â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
DEFINES=()

if [[ -n "${API_BASE_URL:-}" ]]; then DEFINES+=("--dart-define=API_BASE_URL=${API_BASE_URL}"); fi
if [[ -n "${API_VERSION:-}" ]]; then DEFINES+=("--dart-define=API_VERSION=${API_VERSION}"); fi
if [[ -n "${GOOGLE_SERVER_CLIENT_ID:-}" ]]; then DEFINES+=("--dart-define=GOOGLE_SERVER_CLIENT_ID=${GOOGLE_SERVER_CLIENT_ID}"); fi
if [[ -n "${GOOGLE_CLIENT_SECRET:-}" ]]; then DEFINES+=("--dart-define=GOOGLE_CLIENT_SECRET=${GOOGLE_CLIENT_SECRET}"); fi
if [[ -n "${SENTRY_DSN:-}" ]]; then DEFINES+=("--dart-define=SENTRY_DSN=${SENTRY_DSN}"); fi

# â”€â”€ Summary â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
echo "ðŸ”’ Building SECURE release ($PLATFORM) with obfuscation..."
echo "   API_BASE_URL = ${API_BASE_URL:-<not set>}"
echo "   API_VERSION  = ${API_VERSION:-<not set>}"
echo "   GOOGLE_AUTH  = ${GOOGLE_SERVER_CLIENT_ID:+set}${GOOGLE_SERVER_CLIENT_ID:-<not set>}"
echo ""

case "$PLATFORM" in
  apk)
    flutter build apk --release \
      --obfuscate \
      --split-debug-info="$SYMBOLS_DIR" \
      "${DEFINES[@]}" "$@"
    echo "âœ… APK ready at build/app/outputs/flutter-apk/app-release.apk"
    ;;
  appbundle)
    flutter build appbundle --release \
      --obfuscate \
      --split-debug-info="$SYMBOLS_DIR" \
      "${DEFINES[@]}" "$@"
    echo "âœ… App Bundle ready at build/app/outputs/bundle/release/app-release.aab"
    ;;
  ios)
    flutter build ios --release \
      --obfuscate \
      --split-debug-info="$SYMBOLS_DIR" \
      "${DEFINES[@]}" "$@"
    echo "âœ… iOS build ready"
    ;;
  *)
    echo "âŒ Unknown platform: $PLATFORM"
    echo "   Usage: ./scripts/build_release.sh [apk|appbundle|ios] [extra flutter flags...]"
    exit 1
    ;;
esac

echo "ðŸ“¦ Debug symbols saved to $SYMBOLS_DIR (keep for crash reports)"

