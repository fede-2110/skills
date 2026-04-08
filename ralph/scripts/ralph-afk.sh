#!/bin/bash
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROMPT_PATH="$SCRIPT_DIR/../PROMPT.md"
LOG_DIR="$HOME/.claude/ralph/logs"
ITERATION_TIMEOUT="30m"

if [ -z "$1" ]; then
  echo "Usage: $0 <iterations> <repo1> [repo2] [repo3...]"
  exit 1
fi

iterations=$1
shift
repos=("$@")

if [ ${#repos[@]} -eq 0 ]; then
  echo "Error: at least one repo path required"
  exit 1
fi

for repo in "${repos[@]}"; do
  if [ ! -d "$repo/.git" ]; then
    echo "Error: $repo is not a git repository"
    exit 1
  fi
done

if [ ! -f "$PROMPT_PATH" ]; then
  echo "Error: prompt not found at $PROMPT_PATH"
  exit 1
fi

mkdir -p "$LOG_DIR"

STATUS_FILE="$LOG_DIR/ralph-status.log"
echo "" > "$STATUS_FILE"

status() {
  local msg="[$(date +%H:%M:%S)] $1"
  echo "$msg" | tee -a "$STATUS_FILE"
}

# Verify dependencies
for cmd in jq gh git; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: $cmd is required but not found in PATH"
    exit 1
  fi
done

status "Ralph started. $iterations iterations across ${#repos[@]} repo(s)."
status "Monitor: tail -f $STATUS_FILE"

# Detect if already inside a sandbox/container (no need to nest another one)
IN_SANDBOX=false
if [ -f /.dockerenv ] || [ -f /run/.containerenv ] || grep -qsE '(docker|containerd|lxc)' /proc/1/cgroup 2>/dev/null; then
  IN_SANDBOX=true
fi

prompt=$(cat "$PROMPT_PATH")

# jq filters
stream_text='select(.type == "assistant").message.content[]? | select(.type == "text").text // empty | gsub("\n"; "\r\n") | . + "\r\n\n"'
final_result='select(.type == "result").result // empty'

# Filter: full output to log, [RALPH] status lines to console + status file
ralph_status_filter() {
  while IFS= read -r line; do
    echo "$line" >> "$1"  # always write to log
    if [[ "$line" == *"[RALPH]"* ]]; then
      echo "$line"
      echo "[$(date +%H:%M:%S)] $line" >> "$STATUS_FILE"
    fi
  done
}

repo_count=${#repos[@]}
total_done=0

# Track which repos are done (0=active, 1=done)
declare -A repo_done
for repo in "${repos[@]}"; do
  repo_done["$repo"]=0
done

active_repos=$repo_count

for ((i=1; i<=iterations; i++)); do
  # Skip if all repos are done
  if [ "$active_repos" -eq 0 ]; then
    status "All repos completed after $total_done iterations."
    status "FINISHED"
    exit 0
  fi

  # Round-robin: pick next active repo
  repo_index=$(( (i - 1) % repo_count ))
  repo="${repos[$repo_index]}"
  repo_name=$(basename "$repo")

  # Skip repos that are done
  if [ "${repo_done[$repo]}" -eq 1 ]; then
    continue
  fi

  total_done=$i
  timestamp=$(date +%Y%m%d-%H%M%S)
  logfile="$LOG_DIR/${repo_name}-${timestamp}.log"

  status "=== Iteration $i/$iterations | Repo: $repo_name ==="

  tmpfile=$(mktemp)
  trap "rm -f $tmpfile" EXIT

  status "Fetching commits and issues..."
  commits=$(git -C "$repo" log -n 5 --format="%H%n%ad%n%B---" --date=short 2>/dev/null || echo "No commits found")
  issues=$(cd "$repo" && gh issue list --state open --json number,title,body,comments 2>/dev/null || echo "[]")

  issue_count=$(echo "$issues" | jq 'length' 2>/dev/null || echo "?")
  status "Found $issue_count open issues. Starting Claude..."

  if [ "$IN_SANDBOX" = true ]; then
    # Already inside a container — run claude directly in the repo
    timeout "$ITERATION_TIMEOUT" \
      env -C "$repo" claude \
        --verbose \
        --print \
        --output-format stream-json \
        --permission-mode bypassPermissions \
        "Previous commits: $commits $issues $prompt" \
      2>&1 \
      | grep --line-buffered '^{' \
      | tee "$tmpfile" \
      | jq --unbuffered -rj "$stream_text" \
      | ralph_status_filter "$logfile" \
    || {
      exit_code=$?
      if [ $exit_code -eq 124 ]; then
        echo "WARNING: Iteration $i timed out after $ITERATION_TIMEOUT for $repo_name"
        echo "[TIMEOUT] Iteration $i timed out after $ITERATION_TIMEOUT" >> "$logfile"
      fi
    }
  else
    # Normal mode — use Docker sandbox for isolation
    timeout "$ITERATION_TIMEOUT" \
      docker sandbox run claude "$repo" -- \
        --verbose \
        --print \
        --output-format stream-json \
        "Previous commits: $commits $issues $prompt" \
      2>&1 \
      | grep --line-buffered '^{' \
      | tee "$tmpfile" \
      | jq --unbuffered -rj "$stream_text" \
      | ralph_status_filter "$logfile" \
    || {
      exit_code=$?
      if [ $exit_code -eq 124 ]; then
        echo "WARNING: Iteration $i timed out after $ITERATION_TIMEOUT for $repo_name"
        echo "[TIMEOUT] Iteration $i timed out after $ITERATION_TIMEOUT" >> "$logfile"
      fi
    }
  fi

  status "Iteration $i finished for $repo_name. Log: $logfile"

  result=$(jq -r "$final_result" "$tmpfile" 2>/dev/null || echo "")

  if [[ "$result" == *"<promise>NO MORE TASKS</promise>"* ]]; then
    status "No more tasks in $repo_name. Skipping in future iterations."
    repo_done["$repo"]=1
    active_repos=$((active_repos - 1))
  fi
done

status "Ralph completed $total_done iterations across ${repo_count} repo(s). Active repos remaining: $active_repos."
status "FINISHED"
