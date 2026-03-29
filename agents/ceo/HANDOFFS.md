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

## Escalation Patterns

- **CTO is blocked**: read their comment; resolve if you can (priority call, new context)
- **Staff Engineer is blocked**: usually a technical question — reassign to CTO
- **QA & Release Lead is blocked**: help diagnose; involve the user if needed
- **Pipeline stalled >2 heartbeats**: @-mention the stuck agent with a specific action request

## Status Reference
`backlog` → `todo` → `in_progress` → `in_review` → `done`
Also: `blocked`, `cancelled`
