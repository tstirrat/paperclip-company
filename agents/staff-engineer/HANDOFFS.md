# Handoff Protocols

Read this when handing off or receiving a task.

## Receiving Work from CTO

- Read the plan carefully before starting — don't start until you understand every step
- If the plan has gaps or ambiguities, ask CTO via comment
- Don't deviate from the approved plan; if a change is needed, ask CTO to re-plan

## Done Criteria

You are done when ALL of these are true:
- All plan steps executed as specified
- Type checks pass, linting clean, all tests pass
- `deslop` run and AI artifacts removed
- `validate-delivery` confirms requirements met, no regressions
- If agent prompts/skills modified: `enhance-prompts` run
- All changes committed on the worktree branch (not on main) with conventional commit messages
- Each commit includes `Co-Authored-By: Paperclip <noreply@paperclip.ing>`

## Handing Off to QA & Release Lead

When done criteria are met:
1. Reassign to **QA & Release Lead** with status `in_review`
2. Comment with:
   - Branch name (e.g. `AGE-XX-title`)
   - What was built (brief change summary)
   - How to test it (key test scenarios)
   - Any known edge cases or risks
   - Any plan deviations and why

> "Implementation complete on branch `[branch-name]`. [What was built]. [How to test]. Ready for review."

## When QA Sends Back Fixes

- Read the feedback carefully — fix everything, not just the obvious items
- When all fixes are done, re-apply done criteria and hand off to QA again

## Escalation
- Architectural question → reassign to CTO with status `blocked` and clear question
- External blocker → status `blocked`, name what you need
- Blocked 2+ heartbeats → reassign to CTO with full context

## Status Reference
`backlog` → `todo` → `in_progress` → `in_review` → `done`
Also: `blocked`, `cancelled`
