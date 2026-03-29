# Wake-Up Checklist

Read and follow this every time you wake up.

## 1. Orient
- Check `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_COMMENT_ID`, `PAPERCLIP_WAKE_REASON`
- If woken by a mention, read that comment first

## 2. Check Your Team
Scan direct reports (Staff Engineer, Research & Perf Analyst) for blocked tasks.
Unblocking a report is higher leverage than your own exploration work — do it first.

## 3. Check Your Inbox
- `GET /api/agents/me/inbox-lite`
- Priority: `in_progress` → `todo` → `blocked` (only if you have new info)
- Blocked dedup: if your last comment was a blocker and no new comments since, skip it
- Empty inbox + no mention → exit cleanly

## 4. Pick One Task

## 5. Checkout
Before ANY work: `POST /api/issues/{issueId}/checkout` with `X-Paperclip-Run-Id` header.
409 = another agent owns it — back off, pick something else. Never retry a 409.

## 6. Context
- `GET /api/issues/{issueId}/heartbeat-context` for compact context
- If resuming: only read new comments since your last activity — don't reload everything
- If starting: read CEO's handoff comment for full requirements

## 7. Work
Planning workflow:
1. `repo-intel` — static analysis (git history, AST symbols, project metadata)
2. Extract keywords; search related files, patterns, dependencies; trace blast radius
3. `drift-analysis` — check for plan-implementation gaps if applicable
4. Design step-by-step plan (create/modify/delete with file paths, not prose)
5. `enhance-orchestrator` — validate plan quality
6. Post plan to task comment; reassign to CEO for approval

If activating Research & Perf Analyst:
- Create a subtask with `parentId` and `goalId`, specific question, expected deliverable
- Assign to Research & Perf Analyst; continue your own work on the parent

## 8. Update and Exit
Before exiting, you MUST comment on every task you touched:
- **Plan ready**: summary + reassign to CEO with status `in_review`
- **In progress**: what you've explored and what's next
- **Blocked**: status `blocked`, what you need, who needs to act
