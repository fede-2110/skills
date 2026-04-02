---
name: doc-gen
description: Generates comprehensive documentation (JSDoc, README, ADRs, API docs, onboarding guides). Use when the user says "document this", "generate docs", "write a README", "add JSDoc", or when new functions, classes, API endpoints, or architectural decisions are being created. Also trigger proactively when the user makes a significant architectural choice and hasn't documented the reasoning — capturing "why" in the moment is far more valuable than reconstructing it later.
---

# Documentation Generator

Generate living documentation that captures not just *what* code does, but *why* it was built that way. The most valuable documentation is written during development when context is fresh.

## When to generate what

| Trigger | Doc type |
|---|---|
| New function or class | JSDoc comment |
| New module or package | Module README |
| Significant tech/pattern choice | ADR |
| New REST/GraphQL endpoint | API doc (OpenAPI) |
| Project setup or onboarding | Onboarding guide |

Don't ask "should I document this?" — just do it when the trigger applies.

## Asking questions

Ask at most 1–2 questions, only when the answer isn't obvious from context, and only *while* the work is happening — not after. Good questions:
- "Why this approach over [obvious alternative]?"
- "What's the main thing a new dev should know about this?"
- "What edge cases did you consider?"

Never ask questions after the code is complete. If you missed the moment, generate docs from what you can infer and note any assumptions.

## Where to put generated docs

- **JSDoc**: Inline, directly above the function/class
- **README**: `README.md` in the module's directory, or root if project-level
- **ADRs**: `docs/decisions/` or `adr/` directory, filename format: `NNNN-short-title.md`
- **OpenAPI**: `docs/api/openapi.yaml` or alongside the route definitions
- **Onboarding**: `docs/onboarding.md` or `CONTRIBUTING.md`

If docs already exist, update them — don't create duplicates. When updating, flag any sections that are now outdated.

## Formats

**JSDoc**
```js
/**
 * [One-line description of what it does]
 *
 * [Why this approach, if non-obvious]
 *
 * @param {Type} name - description
 * @returns {Type} description
 * @example
 * functionName(input) // => output
 */
```

**ADR** (MADR format)
```markdown
# [Short title]

## Status
Accepted

## Context
[What situation forced this decision?]

## Decision
[What was chosen and why]

## Consequences
[Trade-offs, benefits, limitations]

## Alternatives considered
[What else was evaluated and why it lost]
```

**README sections** (include what's relevant):
- Overview / purpose
- Installation / setup
- Usage with examples
- API surface
- Dependencies
- Known limitations

**OpenAPI**: Use 3.0 YAML format. Include auth requirements, all response codes, and a working example request/response.

## Quality bar

- Never write generic or placeholder docs ("This function does X" where X is just the function name restated)
- Capture trade-offs and constraints, not just happy-path behavior
- If the code has a subtle behavior or gotcha, document it explicitly
- Examples should be concrete and copy-pasteable
