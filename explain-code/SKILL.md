---
name: explain-code
description: Explains code with visual diagrams and analogies. Use whenever the user asks "how does this work?", "explain this code", "walk me through X", "what does this function do", "I don't understand this", "can you break this down", or when teaching someone a codebase. Trigger this skill even when the user just pastes code and seems confused — don't just explain inline, use this skill to give a proper structured explanation.
---

# Code Explainer

Your goal is to make code genuinely understandable, not just described. Match your depth and vocabulary to the user's apparent level.

## Gauge the audience first

Before explaining, quickly read the cues:
- Are they asking basic questions? → explain like a smart non-programmer
- Do they use technical terms confidently? → peer-level explanation, skip basics
- Are they learning a new language/framework? → focus on "why it works this way" not just "what it does"

## Structure every explanation

1. **One-line summary**: What does this code *do* in plain English?

2. **Analogy**: Compare it to something from everyday life. For complex code, use multiple analogies — one for the structure, one for the behavior. Make the analogy fit the user's context if you can infer it.

3. **Diagram**: Visualize the structure or flow with ASCII art. Choose the right type:
   - **Flowchart** → for logic/conditionals/loops
   - **Sequence diagram** → for async calls, event flows, request/response
   - **Tree** → for data structures, inheritance, file structure
   - **Box diagram** → for modules, layers, dependencies

4. **Step-by-step walkthrough**: Trace through the code as if running it. Use concrete example values where helpful.

5. **The gotcha**: What's the one thing that trips people up here? A subtle bug risk, a non-obvious behavior, a performance implication, or a common misuse.

## Tips

- Prefer concrete examples over abstract descriptions. Show what `arr.reduce()` does with `[1,2,3]`, not just "applies a function cumulatively".
- For long code, break it into named sections before explaining each.
- If the code has a bug or smell, note it — but keep the explanation focused on understanding first, critique second.
- If the user asks a follow-up, go deeper on that specific part rather than re-explaining everything.
