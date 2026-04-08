#!/bin/bash
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROMPT_PATH="$SCRIPT_DIR/../PROMPT.md"

if [ -z "$1" ]; then
  echo "Usage: $0 <repo>"
  exit 1
fi

repo="$1"

if [ ! -d "$repo/.git" ]; then
  echo "Error: $repo is not a git repository"
  exit 1
fi

if [ ! -f "$PROMPT_PATH" ]; then
  echo "Error: prompt not found at $PROMPT_PATH"
  exit 1
fi

prompt=$(cat "$PROMPT_PATH")
commits=$(git -C "$repo" log -n 5 --format="%H%n%ad%n%B---" --date=short 2>/dev/null || echo "No commits found")
issues=$(cd "$repo" && gh issue list --state open --json number,title,body,comments 2>/dev/null || echo "[]")

cd "$repo"
claude --permission-mode acceptEdits \
  "Previous commits: $commits $issues $prompt"
