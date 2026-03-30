---
name: company-doctor
description: >
  Diagnose and fix agent coordination problems in Paperclip company packages.
  Reads a company folder (agentcompanies/v1 format), analyzes each agent's
  instructions for role overlap, missing heartbeat procedures, weak boundaries,
  poor handoff patterns, and suboptimal model selection, then rewrites the
  agent instruction bundles and .paperclip.yaml so agents stop dropping tasks,
  stop stepping on each other, and operate autonomously with minimal human
  pushing. ONLY invoke when the user explicitly requests it — e.g. "/company-doctor",
  "run company doctor", or "diagnose/fix this company package". This is a heavy,
  multi-step diagnostic tool. Do NOT auto-trigger on general agent complaints,
  keywords, or tangentially related questions.
---

# Company Doctor

Diagnose and fix coordination failures in Paperclip company packages.

You operate on a **folder of files** — the agentcompanies/v1 package format
(COMPANY.md, agents/*/AGENTS.md, .paperclip.yaml, etc.). You read the package,
diagnose problems, and rewrite the files. No Paperclip API needed.

## Why This Exists

When companies are created from packages or templates, agents often get
instructions that describe *what* they do but not *how* to operate in the
Paperclip runtime. A typical agent gets something like:

> "You are the CTO. You lead the engineering team and make technical decisions."

That's a job description, not operating instructions. Without guidance on the
heartbeat execution model, task ownership, handoff patterns, and role
boundaries, agents:

- **Step on each other** — the CEO writes code, the CTO creates strategy,
  the engineer makes architectural decisions. Everyone does everyone's job
  because nobody told them not to.
- **Drop tasks** — agents wake up, don't know how to find or prioritize
  their work, and exit without making progress.
- **Duplicate effort** — two agents independently produce similar work because
  neither knows the other's role.
- **Stall out** — tasks sit in limbo because agents don't know how to hand
  off or escalate.

The fix is giving each agent clear, role-specific operating instructions that
include the Paperclip runtime model, their org position, concrete boundaries,
and explicit handoff patterns.

## Process

### Step 1 — Read the Package

Read the company folder. You need:

1. **COMPANY.md** — company name, description, goals
2. **agents/\*/AGENTS.md** — every agent's definition and instructions
3. **.paperclip.yaml** — adapter types, model selections, env inputs
4. **teams/\*/TEAM.md** — team structure (if present)
5. **skills/\*/SKILL.md** — custom skills (if present)
6. **README.md** — often has workflow/pipeline documentation

Build a mental model of:
- The org chart (who reports to whom)
- The intended workflow (how work flows through the company)
- Each agent's intended role and responsibilities
- Which skills each agent has
- Current model assignments

### Step 2 — Diagnose

Score each agent against the **Agent Readiness Checklist**:

| Category | What good looks like |
|---|---|
| **Heartbeat procedure** | Agent has a step-by-step checklist for each execution window: orient → inbox → pick task → checkout → context → work → update → exit |
| **Org awareness** | Agent knows the full company structure, their position, their manager, their peers, and their reports by name |
| **Role boundaries** | Agent has explicit "your lane" and "not your lane" sections that name specific other agents |
| **Task ownership** | Agent knows to checkout before working, never retry 409, never grab unassigned work |
| **Handoff patterns** | Agent knows exactly who to hand off to, what status to set, and what context to include in the handoff comment |
| **Done criteria** | Agent has concrete, role-specific definition of "done" — not just "task complete" but "handed off to {name} with {context}" |
| **Session continuity** | Agent knows how to resume across heartbeats without reloading everything |
| **Escalation path** | Agent knows when to escalate (vs spin) and who to escalate to |
| **Model fit** | Agent's model matches their cognitive demands (see Model Selection below) |

Present a diagnostic table:

```
Agent              | Heartbeat | Org  | Bounds | Handoff | Done   | Model
───────────────────┼───────────┼──────┼────────┼─────────┼────────┼──────
CEO                | THIN      | OK   | MISSING| THIN    | MISSING| OK
CTO                | MISSING   | THIN | MISSING| THIN    | MISSING| OVER
Staff Engineer     | MISSING   | NONE | MISSING| OK      | OK     | OVER
```

Ratings:
- **OK** — adequately covered
- **THIN** — present but insufficient for autonomous operation
- **MISSING** — not addressed
- **OVER** — model is more expensive than needed for this role

After the table, explain the impact in plain language. "Your Staff Engineer
has no heartbeat procedure and no boundaries section, so it doesn't know how
to prioritize work when it wakes up and it's likely to drift into creating
plans (the CTO's job) instead of just executing them."

Also diagnose **role overlap**: look for agents whose instructions describe
responsibilities that belong to another agent. This is the #1 cause of agents
stepping on each other. Common overlaps:
- CEO doing implementation work (engineer's job)
- CTO doing strategy/prioritization (CEO's job)
- Engineers creating plans or making architectural decisions (CTO's job)
- QA agents doing implementation fixes (engineer's job)

### Step 3 — Generate Improved Instructions

For each agent that needs improvement, rewrite their instruction bundle.
Each agent gets up to four files inside their `agents/<slug>/` directory:

1. **AGENTS.md** — identity, org position, workflow, boundaries, pointers to supporting files
2. **WAKE-CHECKLIST.md** — step-by-step wake-up procedure (orient → inbox → checkout → work → exit)
3. **HANDOFFS.md** — done criteria, handoff protocols, escalation paths
4. **SOUL.md** — persona and decision-making style (optional, for leadership roles)

Also update **.paperclip.yaml** with model recommendations.

Read `references/instruction-patterns.md` for templates and patterns.
Read `references/failure-modes.md` to understand which patterns fix which problems.
Read `references/runtime-model.md` for Paperclip runtime concepts (heartbeats, checkout,
inbox, env vars) to encode accurately in agent instructions.

#### Progressive Disclosure

Agent instructions should use progressive disclosure — keep the always-loaded
entry file (AGENTS.md) lean and push procedural details into supporting files
that the agent reads on demand. This matters because every token in AGENTS.md
competes with task context for the agent's attention window, especially on
Sonnet and Haiku.

**File structure per agent:**

```
agents/<slug>/
├── AGENTS.md           ← Always loaded. Identity, org chart, boundaries,
│                         and pointers to supporting files. Target: 40-60 lines.
├── WAKE-CHECKLIST.md   ← Read at the start of every wake-up. Step-by-step
│                         orient → inbox → checkout → work → exit procedure.
│                         Target: 30-40 lines.
└── HANDOFFS.md         ← Read when handing off or receiving work. Done
                          criteria, status transitions, handoff protocols.
                          Target: 20-30 lines.
```

**AGENTS.md must include pointers** so the agent knows when to read each file:

```markdown
## Operating Procedures

- **Every wake-up**: Read and follow `WAKE-CHECKLIST.md`
- **Handing off work or marking done**: Read `HANDOFFS.md`
- **When blocked or escalating**: See escalation section in `HANDOFFS.md`
- **API mechanics (checkout, comments, headers)**: Use the Paperclip skill
```

This way a mid-task heartbeat (resuming code from last wake) loads AGENTS.md
(lean identity + boundaries) and WAKE-CHECKLIST.md (orient and pick up where
you left off), but skips HANDOFFS.md until it's actually time to hand off.

The Heartbeat Dispatcher is an exception — its instructions are simple enough
to fit in a single AGENTS.md with no supporting files.

#### Writing Principles

**Explain the why.** "Always checkout before working" is a rule. "Checkout
prevents two agents from working the same task, which wastes budget and
creates merge conflicts" is understanding. Agents with understanding handle
edge cases better.

**Be specific to the role.** Don't paste the same wake checklist for everyone.
A manager's checklist includes checking their team's blockers before doing
their own work. An IC's is simpler: inbox → pick task → work → exit.

**Name every agent.** "Hand off to the CTO for review" is actionable. "Hand off
to your manager" is vague. Use actual names and roles from the org chart.

**Include the org chart in every agent's AGENTS.md.** Every agent should see the
full company structure with their position marked. Agents who can see the org
chart naturally stay in their lane.

**Define "done" concretely per role.** For an engineer: "Code committed, tests
passing, task reassigned to {QA agent name} with status `in_review` and a
comment explaining what was built." For a CTO: "Implementation plan documented
in the issue's plan document, task reassigned to {engineer name} with status
`todo`." Put these in HANDOFFS.md, not AGENTS.md.

**Keep each file focused and concise.** AGENTS.md: identity and boundaries.
WAKE-CHECKLIST.md: what to do when you wake up. HANDOFFS.md: what to do when
passing or receiving work. No file should exceed 60 lines.

**Enforce strict separation.** The most common failure is agents doing each
other's jobs. For each agent, include explicit "not your lane" items that name
what belongs to other agents. Frame it positively — "Your leverage comes from
{your specialty}, not from {other agent's job}" — so the agent understands
why the boundary exists, not just that it's a rule.

**Don't duplicate the Paperclip skill.** The Paperclip skill covers API
mechanics (checkout endpoints, comment format, header requirements). Your
instructions cover behavioral patterns — when and why to use those APIs.
Reference the Paperclip skill: "Use the Paperclip skill for API details."

### Step 4 — Model Selection

Right-size model assignments in .paperclip.yaml. The principle: **match
cognitive demand to model capability.** Expensive models on simple tasks waste
money. Cheap models on complex tasks produce poor results.

Guidelines:

| Role pattern | Recommended model | Why |
|---|---|---|
| **Dispatcher / Router** — agent whose job is to read tasks and assign them to other agents | `claude-haiku-4-5` | Low cognitive demand: read task, pick assignee, write comment. Haiku is fast and cheap. |
| **Planner / Architect** — agent who analyzes codebases, designs solutions, creates implementation plans | `claude-opus-4-6` | High cognitive demand: needs deep reasoning, multi-file analysis, architectural judgment. |
| **Executor / Implementer** — agent who follows a detailed plan to write code | `claude-sonnet-4-6` | Medium cognitive demand: the hard thinking was done in the plan. Sonnet executes well with good instructions. |
| **Reviewer / QA** — agent who reviews code, runs checks, validates quality | `claude-sonnet-4-6` | Medium cognitive demand: pattern matching, checklist execution. Sonnet handles this well. |
| **Researcher** — agent who does deep analysis, benchmarking, or investigation | `claude-opus-4-6` | High cognitive demand: synthesis, judgment, novel analysis. |
| **CEO (when mostly dispatching)** — if CEO's main job is prioritizing and delegating | `claude-sonnet-4-6` or `claude-haiku-4-5` | If the CEO is just triaging and assigning, it's dispatch work. Don't put Opus on a dispatcher. |
| **CEO (when doing strategy)** — if CEO does substantive strategic thinking | `claude-opus-4-6` | Real strategy needs Opus-level reasoning. |

When an agent's role is too broad (dispatching AND planning AND strategy),
that's often a signal the role should be split or the boundaries should be
tightened so the expensive work is isolated to the agent that needs it.

Present model recommendations as part of the diagnosis:
```
Agent           | Current Model    | Recommended    | Reason
────────────────┼──────────────────┼────────────────┼────────
CEO             | opus             | sonnet/haiku   | Mostly dispatching — doesn't need opus
CTO             | opus             | opus           | Planning and architecture — needs deep reasoning
Staff Engineer  | opus             | sonnet         | Executing pre-approved plans — sonnet is sufficient
QA Release Lead | sonnet           | sonnet         | Review and validation — sonnet is correct
```

### Step 4b — Heartbeat Dispatcher Pattern

Timer-based heartbeats are the biggest source of wasted tokens in Paperclip
companies. Most heartbeats for most agents are empty — the agent wakes up,
checks its inbox, finds nothing, and exits. That's 2-5K tokens burned per
empty wake, per agent, every interval.

**The fix: disable timer heartbeats for all agents except a dedicated
Heartbeat Dispatcher.**

The Heartbeat Dispatcher is a lightweight agent on `claude-haiku-4-5` whose
sole job is to scan for stalled work and nudge the right agents. All other
agents wake only on assignment or @-mention — they never wake on a timer.

**Always recommend this pattern** when tuning a company. If the company
doesn't already have a dispatcher, recommend adding one. If it has a CEO
acting as dispatcher, recommend splitting dispatch duties into a dedicated
agent so the CEO isn't burning tokens on empty inbox checks.

**Important distinction:** The Heartbeat Dispatcher is NOT the agent humans
send requests to. Humans interact with the CEO (or whichever agent is the
human-facing entry point). The dispatcher is an internal operations agent
that humans rarely interact with directly.

#### What to generate

Add `agents/heartbeat-dispatcher/AGENTS.md` to the company package.
See `references/instruction-patterns.md` for the full template.

Key properties:
- **Model**: `claude-haiku-4-5` (cheapest possible — this is mechanical work)
- **Reports to**: CEO (or top-level manager)
- **Skills**: `paperclip` only
- **Timer**: ON (e.g., every 5 minutes) — this is the ONLY agent with a timer
- **No domain skills** — the dispatcher never does actual work, only pushes tasks

Update `.paperclip.yaml` to include the dispatcher with Haiku and to
document that all other agents should have timers disabled.

#### What to configure for other agents

In the diagnosis and recommendations, note:
- All other agents: heartbeat timer OFF, wake on assignment ON, wake on
  mention ON
- This is a runtime configuration (set in Paperclip UI after import), not
  something stored in the package files
- **You MUST document this in COMPANY.md or README.md** with a clear
  "Runtime Configuration" section stating: "After import, enable timer
  heartbeats ONLY for the Heartbeat Dispatcher. All other agents should
  have timers disabled and wake on assignment/mention only."
- Also add a note in each non-dispatcher agent's AGENTS.md: "You do not
  have a timer heartbeat. You wake only when a task is assigned to you or
  someone @-mentions you."

### Step 5 — Present Changes

Show the user what you propose to change. For each agent:

1. A brief summary of what's changing and why
2. The full rewritten AGENTS.md
3. The new WAKE-CHECKLIST.md and HANDOFFS.md
4. Model change (if any) in .paperclip.yaml

Wait for the user to review and approve. They know their domain better than
you — they may want to adjust role boundaries, add domain-specific context,
or override model recommendations.

### Step 6 — Write Files

Once approved, write the improved files back to the package folder:
- `agents/<slug>/AGENTS.md` — rewritten (lean: identity, org chart, boundaries, pointers)
- `agents/<slug>/WAKE-CHECKLIST.md` — new (step-by-step wake-up procedure)
- `agents/<slug>/HANDOFFS.md` — new (done criteria, handoff protocols, escalation)
- `agents/<slug>/SOUL.md` — new (leadership roles only, if warranted)
- `agents/heartbeat-dispatcher/AGENTS.md` — new dispatcher agent (if added)
- `.paperclip.yaml` — updated model selections and dispatcher entry

**YAML warning:** Do not add inline comments to `.paperclip.yaml` (e.g. `model: claude-sonnet-4-6  # reason`). The Paperclip YAML parser rejects them. Write clean YAML with no comments. Model rationale belongs in the diagnostic output to the user, not in the file.

Preserve anything you didn't change (skills/, projects/, tasks/, COMPANY.md,
README.md, etc.) unless the user asks you to update those too.

## Quick Mode

If the user says "just fix it" or "tune everything", skip interactive approval.
Diagnose, rewrite all agents, update models, write files, and show a summary
of what changed.

## References

| When... | Read |
|---|---|
| Generating instruction content for agents | `references/instruction-patterns.md` |
| Understanding failure modes and their fixes | `references/failure-modes.md` |
| Writing runtime concepts into agent instructions | `references/runtime-model.md` |
