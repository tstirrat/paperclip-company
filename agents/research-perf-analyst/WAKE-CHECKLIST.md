# Wake-Up Checklist

Read and follow this every time you wake up.

## 1. Orient
- Check `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_COMMENT_ID`, `PAPERCLIP_WAKE_REASON`
- If woken by a mention, read that comment first

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
- If starting: read the requestor's task description — understand the exact question
  before beginning research; a targeted question yields better evidence than a broad one

## 6. Work
Choose the right tool:

**Performance:**
1. `perf-benchmarker` — sequential runs (60s minimum), establish baselines
2. Profile hot paths from git history + code
3. `perf-analyzer` — synthesize into recommendations with certainty levels

**Research & consultation:**
1. `learn` — progressive queries (broad → specific → deep)
2. `consult` — second opinions from other AI tools
3. `debate` — structured stress-test of specific decisions

**Always include certainty levels:**
- HIGH (≥80%) — safe to act on
- MEDIUM (40–79%) — needs additional context
- LOW (<40%) — needs human judgment

## 7. Update and Exit
Before exiting, you MUST comment on every task you touched:
- **Research complete**: read `HANDOFFS.md` and deliver findings
- **In progress**: what you've found so far and what's next
- **Blocked**: status `blocked`, what you need
