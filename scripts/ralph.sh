#!/usr/bin/env bash
set -euo pipefail
MODE=${1:-build}
MAX_ITERATIONS=${2:-10}
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
RALPH_HOME="$PROJECT_ROOT/.supa-ralph"
PLAN_FILE="$RALPH_HOME/IMPLEMENTATION_PLAN.md"
PROGRESS_FILE="$RALPH_HOME/progress.txt"
LOG_DIR="$RALPH_HOME/logs"
mkdir -p "$LOG_DIR"

require_risk_ack() {
  if [[ "${SUPA_RALPH_I_ACCEPT_RISK:-}" != "1" ]]; then
    cat >&2 <<'MSG'
Supa Ralph runs Claude Code with --dangerously-skip-permissions.
Run this only in a trusted or sandboxed environment.
Re-run with SUPA_RALPH_I_ACCEPT_RISK=1 if you intend to proceed.
MSG
    exit 1
  fi
}

strip_wrappers() {
  sed -e 's/\r$//' -e 's/[[:space:]]*$//' -e 's/^`*//' -e 's/`*$//'
}

tail_non_empty() {
  grep -v '^[[:space:]]*$' | tail -n 5
}

match_promise_tag() {
  local tag=$1
  local output=$2
  printf '%s\n' "$output" | tail_non_empty | strip_wrappers | grep -qF "<promise>${tag}</promise>"
}

status() {
  local pending=0 completed=0 log_count=0 latest_log=""
  [[ -f "$PLAN_FILE" ]] && pending=$(grep -c '^- \[ \]' "$PLAN_FILE" || true)
  [[ -f "$PLAN_FILE" ]] && completed=$(grep -c '^- \[x\]' "$PLAN_FILE" || true)
  log_count=$(find "$LOG_DIR" -maxdepth 1 -type f -name '*.log' 2>/dev/null | wc -l | tr -d ' ')
  latest_log=$(ls -1t "$LOG_DIR"/*.log 2>/dev/null | head -n 1 || true)
  printf 'project=%s\n' "$PROJECT_ROOT"
  printf 'pending=%s\n' "$pending"
  printf 'completed=%s\n' "$completed"
  printf 'logs=%s\n' "$log_count"
  [[ -n "$latest_log" ]] && printf 'latest_log=%s\n' "$latest_log"
  printf 'note=counts reflect checkbox-style items only (- [ ] / - [x])\n'
  if [[ -f "$latest_log" ]]; then
    printf '\n--- latest log tail ---\n'
    tail -n 20 "$latest_log"
  fi
}

if [[ "$MODE" == "status" ]]; then
  status
  exit 0
fi

if [[ "$MODE" != "plan" && "$MODE" != "build" ]]; then
  echo "usage: .supa-ralph/scripts/ralph.sh [plan|build|status] [max_iterations]" >&2
  exit 2
fi

require_risk_ack
PROMPT_FILE="$RALPH_HOME/prompts/CLAUDE_${MODE^^}.md"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
LOG_FILE="$LOG_DIR/${MODE}-loop-${TIMESTAMP}.log"
ITERATION=0

[[ -f "$PROMPT_FILE" ]] || { echo "missing prompt: $PROMPT_FILE" >&2; exit 1; }
command -v claude >/dev/null 2>&1 || { echo "claude CLI not found" >&2; exit 1; }
cd "$PROJECT_ROOT"
{
  echo "mode=$MODE"
  echo "project=$PROJECT_ROOT"
  echo "max_iterations=$MAX_ITERATIONS"
  echo "timestamp=$TIMESTAMP"
  echo "log_file=$LOG_FILE"
  echo "---"
} | tee -a "$LOG_FILE"

while true; do
  if [[ "$MAX_ITERATIONS" != "0" && "$ITERATION" -ge "$MAX_ITERATIONS" ]]; then
    echo "Reached max iterations: $MAX_ITERATIONS" | tee -a "$LOG_FILE"
    break
  fi
  ITERATION=$((ITERATION + 1))
  echo "===== SUPA RALPH $MODE iteration $ITERATION =====" | tee -a "$LOG_FILE"
  OUTPUT=$(claude --dangerously-skip-permissions --print "$(cat "$PROMPT_FILE")" 2>&1 | tee -a "$LOG_FILE") || true
  if match_promise_tag "COMPLETE" "$OUTPUT"; then
    echo "Build complete." | tee -a "$LOG_FILE"
    exit 0
  fi
  if match_promise_tag "PLAN_READY" "$OUTPUT"; then
    echo "Plan ready." | tee -a "$LOG_FILE"
    exit 0
  fi
  sleep 2
done
