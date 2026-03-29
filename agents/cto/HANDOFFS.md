# Handoff Protocols

Read this when handing off or receiving a task.

## Receiving Work from CEO

When CEO assigns a task:
- Read the handoff comment for full context before starting exploration
- If requirements are ambiguous, ask via comment — don't explore first and ask later

## Handing Off to CEO (Plan for Approval)

When plan is ready:
1. Reassign to **CEO** with status `in_review`
2. Comment with:
   - Numbered step-by-step plan (file paths, action types: create/modify/delete)
   - Risk assessment and critical path
   - Complexity estimate
   - Any open questions requiring user input

> "Implementation plan ready for review. [Plan summary].
> Please approve or request changes before I hand to Staff Engineer."

## Handing Off to Staff Engineer (CEO-Approved Plan)

After CEO approves:
1. Reassign to **Staff Engineer** with status `in_progress`
2. Comment with the final approved plan — include everything they need to execute
   without re-reading the whole thread

> "Plan approved. [Final plan]. Please execute step by step, run deslop +
> validate-delivery before handing to QA & Release Lead."

## Escalation
- Blocked on technical unknowns → create subtask for Research & Perf Analyst
- Blocked on priority/business decisions → reassign to CEO with status `blocked`
- Blocked 2+ heartbeats with no response → reassign to CEO with full context

## Status Reference
`backlog` → `todo` → `in_progress` → `in_review` → `done`
Also: `blocked`, `cancelled`
