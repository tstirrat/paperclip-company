# Wake-Up Checklist

Read and follow this every time you wake up.

## 1. Orient
- Check `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_COMMENT_ID`, `PAPERCLIP_WAKE_REASON`
- If woken by a mention, read that comment first (may be CI notification or Staff Engineer question)

## 2. Check Inbox
- `GET /api/agents/me/inbox-lite`
- Priority: `in_progress` → `todo` → `blocked` (only if you have new info)
- Blocked dedup: if your last comment was a blocker and no new comments since, skip it
- Empty inbox + no mention → exit cleanly

## 3. Pick One Task

## 4. Checkout
Before ANY work: `POST /api/issues/{issueId}/checkout` with `X-Paperclip-Run-Id` header.
409 = another agent owns it — back off, pick something else. Never retry a 409.

## 5. Context
- `GET /api/issues/{issueId}/heartbeat-context` for compact context
- If resuming: only read new comments since your last activity
- If starting: read Staff Engineer's handoff comment for change summary

## 6. Work

### Step 6a — Triage (before any review)

Check how the work arrived before doing anything else:

**a. Is there a commit on local main not yet pushed?**
```
git log HEAD --oneline | grep <expected-change>
git log origin/main --oneline | grep <expected-change>
```
→ Commit on local main but NOT on `origin/main`: engineer worked directly on the main
repo instead of a worktree. **Send back to Staff Engineer** (see `HANDOFFS.md`).

**b. Is the work already on `origin/main`?**
→ Check for a merged PR: `gh pr list --state merged --search <branch-or-commit>`
→ Merged PR found: go to **Post-Merge Cleanup** in `HANDOFFS.md` — do NOT re-review.
→ No merged PR: mark task `blocked` — cannot confirm this is legitimate work without a PR record.

**c. Otherwise — verify a worktree and branch exist:**
```
git worktree list | grep <task-identifier>
```
→ No worktree or branch: **Send back to Staff Engineer** (see `HANDOFFS.md`).
→ Worktree and branch present: proceed with review below.

### Step 6b — Review workflow
1. Run `orchestrate-review` — code quality, security, performance, test coverage passes
2. If issues found: comment with specific actionable feedback, reassign to Staff Engineer
3. If all passes clean: run `validate-delivery` for final checks
4. Run `sync-docs` — documentation, CHANGELOG, stale references
5. Create PR, wait for CI, address every auto-reviewer comment
6. Merge when green — never override CI

## 7. Update and Exit
Before exiting, you MUST comment on every task you touched:
- **Merged**: comment with merge confirmation + PR link; reassign to CEO as done
- **Sent back to Staff Engineer**: comment with specific numbered fix list
- **In progress**: review status so far and what's next
- **Blocked on CI**: specific failure details and what you're waiting for
