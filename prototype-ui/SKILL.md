---
name: prototype-ui
description: Generate 2-3 radically different frontend UI prototypes side-by-side using parallel sub-agents, matching the project's existing stack. Use when user wants to prototype a UI, explore layout options, compare visual approaches, create mockups, or mentions "prototype", "sketch UI", "explore designs", or "UI variants".
---

# Prototype UI

Generate 2-3 radically different frontend prototypes displayed on a single comparison page. Uses parallel sub-agents for speed. All data is mocked. Output lives in `prototypes/` (gitignored, disposable).

## Workflow

### 1. Detect Stack

Auto-detect the project's UI stack before generating anything:

- [ ] Check `package.json` for framework (Next.js, React, Vue, etc.)
- [ ] Check for Tailwind (`tailwind.config.*`)
- [ ] Check for UI library (shadcn `components.json`, MUI, Radix, etc.)
- [ ] Check for CSS approach (CSS modules, styled-components, Tailwind)
- [ ] Note the project's existing component patterns and conventions

Use the detected stack for all prototypes. Do NOT introduce new dependencies.

### 2. Understand the Target

Ask the user ONE clarifying question if needed, then determine the mode:

**Mode A — New feature/page**: User describes something that doesn't exist yet.
- Each variant must be a **radically different** approach (different layout, UX flow, visual hierarchy).

**Mode B — Improve existing**: User references existing code/component.
- Read the existing component code FIRST.
- Each variant must be a **radically different improvement** while keeping the core purpose.

Inputs accepted:
- Text description ("patient dashboard with vitals and appointments")
- Reference to existing code ("improve the `/turnos` page")
- Screenshot/image of UI to improve or recreate

### 3. Generate Variants (Parallel Sub-Agents)

Spawn 2-3 sub-agents simultaneously using the Agent tool with `subagent_type: "frontend-developer"`. Each agent gets a **different design constraint** to force divergence.

**Constraint sets** (pick 2-3, never reuse across variants):
- "Dense information layout — maximize data visibility, minimal whitespace"
- "Spacious minimal layout — generous whitespace, progressive disclosure"
- "Card-based modular layout — drag-and-drop feel, widget-like sections"
- "Sidebar-driven navigation — persistent sidebar with contextual main panel"
- "Top-nav wizard flow — step-by-step guided experience"
- "Split-pane layout — master-detail, resizable panels"
- "Dashboard grid — metrics-forward, chart-heavy, KPI cards"
- "Conversational/timeline layout — vertical flow, activity-stream feel"

**Prompt template for each sub-agent**:

```
You are building a UI prototype variant.

PROJECT STACK: [detected stack details]
TARGET: [description or existing code]
DESIGN CONSTRAINT: [assigned constraint]
MODE: [New feature | Improve existing]

Requirements:
1. Create a single React/Next.js component file at: prototypes/[feature-name]/Variant[N].tsx
2. Use ONLY the project's existing stack (Tailwind, shadcn, etc.)
3. All data must be MOCK data — realistic but hardcoded
4. Component must be self-contained (no external state, no API calls)
5. Include responsive behavior
6. The design must be RADICALLY different from other variants
7. Export a default component

Output ONLY the component file content. No explanations.
```

### 4. Assemble Comparison Page

After all sub-agents complete, create the comparison page:

**File**: `prototypes/[feature-name]/page.tsx`

```tsx
// Single page showing all variants side-by-side
// Toggle between variants with tabs or show all stacked
// Label each variant with its design approach
```

The comparison page must:
- Show all variants with clear labels ("Variant A: Dense Layout", "Variant B: Minimal", etc.)
- Include a simple tab/toggle to switch between full-screen view of each
- Work as a standalone page (can be accessed at `/prototypes/[feature-name]` if added to routing, or opened directly)

### 5. Ensure Gitignore

Check that `prototypes/` is in `.gitignore`. If not, add it.

### 6. Present to User

After generation, tell the user:
- Where files are: `prototypes/[feature-name]/`
- How to view: add a route or open the comparison page
- Remind: "Delete `prototypes/[feature-name]/` when done"
- Ask: "Which variant direction do you prefer? I can reference it in a PRD."

## Rules

- **Mock data only** — never import real services, stores, or API clients
- **Match existing stack** — never add new packages or deviate from project conventions
- **Self-contained** — each variant is one file, no shared state
- **Disposable** — prototypes are throwaway; don't over-engineer
- **No implementation** — these are visual explorations, not production code
- **Radically different** — if two variants look similar, the skill failed
