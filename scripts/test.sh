#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PASS=0
FAIL=0

pass() { ((PASS++)); echo "  PASS: $1"; }
fail() { ((FAIL++)); echo "  FAIL: $1 -- $2"; }

assert_eq() {
  local desc="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then pass "$desc"
  else fail "$desc" "expected '$expected', got '$actual'"; fi
}

assert_contains() {
  local desc="$1" needle="$2" haystack="$3"
  if echo "$haystack" | grep -qF "$needle"; then pass "$desc"
  else fail "$desc" "output does not contain '$needle'"; fi
}

assert_exit_code() {
  local desc="$1" expected_code="$2"
  shift 2
  local actual_code=0
  "$@" >/dev/null 2>&1 || actual_code=$?
  if [ "$expected_code" -eq "$actual_code" ]; then pass "$desc"
  else fail "$desc" "expected exit $expected_code, got $actual_code"; fi
}

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

# Create a sample Python project
mkdir -p "$TMP_DIR/myproject/src"
echo 'print("hello")' > "$TMP_DIR/myproject/src/main.py"
echo 'import os' > "$TMP_DIR/myproject/src/utils.py"
echo 'flask==2.0' > "$TMP_DIR/myproject/requirements.txt"

# Create a sample Node project
mkdir -p "$TMP_DIR/nodeapp/src"
echo 'console.log("hi")' > "$TMP_DIR/nodeapp/src/index.js"
echo '{"name":"nodeapp"}' > "$TMP_DIR/nodeapp/package.json"

# Make scripts executable
chmod +x "$SCRIPT_DIR"/*.sh

echo "Running tests for: readme-gen"
echo "================================"

echo ""
echo "detect-lang.sh:"
output=$("$SCRIPT_DIR/detect-lang.sh" "$TMP_DIR/myproject" 2>&1)
assert_eq "detects Python from .py files" "python" "$output"

output=$("$SCRIPT_DIR/detect-lang.sh" "$TMP_DIR/nodeapp" 2>&1)
assert_eq "detects JavaScript from .js files" "javascript" "$output"

echo ""
echo "detect-build.sh:"
output=$("$SCRIPT_DIR/detect-build.sh" "$TMP_DIR/myproject" 2>&1)
assert_eq "detects pip from requirements.txt" "pip" "$output"

output=$("$SCRIPT_DIR/detect-build.sh" "$TMP_DIR/nodeapp" 2>&1)
assert_eq "detects npm from package.json" "npm" "$output"

echo ""
echo "detect-structure.sh:"
output=$("$SCRIPT_DIR/detect-structure.sh" "$TMP_DIR/myproject" 2>&1)
assert_contains "shows src directory" "src/" "$output"
assert_contains "shows main.py" "main.py" "$output"

echo ""
echo "run.sh (full pipeline):"
output=$("$SCRIPT_DIR/run.sh" "$TMP_DIR/myproject" 2>&1)
assert_contains "README has project name" "myproject" "$output"
assert_contains "README has language" "python" "$output"
assert_contains "README has build system" "pip" "$output"
assert_contains "README has install cmd" "pip install" "$output"
assert_contains "README has structure" "src/" "$output"

echo ""
echo "Error handling:"
assert_exit_code "fails with no args" 1 "$SCRIPT_DIR/run.sh"
assert_exit_code "fails with missing dir" 1 "$SCRIPT_DIR/run.sh" "$TMP_DIR/nonexistent"
assert_exit_code "detect-lang --help exits 0" 0 "$SCRIPT_DIR/detect-lang.sh" "--help"

echo ""
echo "================================"
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] || exit 1
