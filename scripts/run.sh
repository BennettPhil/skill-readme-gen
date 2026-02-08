#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
  echo "Usage: run.sh <project-dir>"
  echo ""
  echo "Analyze a project directory and generate a README.md."
  echo "Output is printed to stdout."
  echo ""
  echo "Environment variables:"
  echo "  README_PROJECT_NAME  Override auto-detected project name"
  echo "  README_MAX_DEPTH     Max directory tree depth (default: 3)"
  exit 0
fi

PROJECT_DIR="${1:?Error: project directory path required}"

if [ ! -d "$PROJECT_DIR" ]; then
  echo "Error: directory not found: $PROJECT_DIR" >&2
  exit 1
fi

# Auto-detect project name or use override
PROJECT_NAME="${README_PROJECT_NAME:-$(basename "$PROJECT_DIR")}"

# Run detection scripts
LANGUAGE=$("$SCRIPT_DIR/detect-lang.sh" "$PROJECT_DIR")
BUILD_SYSTEM=$("$SCRIPT_DIR/detect-build.sh" "$PROJECT_DIR")
STRUCTURE=$("$SCRIPT_DIR/detect-structure.sh" "$PROJECT_DIR")

# Generate README
echo "$STRUCTURE" | "$SCRIPT_DIR/generate.sh" "$PROJECT_NAME" "$LANGUAGE" "$BUILD_SYSTEM"
