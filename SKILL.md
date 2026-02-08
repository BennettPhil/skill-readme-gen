---
name: readme-gen
description: Generate a well-structured README.md by analyzing a project directory's codebase, detecting language, build system, and structure.
version: 0.1.0
license: Apache-2.0
---

# README Generator

## Purpose

Analyzes a project directory to automatically generate a well-structured README.md. The tool detects the primary programming language, build system, project structure, and creates sections for installation, usage, project layout, and license. Each detection step is a composable script that can be used independently.

## Scripts Overview

| Script | Description |
|--------|-------------|
| `scripts/run.sh` | Main entry point — orchestrates detection and generation |
| `scripts/detect-lang.sh` | Detects primary programming language from file extensions |
| `scripts/detect-build.sh` | Detects build system from config files |
| `scripts/detect-structure.sh` | Maps the project directory structure |
| `scripts/generate.sh` | Assembles README sections from detection results |
| `scripts/install.sh` | Checks for required dependencies |
| `scripts/test.sh` | Validates all scripts with sample projects |

## Pipeline Examples

```bash
# Full generation
./scripts/run.sh /path/to/project > README.md

# Individual detection
./scripts/detect-lang.sh /path/to/project      # outputs: "python"
./scripts/detect-build.sh /path/to/project      # outputs: "npm"
./scripts/detect-structure.sh /path/to/project   # outputs directory tree

# Compose detections into custom output
lang=$(./scripts/detect-lang.sh /path/to/project)
build=$(./scripts/detect-build.sh /path/to/project)
echo "Project: $lang with $build"
```

## Inputs and Outputs

All scripts accept a project directory path as the first positional argument.

- `detect-lang.sh`: Outputs the detected language name to stdout (e.g., `python`, `javascript`, `go`, `rust`, `java`).
- `detect-build.sh`: Outputs the detected build system to stdout (e.g., `npm`, `pip`, `cargo`, `make`, `gradle`).
- `detect-structure.sh`: Outputs a directory tree to stdout.
- `generate.sh`: Reads language, build, and structure from stdin (JSON) and outputs Markdown to stdout.
- `run.sh`: Outputs a complete README.md to stdout.

## Environment Variables

- `README_PROJECT_NAME` — Override auto-detected project name.
- `README_MAX_DEPTH` — Maximum directory tree depth (default: 3).
