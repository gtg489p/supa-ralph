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
  if [[ "${SUPA_RALPH_I_ACCEPT_RISK:-}" == "1" ]]; then
    return 0
  fi
  if [[ -f "$RALPH_HOME/.risk-accepted" ]]; then
    return 0
  fi
  cat >&2 <<'MSG'
Supa Ralph runs Claude Code with --dangerously-skip-permissions.
Run this only in a trusted or sandboxed environment.
Either export SUPA_RALPH_I_ACCEPT_RISK=1 for this invocation, or run
`touch .supa-ralph/.risk-accepted` in this project to record a per-project
opt-in. Env-var exports can leak across projects; the file marker stays
scoped to the checkout it lives in.
MSG
  exit 1
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

run_claude_with_retry() {
  # Invoke Claude Code up to 3 times with 5s/15s backoff between attempts.
  # A transient rate-limit or network blip no longer silently wastes the
  # whole outer iteration; one visible retry cycle is preferable to a
  # spurious "no promise tag" loop step.
  local prompt_file=$1
  local log_file=$2
  local max_attempts=3
  local -a sleeps=(5 15)
  local attempt exit_code sleep_for tmp
  tmp=$(mktemp)
  for (( attempt = 1; attempt <= max_attempts; attempt++ )); do
    set +e
    claude --dangerously-skip-permissions --print "$(cat "$prompt_file")" >"$tmp" 2>&1
    exit_code=$?
    set -e
    cat "$tmp" >>"$log_file"
    if [[ "$exit_code" -eq 0 ]] \
       && ! grep -qiE 'rate[- ]?limit|(^|[^0-9])429([^0-9]|$)|temporarily unavailable|connection (reset|refused|timed? out)|econnreset|etimedout|network error' "$tmp"; then
      cat "$tmp"
      rm -f "$tmp"
      return 0
    fi
    if [[ "$attempt" -lt "$max_attempts" ]]; then
      sleep_for="${sleeps[$((attempt - 1))]}"
      # Route retry notices to stderr + log only — never stdout —
      # so they don't pollute the captured output that match_promise_tag scans.
      local msg="[retry $attempt/$max_attempts] claude invocation failed (exit=$exit_code); sleeping ${sleep_for}s before next attempt"
      echo "$msg" >>"$log_file"
      echo "$msg" >&2
      sleep "$sleep_for"
    fi
  done
  cat "$tmp"
  rm -f "$tmp"
  return "$exit_code"
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

LOG_KEEP="${SUPA_RALPH_LOG_KEEP:-20}"
if [[ "$LOG_KEEP" =~ ^[0-9]+$ && "$LOG_KEEP" -gt 0 ]]; then
  # Prune oldest logs down to $LOG_KEEP before writing a new one.
  ls -1t "$LOG_DIR"/*.log 2>/dev/null | tail -n +"$((LOG_KEEP + 1))" | xargs -r rm -f --
fi

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
  OUTPUT=$(run_claude_with_retry "$PROMPT_FILE" "$LOG_FILE") || true
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
