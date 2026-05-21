#!/usr/bin/env bash
set -euo pipefail

# â”€â”€â”€ Debug / Development Build Script â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
# Runs a debug build while forwarding environment variables as --dart-define.
#
# Usage (from project root OR scripts/ folder):
#   ./scripts/build_debug.sh                       â†’ flutter run (debug)
#   ./scripts/build_debug.sh -d <device-id>        â†’ run on specific device
#   ./scripts/build_debug.sh --release              â†’ release mode
#   ./scripts/build_debug.sh --profile              â†’ profile mode
#   ./scripts/build_debug.sh -d chrome              â†’ run on Chrome
#   ./scripts/build_debug.sh clean                  â†’ flutter clean + pub get
#   ./scripts/build_debug.sh gen                    â†’ build_runner codegen
#   ./scripts/build_debug.sh l10n                   â†’ generate localisation
#   ./scripts/build_debug.sh test                   â†’ run all tests
#
# Env vars (loaded from .env if present):
#   API_BASE_URL
#   API_VERSION
#   GOOGLE_SERVER_CLIENT_ID
#   GOOGLE_CLIENT_SECRET
# â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}/.."

# â”€â”€ Handle utility sub-commands that don't need env vars â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
case "${1:-}" in
  clean)
    echo "ðŸ§¹ Cleaning project..."
    flutter clean
    echo "ðŸ“¦ Fetching dependencies..."
    flutter pub get
    echo "âœ… Clean complete â€” ready to build"
    exit 0
    ;;
  gen)
    echo "âš™ï¸  Running build_runner code generation..."
    dart run build_runner build --delete-conflicting-outputs
    echo "âœ… Code generation complete"
    exit 0
    ;;
  l10n)
    echo "ðŸŒ Generating localisation files..."
    flutter gen-l10n
    echo "âœ… Localisation files generated"
    exit 0
    ;;
  test)
    echo "ðŸ§ª Running tests..."
    flutter test
    exit 0
    ;;
esac

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
echo "ðŸš€ Running: flutter run $* ${DEFINES[*]:-}"
echo "   API_BASE_URL = ${API_BASE_URL:-<not set>}"
echo "   API_VERSION  = ${API_VERSION:-<not set>}"
echo "   GOOGLE_AUTH  = ${GOOGLE_SERVER_CLIENT_ID:+set}${GOOGLE_SERVER_CLIENT_ID:-<not set>}"
echo ""

flutter run "$@" ${DEFINES[@]+"${DEFINES[@]}"}

