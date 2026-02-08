#!/usr/bin/env bash
set -euo pipefail

if [ "${1:-}" = "--help" ]; then
  echo "Usage: generate.sh <project-name> <language> <build-system>"
  echo "Reads directory structure from stdin and outputs README markdown to stdout."
  exit 0
fi

PROJECT_NAME="${1:?Error: project name required}"
LANGUAGE="${2:?Error: language required}"
BUILD_SYSTEM="${3:?Error: build system required}"

# Read structure from stdin
STRUCTURE=$(cat)

# Build install instructions based on build system
install_cmd() {
  case "$1" in
    npm) echo "npm install" ;;
    cargo) echo "cargo build" ;;
    go-mod) echo "go build ./..." ;;
    pip) echo "pip install -r requirements.txt" ;;
    bundler) echo "bundle install" ;;
    maven) echo "mvn install" ;;
    gradle) echo "gradle build" ;;
    cmake) echo "mkdir build && cd build && cmake .. && make" ;;
    make) echo "make" ;;
    composer) echo "composer install" ;;
    *) echo "# See project documentation" ;;
  esac
}

run_cmd() {
  case "$1" in
    npm) echo "npm start" ;;
    cargo) echo "cargo run" ;;
    go-mod) echo "go run ." ;;
    pip) echo "python main.py" ;;
    bundler) echo "bundle exec ruby main.rb" ;;
    maven) echo "mvn exec:java" ;;
    gradle) echo "gradle run" ;;
    make) echo "make run" ;;
    *) echo "# See project documentation" ;;
  esac
}

INSTALL=$(install_cmd "$BUILD_SYSTEM")
RUN=$(run_cmd "$BUILD_SYSTEM")

cat << READMEEOF
# ${PROJECT_NAME}

> A ${LANGUAGE} project using ${BUILD_SYSTEM}.

## Getting Started

### Prerequisites

- ${LANGUAGE} runtime installed

### Installation

\`\`\`bash
git clone <repository-url>
cd ${PROJECT_NAME}
${INSTALL}
\`\`\`

### Usage

\`\`\`bash
${RUN}
\`\`\`

## Project Structure

\`\`\`
${STRUCTURE}
\`\`\`

## License

See LICENSE file for details.
READMEEOF
