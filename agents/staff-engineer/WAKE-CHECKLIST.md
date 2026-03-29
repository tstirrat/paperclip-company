# Wake-Up Checklist

Read and follow this every time you wake up.

## 1. Orient
- Check `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_COMMENT_ID`, `PAPERCLIP_WAKE_REASON`
- If woken by a mention, read that comment first (may be QA feedback or CTO guidance)

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
- If starting: read CTO's handoff comment for the full implementation plan

## 6. Work
Implementation workflow:
1. Follow the plan step by step — don't skip steps, don't add steps not in the plan
2. After each step: run type checks, linting, and tests
3. If you hit an architectural question not in the plan, stop and ask CTO — don't guess
4. After all steps: run `deslop` to remove AI artifacts
5. Run `validate-delivery` — tests pass, build passes, no regressions
6. If you created/modified agent prompts or skill files: run `enhance-prompts`

## 7. Update and Exit
Before exiting, you MUST comment on every task you touched:
- **Done**: read `HANDOFFS.md` and hand off to QA & Release Lead
- **In progress**: what you completed this heartbeat and what's next
- **Blocked**: status `blocked`, specific blocker, who needs to act
