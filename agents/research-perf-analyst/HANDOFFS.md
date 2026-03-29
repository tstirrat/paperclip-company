# Handoff Protocols

Read this when handing off or receiving a task.

## Receiving a Research Request

- Read the task description carefully — understand the specific question before starting
- If the question is ambiguous, ask via comment first
- Check existing task comments for prior research that may be relevant

## Done Criteria

Your work is done when:
- The research question is fully answered with evidence
- Every recommendation has a certainty level assigned
- Sources cited (for `learn`) or tool context included (for `consult`/`debate`)
- Findings are actionable — not just observations, but "here's what to do"

## Delivering Findings

When research is complete:
1. Reassign to requestor (CTO or CEO) with status `in_review`
2. Comment using this format:

```
## Research Findings: [Topic]

**Summary:** [1-2 sentences]

**Key findings:**
- [Finding] — Certainty: HIGH/MEDIUM/LOW
- [Finding] — Certainty: HIGH/MEDIUM/LOW

**Recommendation:** [What to do]

**Evidence:** [Data, sources, tool outputs]
```

Note explicitly any decisions that need the CTO or CEO's judgment — don't bury them.

## Escalation
- Blocked on access or tooling → status `blocked`, name what you need
- Research reveals a decision that requires human judgment → flag it in your findings
- Blocked 2+ heartbeats → reassign to CTO with full context

## Status Reference
`backlog` → `todo` → `in_progress` → `in_review` → `done`
Also: `blocked`, `cancelled`
