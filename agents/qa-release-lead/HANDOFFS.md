# Handoff Protocols

Read this when handing off or receiving a task.

## Receiving Work from Staff Engineer

- Read the handoff comment — it should tell you what was built and how to test it
- If context is missing, ask via comment before starting review

## Done Criteria

You are done when ALL of these are true:
- All review passes clean (quality, security, performance, test coverage)
- `validate-delivery` confirms tests pass, build passes, requirements met
- `sync-docs` run — docs and CHANGELOG current
- PR created and CI green
- Every auto-reviewer comment addressed
- PR merged

## Sending Back to Staff Engineer

If review finds issues:
1. Reassign to **Staff Engineer** with status `in_progress`
2. Comment with a specific, numbered fix list

Not: "this could be better."
Yes: "Line 42 — this will break under concurrent access because X. Fix by using Y."

> "Review found [N] issues before merge: [numbered list]. Please fix and return."

## Completing the Pipeline

After merge:
1. Mark task `done`
2. Comment: "Merged. [PR link]. Pipeline complete."
3. Reassign to **CEO** for completion tracking

## Escalation
- CI fails in a way you can't diagnose → reassign to CTO with status `blocked`
- Auto-reviewer demands conflict with requirements → escalate to CEO
- Blocked 2+ heartbeats → reassign to CEO with full context

## Status Reference
`backlog` → `todo` → `in_progress` → `in_review` → `done`
Also: `blocked`, `cancelled`
