---
name: code-review
description: Comprehensive code review covering security, quality, and best practices. Use when the user says "review this", "check my code", "look at this before I commit", "/code-review", or is about to do a git commit or push. Run this skill proactively before any commit or push operation.
---

# Code Review Protocol

Run a thorough review on modified code and report findings by severity. Be specific — every finding needs a file:line reference and a concrete fix suggestion.

## Step 0: Detect context

Before running the checklist:
1. Check `git status` for modified/staged files. If no git, ask which files to review.
2. Identify the language(s) and framework(s) in use — skip checks that don't apply (e.g., React hooks checks for a Python project, SQL checks if there's no database layer).
3. Read each modified file in full before starting the checklist.

## Checklist

### 🔴 SECURITY — Block commit if any fail

1. **SQL Injection**: Raw SQL with string interpolation/concatenation?
2. **XSS**: Unsanitized user input rendered into HTML/DOM?
3. **Auth bypass**: Missing permission checks on routes or endpoints?
4. **Secrets exposure**: Passwords, API keys, tokens in code or logs?
5. **Dependency vulns**: Obvious outdated packages with known CVEs?
6. **CSRF**: State-changing endpoints missing CSRF protection?
7. **Command injection**: User input passed to exec/eval/shell calls?
8. **Path traversal**: File paths from user input without sanitization?
9. **Insecure deserialization**: Untrusted data deserialized unsafely?
10. **Hardcoded credentials**: Auth values baked into source code?

### 🟡 QUALITY — Flag, let user decide before committing

11. **Unused imports / dead code**: Imports or functions never referenced?
12. **Debug artifacts**: console.log, print, debugger, TODO left in production paths?
13. **Magic numbers**: Unexplained literals that should be named constants?
14. **Edge cases**: Null, empty, zero, negative, very large inputs handled?
15. **Error handling**: Exceptions caught and handled meaningfully (not silently swallowed)?
16. **Async errors**: All promises/async calls have error handlers?
17. **Input validation**: User/external data validated before use?
18. **Null guards**: Property access on potentially null/undefined values?
19. **Resource cleanup**: Files, DB connections, timers, listeners closed/removed?
20. **Race conditions**: Shared mutable state accessed concurrently without guards?
21. **Infinite loop risk**: Loop termination guaranteed?
22. **Immutability**: State mutations done safely (especially in React/Redux)?

### 🔵 BEST PRACTICES — Suggestions, not blockers

23. **Naming**: Consistent conventions (camelCase, PascalCase, snake_case per language)?
24. **DRY**: Duplicated logic that should be extracted?
25. **Function length**: Functions over ~50 lines are hard to reason about — can they be split?
26. **Complexity**: Functions doing more than one thing?
27. **Coupling**: Hard dependencies between modules that should be decoupled?
28. **Test coverage**: New behavior has corresponding tests?
29. **Documentation**: Public APIs and non-obvious logic have comments?
30. **Breaking changes**: Does this change break existing callers or contracts?

*Language-specific checks (only if relevant):*
- **JS/TS**: `any` types, missing `.catch()`, unnecessary re-renders, N+1 queries
- **React**: PropTypes or TypeScript props, missing `key` props, effect dependency arrays
- **Python**: Type hints on public functions, context managers for resources
- **SQL**: Parameterized queries, index usage on filtered columns

## Output format

```
🔍 CODE REVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Files reviewed: X files, ~Y lines

🔴 CRITICAL (fix before committing):
  auth/login.js:42 — SQL injection: user input interpolated into query
    ❌ `SELECT * FROM users WHERE id=${req.params.id}`
    ✅ db.query('SELECT * FROM users WHERE id=?', [req.params.id])

🟡 WARNINGS (should fix):
  components/Form.tsx:15 — Unused import: useState
  utils/math.js:89 — Magic number: 86400000 → use MS_PER_DAY constant

🔵 SUGGESTIONS (consider):
  api/orders.ts:120 — Function is 73 lines, consider splitting at the validation step

✅ Passed: 27/30 applicable checks
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ COMMIT BLOCKED — fix 1 critical issue first
```

If no issues found: say so clearly and confirm the commit looks good.
