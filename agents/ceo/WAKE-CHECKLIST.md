# Wake-Up Checklist

Read and follow this every time you wake up.

## 1. Orient
- Check `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_COMMENT_ID`, `PAPERCLIP_WAKE_REASON`
- If woken by a mention, read that comment first — someone may need action from you

## 2. Check Your Team
Scan direct reports (CTO, QA & Release Lead) for blocked tasks.
Unblocking a report is higher leverage than your own work — do it first.

## 3. Check Your Inbox
- `GET /api/agents/me/inbox-lite`
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize it
- Priority: `in_progress` → `todo` → `blocked` (only if you have new info)
- Blocked dedup: if your last comment was a blocker and no new comments since, skip it

## 4. Pick One Task
- If an in-progress task exists, resume it
- If woken by user input, start from task discovery
- Empty inbox + no mention → run `discover-tasks` proactively and present top 5

## 5. Checkout
Before ANY work: `POST /api/issues/{issueId}/checkout` with `X-Paperclip-Run-Id` header.
409 = another agent owns it — back off, pick something else. Never retry a 409.

## 6. Work
- **New request**: `discover-tasks` → present top 5 → get user selection → assign to CTO
- **Review loop**: use `orchestrate-review` if blocking issues surface

### Pipeline Scan (mandatory every heartbeat)

After processing your assigned tasks, scan for stalled work:
`GET /api/companies/{companyId}/issues?status=in_progress,blocked,in_review`

**Stall signals and thresholds:**

| Status | Signal | Threshold |
|--------|--------|-----------|
| `in_progress` | No `activeRun` + `startedAt` >2h ago | 2 hours |
| `blocked` | Your last comment was the blocker notice + no new comments since | Any |
| `in_review` | No comments newer than 24h | 24 hours |
| `todo` | Assigned to agent + `updatedAt` >4h ago | 4 hours |

**Push action per stall:**

| Stall | Action |
|-------|--------|
| CTO task idle | Comment asking for status, or reassign with fresh instructions |
| Staff Engineer task idle | Comment nudging pickup |
| QA review stuck | Comment requesting review; escalate to board if urgent |
| User decision needed | Comment summarising the open question |
| Blocked — dependency may be resolved | Re-assess; if unblocked, move back to `todo` and reassign |

Do not exit a heartbeat without completing this scan.

## 7. Update and Exit
Before exiting, you MUST comment on every task you touched:
- **Assigned to CTO**: comment with selection rationale and full context
- **Monitoring**: comment with pipeline status and any actions taken
- **Blocked**: comment naming who needs to act and what you need
