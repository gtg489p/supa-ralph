#!/usr/bin/env bash
set -euo pipefail
TARGET=${1:?usage: install-into-project.sh /path/to/project}
TARGET=$(cd "$TARGET" && pwd)
KIT="$TARGET/.supa-ralph"
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd -- "$SCRIPT_DIR/.." && pwd)

command -v git >/dev/null 2>&1 || { echo "git is required" >&2; exit 1; }
command -v claude >/dev/null 2>&1 || { echo "claude CLI is required" >&2; exit 1; }

copy_tree() {
  local src=$1
  local dst=$2
  rm -rf "$dst"
  cp -R "$src" "$dst"
}

copy_if_missing() {
  local src=$1
  local dst=$2
  if [[ ! -e "$dst" ]]; then
    cp "$src" "$dst"
  fi
}

link_skill() {
  local name=$1
  local target=$2
  local link="$TARGET/.claude/skills/$name"
  if [[ -L "$link" ]] && [[ "$(readlink -f "$link")" == "$(readlink -f "$target")" ]]; then
    return 0
  fi
  if [[ -e "$link" ]]; then
    echo "warning: not replacing existing skill path $link" >&2
    return 0
  fi
  ln -s "$target" "$link"
}

mkdir -p "$KIT" "$TARGET/tasks" "$TARGET/specs" "$TARGET/.claude/skills"
: > "$TARGET/tasks/.gitkeep"
: > "$TARGET/specs/.gitkeep"

copy_tree "$REPO_ROOT/prompts" "$KIT/prompts"
copy_tree "$REPO_ROOT/scripts" "$KIT/scripts"
copy_tree "$REPO_ROOT/skills" "$KIT/skills"
copy_tree "$REPO_ROOT/templates" "$KIT/templates"
copy_tree "$REPO_ROOT/docs" "$KIT/docs"
cp "$REPO_ROOT/README.md" "$KIT/README.md"
cp "$REPO_ROOT/NOTICE.md" "$KIT/NOTICE.md"
cp "$REPO_ROOT/LICENSE" "$KIT/LICENSE"
rm -f "$KIT/prd.json.example"

copy_if_missing "$REPO_ROOT/templates/AGENTS.md" "$KIT/AGENTS.md"
copy_if_missing "$REPO_ROOT/templates/IMPLEMENTATION_PLAN.md" "$KIT/IMPLEMENTATION_PLAN.md"
copy_if_missing "$REPO_ROOT/templates/progress.txt" "$KIT/progress.txt"
copy_if_missing "$REPO_ROOT/templates/PRD_TEMPLATE.md" "$KIT/PRD_TEMPLATE.md"

chmod +x "$KIT/scripts/ralph.sh" "$KIT/scripts/install-into-project.sh"
link_skill supa-prd "$KIT/skills/prd"
link_skill supa-ralph "$KIT/skills/ralph"

printf 'Installed Supa Ralph into %s\n' "$KIT"
printf 'Claude skills linked under %s\n' "$TARGET/.claude/skills"
