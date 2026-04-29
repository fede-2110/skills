# Agent Skills

Backup of Claude Code skills. Lives directly at `~/.claude/skills/`.

Claude Code only discovers skills at the first level (`~/.claude/skills/<skill>/SKILL.md`), so all skills are kept flat at the root. The categories below are for human navigation only.

## Restore

```bash
git clone https://github.com/fede-2110/skills.git ~/.claude/skills
```

## Engineering

Skills for daily code work.

### Pocock core

- **[setup-matt-pocock-skills](./setup-matt-pocock-skills/SKILL.md)** — Scaffold per-repo config (issue tracker, triage labels, domain doc layout). Run once per repo.
- **[grill-with-docs](./grill-with-docs/SKILL.md)** — Grilling session that challenges your plan against the existing domain model and updates `CONTEXT.md` and ADRs inline.
- **[diagnose](./diagnose/SKILL.md)** — Disciplined diagnosis loop for hard bugs and performance regressions.
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)** — Find deepening opportunities informed by `CONTEXT.md` and `docs/adr/`.
- **[tdd](./tdd/SKILL.md)** — Test-driven development with red-green-refactor.
- **[triage](./triage/SKILL.md)** — Triage issues through a state machine of triage roles.
- **[to-issues](./to-issues/SKILL.md)** — Break a plan/PRD into independently-grabbable issues using vertical slices.
- **[to-prd](./to-prd/SKILL.md)** — Turn the current conversation context into a PRD and publish it.
- **[zoom-out](./zoom-out/SKILL.md)** — Get broader context on an unfamiliar section of code.
- **[prd-to-plan](./prd-to-plan/SKILL.md)** — Turn a PRD into a multi-phase implementation plan.

### Custom

- **[code-review](./code-review/SKILL.md)** — Comprehensive code review (security, quality, best practices).
- **[do-work](./do-work/SKILL.md)** — Execute a unit of work end-to-end: plan, implement, validate, commit.
- **[explain-code](./explain-code/SKILL.md)** — Explain code with visual diagrams and analogies.
- **[frontend-design](./frontend-design/SKILL.md)** — Distinctive, production-grade frontend interfaces.
- **[prototype-ui](./prototype-ui/SKILL.md)** — Generate 2–3 different UI prototypes side-by-side using parallel sub-agents.
- **[react-doctor](./react-doctor/SKILL.md)** — Diagnose React/Next.js code health.

## Productivity

General workflow tools, not code-specific.

- **[caveman](./caveman/SKILL.md)** — Ultra-compressed communication mode (~75% fewer tokens).
- **[grill-me](./grill-me/SKILL.md)** — Get relentlessly interviewed about a plan or design.
- **[worktree-manager](./worktree-manager/SKILL.md)** — Manage git worktrees for parallel feature development.
- **[write-a-skill](./write-a-skill/SKILL.md)** — Create new skills with proper structure.

## Misc

Kept around but rarely used.

- **[git-guardrails-claude-code](./git-guardrails-claude-code/SKILL.md)** — Block dangerous git commands via Claude Code hooks.
- **[migrate-to-shoehorn](./migrate-to-shoehorn/SKILL.md)** — Migrate test files from `as` to @total-typescript/shoehorn.
- **[pnpm-not-found](./pnpm-not-found/SKILL.md)** — Fix `pnpm command not found` via corepack.
- **[setup-ai-feedback-loops](./setup-ai-feedback-loops/SKILL.md)** — Set up static analysis, tests, hooks, formatting.
- **[setup-pre-commit](./setup-pre-commit/SKILL.md)** — Set up Husky pre-commit hooks with lint-staged.

## Deprecated

Skills Pocock no longer maintains. Kept for reference.

- **[design-an-interface](./design-an-interface/SKILL.md)** — Generate radically different interface designs using parallel sub-agents.
- **[request-refactor-plan](./request-refactor-plan/SKILL.md)** — Build a refactor plan via interview, broken into tiny safe commits.
