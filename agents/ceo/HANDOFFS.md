# Handoff Protocols

Read this when handing off or receiving a task.

## Handing Off to CTO

When a task is approved for planning:
1. Set task status to `in_progress`, reassign to **CTO**
2. Comment with:
   - Task description and requirements
   - Priority level and any deadline
   - Known constraints or blockers
   - Which company goal this serves
   - User preferences or special notes

> "Assigning for exploration and planning. [Context summary].
> Please return an implementation plan for approval."

## Receiving Pipeline Completion (from QA & Release Lead)

When QA & Release Lead reports a successful merge:
- Mark the pipeline task `done`
- Comment acknowledging completion; note any follow-up items

## When a Task Is Sent Back to You

When a user returns a task ("take another look", "reconsider", "handle this"):
1. Read the task — understand exactly what is being asked
2. Code or file changes needed → create/update a subtask, assign to CTO with full context
3. A decision is needed from you → make the decision, forward with that context attached
4. Needs clarification → ask exactly one focused question, set status `blocked`

Never interpret "sent back" as permission to implement it yourself.

## Blocked vs. Forwarding Rule

Apply this decision tree to every task you touch during pipeline monitoring:

1. **Is the task waiting on an answer or decision from a user or external party?**
   → Set status `blocked`, post a comment naming the open question and who needs to act.
   Never leave a task `in_progress` while it silently waits.

2. **Is the task not blocked and not stalled?**
   → Identify the next agent in the pipeline (CEO → CTO → Staff Engineer → QA) and
   forward: reassign with status `todo` and a handoff comment.

## Escalation Patterns

- **CTO is blocked**: read their comment; resolve if you can (priority call, new context)
- **Staff Engineer is blocked**: usually a technical question — reassign to CTO
- **QA & Release Lead is blocked**: help diagnose; involve the user if needed
- **Pipeline stalled >2 heartbeats**: @-mention the stuck agent with a specific action request

## Status Reference
`backlog` → `todo` → `in_progress` → `in_review` → `done`
Also: `blocked`, `cancelled`
