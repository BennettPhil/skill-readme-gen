#!/usr/bin/env bash
set -euo pipefail

if [ "${1:-}" = "--help" ]; then
  echo "Usage: detect-lang.sh <project-dir>"
  echo "Detects the primary programming language by file extension frequency."
  exit 0
fi

PROJECT_DIR="${1:?Error: project directory required}"

if [ ! -d "$PROJECT_DIR" ]; then
  echo "Error: directory not found: $PROJECT_DIR" >&2
  exit 1
fi

# Count files by extension, ignoring hidden dirs and common non-source dirs
EXT_LIST=$(find "$PROJECT_DIR" \
  -not -path '*/\.*' \
  -not -path '*/node_modules/*' \
  -not -path '*/vendor/*' \
  -not -path '*/__pycache__/*' \
  -not -path '*/target/*' \
  -not -path '*/dist/*' \
  -not -path '*/build/*' \
  -type f -name '*.*' 2>/dev/null | \
  sed 's/.*\.//' | \
  sort | uniq -c | sort -rn || true)

map_ext() {
  case "$1" in
    py) echo "python" ;;
    js|jsx|mjs) echo "javascript" ;;
    ts|tsx) echo "typescript" ;;
    go) echo "go" ;;
    rs) echo "rust" ;;
    java) echo "java" ;;
    rb) echo "ruby" ;;
    php) echo "php" ;;
    c|h) echo "c" ;;
    cpp|cc|cxx|hpp) echo "cpp" ;;
    cs) echo "csharp" ;;
    swift) echo "swift" ;;
    kt) echo "kotlin" ;;
    sh|bash) echo "shell" ;;
    *) echo "" ;;
  esac
}

while read -r count ext; do
  [ -z "$ext" ] && continue
  lang=$(map_ext "$ext")
  if [ -n "$lang" ]; then
    echo "$lang"
    exit 0
  fi
done <<< "$EXT_LIST"

echo "unknown"
