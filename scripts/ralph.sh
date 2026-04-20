#!/usr/bin/env bash
set -euo pipefail
MODE=${1:-build}
MAX_ITERATIONS=${2:-0}
if [[ "$MODE" != "plan" && "$MODE" != "build" ]]; then
  echo "usage: .supa-ralph/scripts/ralph.sh [plan|build] [max_iterations]"
  exit 2
fi
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
RALPH_HOME="$PROJECT_ROOT/.supa-ralph"
PROMPT_FILE="$RALPH_HOME/prompts/CLAUDE_${MODE^^}.md"
LOG_FILE="$RALPH_HOME/${MODE}-loop.log"
ITERATION=0
if [[ ! -f "$PROMPT_FILE" ]]; then
  echo "missing prompt: $PROMPT_FILE"
  exit 1
fi
if ! command -v claude >/dev/null 2>&1; then
  echo "claude CLI not found"
  exit 1
fi
cd "$PROJECT_ROOT"
echo "mode=$MODE project=$PROJECT_ROOT" | tee -a "$LOG_FILE"
while true; do
  if [[ "$MAX_ITERATIONS" != "0" && "$ITERATION" -ge "$MAX_ITERATIONS" ]]; then
    echo "Reached max iterations: $MAX_ITERATIONS" | tee -a "$LOG_FILE"
    break
  fi
  ITERATION=$((ITERATION + 1))
  echo "===== SUPA RALPH $MODE iteration $ITERATION =====" | tee -a "$LOG_FILE"
  OUTPUT=$(claude --dangerously-skip-permissions --print "$(cat "$PROMPT_FILE")" 2>&1 | tee -a "$LOG_FILE") || true
  if echo "$OUTPUT" | grep -q '<promise>COMPLETE</promise>'; then
    echo "Build complete." | tee -a "$LOG_FILE"
    exit 0
  fi
  if echo "$OUTPUT" | grep -q '<promise>PLAN_READY</promise>'; then
    echo "Plan ready." | tee -a "$LOG_FILE"
    exit 0
  fi
  sleep 2
done
