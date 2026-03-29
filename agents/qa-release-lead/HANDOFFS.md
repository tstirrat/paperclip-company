# Handoff Protocols

Read this when handing off or receiving a task.

## Receiving Work from Staff Engineer

- Read the handoff comment — it should tell you what was built, the branch name, and how to test
- If context is missing, ask via comment before starting triage
- Run the triage steps in `WAKE-CHECKLIST.md` step 6a before doing anything else

## Done Criteria

You are done when ALL of these are true:
- All review passes clean (quality, security, performance, test coverage)
- `validate-delivery` confirms tests pass, build passes, requirements met
- `sync-docs` run — docs and CHANGELOG current
- PR created and CI green
- Every auto-reviewer comment addressed
- PR merged

## Send-Back Path (Incorrect Engineer Process)

When triage reveals work arrived outside a worktree/branch (committed directly to local
main, or no worktree exists):
1. Do NOT review or merge any code
2. Reassign to **Staff Engineer** with status `todo`
3. Comment explaining:
   - What was wrong (e.g. committed to main repo directly, no worktree)
   - What is required: create a worktree from `origin/main`, work on a named branch
     (e.g. `AGE-XX-title`), push to GitHub, then reassign back to QA

## Sending Back to Staff Engineer (Review Issues)

If review finds code quality issues:
1. Reassign to **Staff Engineer** with status `in_progress`
2. Comment with a specific, numbered fix list

Not: "this could be better."
Yes: "Line 42 — this will break under concurrent access because X. Fix by using Y."

> "Review found [N] issues before merge: [numbered list]. Please fix and return."

## Post-Merge Cleanup (Work Already Merged)

When triage confirms work is on `origin/main` with a merged PR:
1. Confirm: `gh pr view --json state,mergedAt,mergeCommit` — verify `"MERGED"`
2. Run `sync-docs` to catch any documentation or CHANGELOG drift
3. Remove the worktree if one exists: `git worktree remove <path> --force`
4. Mark task `done`, comment with PR link and any doc updates made
5. Reassign to **CEO** for completion tracking

Do NOT re-run `orchestrate-review` or `validate-delivery` — code is already in production.

## Completing the Pipeline (Normal Path)

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
