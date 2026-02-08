#!/usr/bin/env bash
set -euo pipefail

if [ "${1:-}" = "--help" ]; then
  echo "Usage: detect-structure.sh <project-dir>"
  echo "Outputs a directory tree of the project (excluding hidden dirs, node_modules, etc)."
  exit 0
fi

PROJECT_DIR="${1:?Error: project directory required}"
MAX_DEPTH="${README_MAX_DEPTH:-3}"

if [ ! -d "$PROJECT_DIR" ]; then
  echo "Error: directory not found: $PROJECT_DIR" >&2
  exit 1
fi

# Use find to build a simple tree
find "$PROJECT_DIR" \
  -maxdepth "$MAX_DEPTH" \
  -not -path '*/\.*' \
  -not -path '*/node_modules/*' \
  -not -path '*/vendor/*' \
  -not -path '*/__pycache__/*' \
  -not -path '*/target/*' \
  -not -path '*/dist/*' \
  -not -path '*/build/*' | \
  sort | \
  while IFS= read -r path; do
    # Calculate relative path and depth
    rel="${path#"$PROJECT_DIR"}"
    if [ -z "$rel" ]; then
      basename "$PROJECT_DIR"
      continue
    fi
    rel="${rel#/}"
    depth=$(echo "$rel" | tr -cd '/' | wc -c | tr -d ' ')
    indent=""
    for ((i = 0; i < depth; i++)); do
      indent="$indent  "
    done
    name=$(basename "$path")
    if [ -d "$path" ]; then
      echo "${indent}${name}/"
    else
      echo "${indent}${name}"
    fi
  done
