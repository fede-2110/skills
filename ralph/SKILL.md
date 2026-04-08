---
name: ralph
description: Run Ralph autonomous coding agent. Use when user says "ralph", "run ralph", "ralph afk", "ralph hitl".
---

# Ralph

## Usage

```
/ralph afk <iterations> <repo1> [repo2] [repo3...]
/ralph hitl <repo>
```

## Steps

1. Parse arguments: mode (`afk`/`hitl`), iterations (afk only), repo paths (must be absolute). Ask if missing.

2. Pre-flight: check each repo for `.husky/` dir or `husky` in package.json devDependencies. If not found, warn user and block until they confirm.

3. **Execute:**

   ### AFK mode

   **Step 1: Launch in background**

   ```bash
   bash ~/.claude/skills/ralph/scripts/ralph-afk.sh <iterations> <repo1> [repo2...] &
   echo "PID: $!"
   ```

   **Step 2: Poll status file every 30 seconds until you see "FINISHED"**

   ```bash
   sleep 30 && cat ~/.claude/ralph/logs/ralph-status.log
   ```

   After each poll, show the NEW lines to the user (skip lines already shown). Keep polling until the file contains "FINISHED".

   **Step 3: Report completion.**

   ### HITL mode

   Run directly in foreground:

   ```bash
   bash ~/.claude/skills/ralph/scripts/ralph-hitl.sh <repo>
   ```

**IMPORTANT: Execute these commands with the Bash tool. Do not describe or summarize what Ralph does. Just run the commands.**
