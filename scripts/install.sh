#!/usr/bin/env bash
set -euo pipefail

ERRORS=0

check_cmd() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "  [ok] $1"
  else
    echo "  [missing] $1 — $2"
    ((ERRORS++))
  fi
}

echo "Checking dependencies for readme-gen..."
check_cmd "bash" "Required (shell)"
check_cmd "find" "Required (file search)"
check_cmd "wc" "Required (counting)"
check_cmd "sort" "Required (sorting)"
check_cmd "head" "Required (truncating)"

if [ "$ERRORS" -gt 0 ]; then
  echo ""
  echo "$ERRORS missing dependencies. Install them and re-run."
  exit 1
fi

echo ""
echo "All dependencies satisfied."
