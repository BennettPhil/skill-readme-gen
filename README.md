# readme-gen

Generate a well-structured README.md by analyzing a project directory. Detects language, build system, and project structure automatically.

## Prerequisites

- Bash 4+
- Standard Unix tools: `find`, `sort`, `wc`, `head`

## Installation

```bash
./scripts/install.sh
```

## Usage

```bash
# Generate a README for a project
./scripts/run.sh /path/to/project > README.md

# Detect just the language
./scripts/detect-lang.sh /path/to/project

# Detect just the build system
./scripts/detect-build.sh /path/to/project

# Override the project name
README_PROJECT_NAME="My App" ./scripts/run.sh /path/to/project
```

## Pipeline Examples

```bash
# Use individual scripts in a pipeline
lang=$(./scripts/detect-lang.sh /path/to/project)
build=$(./scripts/detect-build.sh /path/to/project)
structure=$(./scripts/detect-structure.sh /path/to/project)
echo "$structure" | ./scripts/generate.sh "my-project" "$lang" "$build"
```

## Testing

```bash
./scripts/test.sh
```
