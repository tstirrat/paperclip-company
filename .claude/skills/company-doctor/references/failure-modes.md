# Common Failure Modes and Fixes

A catalog of coordination failures observed in Paperclip companies, their root
causes, and the instruction patterns that fix them.

## Table of Contents

1. [Task Dropping](#task-dropping)
2. [Task Trampling](#task-trampling)
3. [Work Duplication](#work-duplication)
4. [Handoff Gaps](#handoff-gaps)
5. [Blocked Task Spirals](#blocked-task-spirals)
6. [Context Amnesia](#context-amnesia)
7. [Scope Creep Between Agents](#scope-creep-between-agents)
8. [Silent Exit](#silent-exit)
9. [Manager Bottleneck](#manager-bottleneck)

---

## Task Dropping

**Symptom:** Tasks sit in `todo` or `in_progress` with no activity. No agent
picks them up. Work stalls silently.

**Root cause:** Agents don't have a heartbeat procedure that tells them to
check their inbox and act on assigned work. They wake up, don't see explicit
direction in the wake context, and exit without doing anything.

**Fix:**
- Add WAKE-CHECKLIST.md with explicit "Check Your Inbox" step
- Include the prioritization rule: in_progress first, then todo, then blocked-if-unblockable
- Add the rule: "If you have assigned work, you must make progress on it. Exiting
  without touching any assigned work is a failure mode."
- Ensure the agent knows that `GET /api/agents/me/inbox-lite` is how they
  find their work

**Key instruction to include:**
> Every heartbeat where you have assigned work, you must either make progress
> on a task or explicitly explain why you couldn't (blocked, out of budget,
> waiting on someone). Waking up and exiting without touching your work is
> never acceptable unless your inbox is empty.

---

## Task Trampling

**Symptom:** Two agents work on the same task simultaneously. One agent's
work overwrites another's. Merge conflicts, wasted budget.

**Root cause:** Agents don't understand the checkout mechanism, or they skip
it and go straight to working. The 409 Conflict response isn't handled —
agents either retry (wrong) or don't attempt checkout at all.

**Fix:**
- WAKE-CHECKLIST.md must include checkout as a mandatory step before any work
- Explicitly state: "If you get a 409, that task belongs to another agent.
  Do not retry. Do not work on it anyway. Pick a different task."
- Add boundary awareness: "If a task is assigned to another agent, it's
  their job — even if you think you could do it better or faster."

---

## Work Duplication

**Symptom:** Multiple agents independently produce similar work product.
An engineer and a CTO both write code for the same feature. A PM and a
CEO both create the same project plan.

**Root cause:** Agents don't know what other agents do. They see a task
that seems relevant to their skills and jump in, not realizing another
agent's role covers it.

**Fix:**
- Include the full org chart in every agent's AGENTS.md
- Add explicit "Not your lane" boundaries
- For each agent, name the specific agents whose work they should not
  duplicate: "Code implementation is {Engineer}'s job. You review code,
  you don't write it (unless the task explicitly asks you to)."

---

## Handoff Gaps

**Symptom:** Agent A finishes their part but doesn't tell Agent B.
Agent B never picks up because they were never notified. Task sits in
limbo — technically "done" by A but not progressing.

**Root cause:** Agents don't have handoff patterns. They mark tasks as
"done" from their perspective but don't reassign to the next person in
the workflow.

**Fix:**
- Define explicit handoff steps in the agent's workflow section
- "When you're done" must include not just status update but reassignment:
  "Reassign to {next agent} with status in_review and a comment explaining
  what you did."
- The comment should give the next agent everything they need to start
  without re-reading the whole thread.

**Key instruction to include:**
> Marking a task "done" without handing off to the next person is the same
> as dropping it. Your job isn't done until the right person has been notified
> and the task is in their inbox.

---

## Blocked Task Spirals

**Symptom:** A task is marked `blocked`. Every heartbeat, the agent
re-checks it, posts another "still blocked" comment, and exits. The
comment thread grows but nothing happens.

**Root cause:** The agent doesn't have the blocked-task dedup rule, or
doesn't know when to escalate vs wait.

**Fix:**
- Include the dedup rule: "If your last comment was a blocker update and
  no new comments have been posted since, skip the task. Don't repeat yourself."
- Include escalation guidance: "If a task has been blocked for more than
  2 heartbeats with no new context, escalate to your manager. Don't just
  keep waiting."
- The Paperclip skill already covers the dedup rule — make sure the agent's
  WAKE-CHECKLIST.md reinforces it.

---

## Context Amnesia

**Symptom:** Agent starts each heartbeat as if it's never seen the task
before. Re-reads everything. Makes the same analysis. Sometimes contradicts
its own previous work. Wastes budget on redundant context-loading.

**Root cause:** Agent doesn't know about session continuity or how to use
incremental context loading.

**Fix:**
- WAKE-CHECKLIST.md should include: "If you already have context from a previous
  heartbeat on this task, just check for new comments since your last
  activity. Don't reload everything."
- Point to `GET /api/issues/{issueId}/comments?after={last-comment-id}`
  for incremental updates
- Mention that `GET /api/issues/{issueId}/heartbeat-context` gives compact
  context without full thread replay
- Suggest agents leave themselves breadcrumbs in comments: "Next heartbeat:
  continue with Y" so their future self knows where they left off.

---

## Scope Creep Between Agents

**Symptom:** A CTO starts implementing features instead of reviewing them.
An engineer starts making product decisions. A PM starts writing code.
Agents gradually drift into each other's responsibilities.

**Root cause:** Agents know what they *can* do (they have the technical
capability) but not what they *should* do (their organizational role).
Without boundaries, they default to "if I can do it, I should."

**Fix:**
- Explicit "Your lane" and "Not your lane" sections in AGENTS.md
- Name specific agents for responsibilities that are adjacent but separate
- The framing matters: "You have the skills to write code, but that's
  {Engineer}'s job in this organization. If a task needs implementation,
  delegate it — don't do it yourself. Your leverage comes from making
  technical decisions and reviewing work, not from writing code."

---

## Silent Exit

**Symptom:** Agent wakes up, does some work, and exits without updating
the task status or leaving a comment. From the outside, it looks like
nothing happened. Next heartbeat, the agent might redo the same work.

**Root cause:** Agent doesn't have the "always comment before exiting"
rule, or treats it as optional.

**Fix:**
- WAKE-CHECKLIST.md step 7 must be explicit: "Before exiting, you MUST leave
  a comment on every task you touched in this heartbeat."
- Frame it as: "Your comment is how the rest of the company knows you
  exist. If you exit without commenting, it's as if you never woke up.
  The next heartbeat (yours or someone else's) will waste time figuring
  out what happened."

---

## Manager Bottleneck

**Symptom:** All tasks flow through one manager agent. ICs are idle
because the manager hasn't processed their queue. The manager is
overwhelmed trying to both do IC work and manage.

**Root cause:** Manager agent doesn't have delegation patterns or doesn't
prioritize unblocking reports over their own IC work.

**Fix:**
- Manager's WAKE-CHECKLIST.md should include "Check Your Team" before "Pick
  Your Own Task": scan reports' blocked tasks first
- Explicit rule: "Unblocking a report has higher leverage than your own
  IC work. If someone on your team is blocked on something you can resolve,
  do that first."
- Delegation section: "If you find yourself doing IC work that a report
  could do, create a subtask and assign it to them instead."
- Make sure ICs know they can escalate directly to the manager when blocked,
  rather than waiting passively.
