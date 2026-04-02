---
name: react-doctor
description: Diagnoses React/Next.js code health using react-doctor. Runs `npx -y react-doctor@latest` on the frontend apps and reports a 0-100 health score with categorized issues (performance, security, dead code, accessibility, bundle size). Use this skill whenever the user says "react-doctor", "/react-doctor", "diagnose frontend", "health check frontend", "auditar frontend", "qué tan sano está el frontend", or wants to find dead code, performance issues, or security problems in the React apps. Also trigger proactively after large refactors or before releases.
---

# react-doctor

Diagnose the health of React/Next.js frontend apps using [react-doctor](https://github.com/millionco/react-doctor).

## Step 1: Detect project structure

Detect the frontend app(s) in the current working directory. Look for `next.config.js`, `next.config.mjs`, or `next.config.ts` files to find Next.js apps.

Common structures:
- **Monorepo with `apps/`**: Multiple apps under `apps/<name>/` (e.g., `apps/admin`, `apps/web`)
- **Monorepo with named dirs**: Frontend at `web/`, `frontend/`, `client/`
- **Single app**: `next.config.*` in the project root

Run:
```bash
find . -maxdepth 3 -name "next.config.*" -not -path "*/node_modules/*" 2>/dev/null
```

Build a list of app paths from the results. If the user specified a target (e.g., "react-doctor web"), use only that one.

## Step 2: Run react-doctor

For each app found, run from the repo root:

```bash
npx -y react-doctor@latest <app-path> 2>&1
```

Add `--verbose` if the user asked for verbose/detailed output.

Run apps sequentially (not in parallel) to keep output readable.

## Step 3: Present results

### Summary table first

After running all apps, show a summary table:

```
| App             | Score | Status        |
|-----------------|-------|---------------|
| web             |  84   | Great         |
| admin           |  62   | Needs Work    |
```

Score thresholds (from react-doctor):
- 75-100 → Great
- 50-74  → Needs Work
- 0-49   → Critical

### Then detail per app

For each app, show the issues grouped by category (performance, security, dead code, accessibility, bundle size). Focus on the most impactful ones — skip noise.

## Step 4: Recommendations

After the report, offer 1-3 actionable next steps based on the worst issues found. Do NOT make code changes automatically — just report and suggest. If the user wants to fix something specific, they'll ask.

## Notes

- react-doctor is a diagnostic tool only — it detects but does not auto-fix
- First run may be slow (npx downloads the package)
- If an app errors out, skip it and note the failure in the summary
