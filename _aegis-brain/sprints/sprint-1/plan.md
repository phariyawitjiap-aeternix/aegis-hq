# Sprint 1 Plan

## Sprint Info

| Field | Value |
|-------|-------|
| Sprint | sprint-1 |
| Start | 2026-03-24 |
| End | 2026-04-04 (2 weeks) |
| Capacity | 28 pts (first sprint, default 20 * 1.4 stretch) |
| Committed | 27 pts |
| Load | 96% |
| Carry-over | 0 tasks (first sprint) |

## Sprint Goal

**Fix the foundation**: Make the installer, PM state system, gate enforcement, and
Mother Brain planning flow actually work so AEGIS can dogfood itself reliably.
This sprint addresses the CRITICAL and HIGH severity findings from the Havoc review
that block basic usability.

## Selected Tasks

| ID | Title | Pts | Type | Assignee | Priority | Dependencies |
|----|-------|-----|------|----------|----------|--------------|
| PROJ-T-001 | install.sh copies ALL v7.1 files including PM state files | 3 | impl | @bolt | critical | blocks T-003 |
| PROJ-T-002 | install.sh creates ALL directories including tasks/ | 2 | impl | @bolt | critical | blocks T-003 |
| PROJ-T-003 | Post-install verification command (/aegis-doctor) | 5 | impl | @bolt | high | blocked by T-001, T-002 |
| PROJ-T-004 | Mother Brain follows planning-before-build in practice | 5 | impl | @sage | high | blocks T-005 |
| PROJ-T-007 | Gate enforcement blocks kanban transitions | 3 | impl | @bolt | high | blocks T-008 |
| PROJ-T-010 | Sequential IDs work across all commands | 3 | impl | @bolt | high | blocks T-011 |
| PROJ-T-011 | Task history is append-only and consistent | 3 | impl | @bolt | high | blocked by T-010 |
| PROJ-T-013 | Sprint close computes velocity correctly | 3 | impl | @bolt | high | blocked by T-010 |

**Total: 8 tasks, 27 points**

## Agent Assignments

| Agent | Tasks | Points |
|-------|-------|--------|
| @bolt | T-001, T-002, T-003, T-007, T-010, T-011, T-013 | 22 |
| @sage | T-004 | 5 |

## Deferred to Sprint 2 (Backlog)

| ID | Title | Pts | Reason |
|----|-------|-----|--------|
| PROJ-T-005 | Multi-cycle within session (context budget aware) | 8 | Blocked by T-004, too large for sprint-1 |
| PROJ-T-006 | Cross-session continuity via handoff | 5 | Lower priority, no blockers in sprint-1 |
| PROJ-T-008 | Sentinel+Probe QA pipeline produces real reports | 5 | Blocked by T-007, will pull into sprint-2 |
| PROJ-T-009 | Scribe generates versioned ISO docs automatically | 5 | Medium priority, no sprint-1 dependencies |
| PROJ-T-012 | Dashboard shows real computed metrics | 5 | Blocked by T-010, T-011 |

## Execution Order (Recommended)

1. **Day 1-2**: T-001 + T-002 (installer fixes, unblocks T-003)
2. **Day 2-3**: T-010 (sequential IDs, unblocks T-011 and T-013)
3. **Day 3-5**: T-003 (aegis-doctor), T-011, T-013 (now unblocked)
4. **Day 4-6**: T-004 (sage: Mother Brain planning flow)
5. **Day 5-7**: T-007 (gate enforcement)
6. **Day 8-10**: Buffer + QA gates for all completed work

## Risks

1. T-003 (/aegis-doctor) is 5pts and depends on both T-001 and T-002 completing first
2. T-004 (Mother Brain) may surface additional architectural issues requiring scope change
3. First sprint -- no velocity history to calibrate against
