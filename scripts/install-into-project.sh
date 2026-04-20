#!/usr/bin/env bash
set -euo pipefail
TARGET=${1:?usage: install-into-project.sh /path/to/project}
TARGET=$(cd "$TARGET" && pwd)
KIT="$TARGET/.supa-ralph"
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd -- "$SCRIPT_DIR/.." && pwd)
mkdir -p "$KIT"
mkdir -p "$TARGET/tasks" "$TARGET/specs"
rm -rf "$KIT/prompts" "$KIT/scripts" "$KIT/skills" "$KIT/templates"
cp -R "$REPO_ROOT/prompts" "$KIT/"
cp -R "$REPO_ROOT/scripts" "$KIT/"
cp -R "$REPO_ROOT/skills" "$KIT/"
cp -R "$REPO_ROOT/templates" "$KIT/"
cp "$REPO_ROOT/templates/AGENTS.md" "$KIT/AGENTS.md"
cp "$REPO_ROOT/templates/IMPLEMENTATION_PLAN.md" "$KIT/IMPLEMENTATION_PLAN.md"
cp "$REPO_ROOT/templates/progress.txt" "$KIT/progress.txt"
cp "$REPO_ROOT/templates/prd.json.example" "$KIT/prd.json.example"
chmod +x "$KIT/scripts/ralph.sh"
printf 'Installed Supa Ralph into %s\n' "$KIT"
