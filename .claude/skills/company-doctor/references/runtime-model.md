# The Paperclip Runtime Model

Core runtime concepts to encode in agent instructions. Reference this when
writing agent instruction bundles in Step 3 of the company-doctor process.

## Heartbeats

Agents don't run continuously. They execute in **heartbeats** — short execution
windows triggered by Paperclip. Each heartbeat, the agent wakes up, does work,
and exits. Heartbeats are triggered by:

- **Assignment**: a task was assigned to the agent
- **Timer**: the agent has a scheduled interval (e.g., every 5 minutes)
- **Mention**: someone @-mentioned the agent in a comment
- **On-demand**: the board manually woke the agent

Each heartbeat costs budget (tokens = money). Wasted heartbeats — waking up
and doing nothing, redoing work, or doing someone else's job — burn budget
with no value.

## Tasks (Issues)

Work is tracked as **issues** with these statuses:
`backlog` → `todo` → `in_progress` → `in_review` → `done` (or `blocked`, `cancelled`)

Each issue has exactly **one assignee** (agent or human). Issues have a
`parentId` (for subtask hierarchy) and `goalId` (for company goal alignment).

## Checkout

Before working on a task, agents must **checkout** — an atomic claim that
prevents two agents from working the same task. If another agent already
owns a task, checkout returns `409 Conflict` — the agent must back off and
pick a different task. Never retry a 409.

## Inbox

Agents find their work by querying their inbox: assigned tasks filtered by
status. Priority order: `in_progress` first (resume what you started), then
`todo` (start new work), then `blocked` (only if you have new info to
unblock it).

## Environment Variables

Paperclip injects context via env vars:
- `PAPERCLIP_AGENT_ID`, `PAPERCLIP_COMPANY_ID` — identity
- `PAPERCLIP_RUN_ID` — current heartbeat run (include in API headers)
- `PAPERCLIP_TASK_ID` — the task that triggered this wake (if any)
- `PAPERCLIP_WAKE_REASON` — why this heartbeat was triggered
- `PAPERCLIP_WAKE_COMMENT_ID` — the comment that triggered this wake (if mention)

## The Paperclip Skill

Every agent should have the `paperclip` skill in their skills list. This skill
provides the API reference, comment formatting rules, and coordination protocol
details. The agent instructions you write should cover *behavioral patterns*
(when and why to do things), while the `paperclip` skill covers *API mechanics*
(how to call the endpoints).

## Comments and Communication

Agents communicate via issue comments. Comments should be concise markdown.
Ticket references must be wrapped in links: `[PAP-123](/PAP/issues/PAP-123)`.
Agents must comment on in-progress work before exiting a heartbeat — this is
how the rest of the company knows work is progressing.

## Budget

Agents have monthly budgets. Auto-paused at 100%. Above 80%, focus on critical
tasks only. @-mentions trigger heartbeats and cost budget — use sparingly.
