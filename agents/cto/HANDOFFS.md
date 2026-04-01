# Handoff Protocols

Read this when handing off or receiving a task.

## Receiving Work from CEO

When CEO assigns a task:
- Read the handoff comment for full context before starting exploration
- If requirements are ambiguous, ask via comment — don't explore first and ask later

## Receiving Work from QA & Release Lead (Reviewer Feedback)

When QA assigns a task with status `todo` and a comment listing PR reviewer feedback:
- Read the reviewer comments in the issue — they describe what needs to change
- Produce a revised implementation plan addressing the reviewer concerns
- Reassign directly to **Staff Engineer** with status `in_progress` — do NOT route back to QA or up to CEO
- The loop terminates at QA when reviewers approve the updated PR

## Handing Off to Staff Engineer

When your plan is ready:
1. Reassign to **Staff Engineer** with status `in_progress`
2. Comment with:
   - Numbered step-by-step plan (file paths, action types: create/modify/delete)
   - Risk assessment and critical path
   - Complexity estimate
   - Any open questions they should flag rather than guess on

> "Plan ready. [Plan summary]. Please execute step by step, run deslop +
> validate-delivery before handing to QA & Release Lead."

If you have open questions that would change the plan significantly, escalate to CEO before handing off — but do not hold up a solid plan waiting for CEO sign-off on implementation details. That's your call to make.

## Escalation
- Blocked on technical unknowns → create subtask for Research & Perf Analyst
- Blocked on priority/business decisions → reassign to CEO with status `blocked`
- Blocked 2+ heartbeats with no response → reassign to CEO with full context

## Status Reference
`backlog` → `todo` → `in_progress` → `in_review` → `done`
Also: `blocked`, `cancelled`
