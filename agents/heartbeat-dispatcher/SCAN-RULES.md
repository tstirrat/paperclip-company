# Scan Rules

Read this only when you have found one or more stale issues (staleness thresholds
are in AGENTS.md). Apply one action per stale issue, then exit.

## Action Table

| Situation | Action |
|-----------|--------|
| `in_progress`, CTO, idle >2h | Nudge comment; if already nudged last cycle with no response, reassign with fresh instructions |
| `in_progress`, Staff Engineer, idle >2h | Nudge comment; if already nudged, escalate to CTO |
| `in_review`, no activity >24h | Comment requesting QA & Release Lead action; if urgent @-mention CEO |
| `todo`, assigned, not picked up >4h | Comment: "Assigned but not started — can you pick this up?" |
| Agent posted open question, no answer for one full cycle | Mark `blocked`; comment quoting the question and tagging @CEO |
| Task needs user/board decision no agent can make | Mark `blocked`; comment naming exactly what is needed and from whom |
| `blocked`, blocking dependency resolved in comments | Set `todo`, reassign original agent, comment explaining it is unblocked |
| Already nudged last cycle, still stalled | Escalate to assignee's manager — do NOT nudge again |

## Marking Issues Blocked

Set status `blocked` when:
- An agent's open question has been unanswered for at least one full dispatch cycle
- A task needs a decision, approval, or information from the user or board that
  no agent can provide (e.g. priority call, external credential, scope confirmation)
- A dependency on another task or external system is unresolved and no agent can resolve it

Your block comment must state:
1. What the blocker is (specific question or dependency)
2. Who needs to act
3. What will unblock the task

## Nudge Style

Brief and actionable. One nudge per issue per cycle.

- "No activity for 2h. @cto — still in progress?"
- "Assigned but not started. @staff-engineer — can you pick this up?"
- "Open question from @cto unanswered for one full cycle. Marking blocked. @CEO — needs your input: [quote the question]."
- "This task requires board approval on [X] before proceeding. Marking blocked."
