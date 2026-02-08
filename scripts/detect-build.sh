#!/usr/bin/env bash
set -euo pipefail

if [ "${1:-}" = "--help" ]; then
  echo "Usage: detect-build.sh <project-dir>"
  echo "Detects the build system from config files in the project root."
  exit 0
fi

PROJECT_DIR="${1:?Error: project directory required}"

if [ ! -d "$PROJECT_DIR" ]; then
  echo "Error: directory not found: $PROJECT_DIR" >&2
  exit 1
fi

# Check for build system config files in priority order
if [ -f "$PROJECT_DIR/package.json" ]; then
  echo "npm"
elif [ -f "$PROJECT_DIR/Cargo.toml" ]; then
  echo "cargo"
elif [ -f "$PROJECT_DIR/go.mod" ]; then
  echo "go-mod"
elif [ -f "$PROJECT_DIR/setup.py" ] || [ -f "$PROJECT_DIR/pyproject.toml" ]; then
  echo "pip"
elif [ -f "$PROJECT_DIR/requirements.txt" ]; then
  echo "pip"
elif [ -f "$PROJECT_DIR/Gemfile" ]; then
  echo "bundler"
elif [ -f "$PROJECT_DIR/pom.xml" ]; then
  echo "maven"
elif [ -f "$PROJECT_DIR/build.gradle" ] || [ -f "$PROJECT_DIR/build.gradle.kts" ]; then
  echo "gradle"
elif [ -f "$PROJECT_DIR/CMakeLists.txt" ]; then
  echo "cmake"
elif [ -f "$PROJECT_DIR/Makefile" ]; then
  echo "make"
elif [ -f "$PROJECT_DIR/composer.json" ]; then
  echo "composer"
else
  echo "none"
fi
