# Handoff Protocol -- AEGIS v8.0

> Reference for: all team agents, Mother Brain, Navi
> Defines the standard format for passing work between teams.
> Every team transition MUST use a HandoffEnvelope.

---

## Purpose

When one team finishes work on a task, it does not simply change a status flag.
It creates a structured HandoffEnvelope that carries all context forward:
which artifacts were produced, which gates passed, and what the next team needs
to know. This prevents information loss between teams and creates an audit trail.

---

## HandoffEnvelope Schema

```json
{
  "id": "HO-{counter}",
  "timestamp": "ISO 8601 (e.g. 2026-03-25T14:30:00Z)",
  "from_team": "build|review|qa|compliance|devops",
  "to_team": "build|review|qa|compliance|devops",
  "task_id": "PROJ-T-NNN",
  "status": "READY_FOR_REVIEW|READY_FOR_QA|READY_FOR_COMPLIANCE|READY_FOR_DEPLOY|REJECTED",
  "artifacts": [
    "relative/path/to/artifact1.md",
    "relative/path/to/artifact2.ts"
  ],
  "gate_results": {
    "gate_1": "PASS|FAIL|PENDING",
    "gate_2": "PASS|FAIL|PENDING",
    "gate_3": "PASS|FAIL|PENDING"
  },
  "notes": "Free-text summary of what was done and what needs attention",
  "rejection_reason": "Required if status == REJECTED. Explains what failed and why."
}
```

### Field Details

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | string | Yes | Sequential ID: `HO-001`, `HO-002`, etc. Counter in `_aegis-brain/counters.json` |
| timestamp | string | Yes | ISO 8601 timestamp of when handoff was created |
| from_team | enum | Yes | Team that completed work. One of: build, review, qa, compliance, devops |
| to_team | enum | Yes | Team receiving work. Must be valid per routing table |
| task_id | string | Yes | Task ID in `PROJ-T-NNN` format (per pm-state-protocol.md) |
| status | enum | Yes | Handoff status. Determines what the receiving team should do |
| artifacts | array | Yes | List of file paths (relative to project root) produced by the sending team |
| gate_results | object | Yes | Current state of all gates. PENDING = not yet evaluated |
| notes | string | No | Optional context for the receiving team |
| rejection_reason | string | Conditional | Required when status is REJECTED. Must explain what failed |

---

## Status Values

| Status | Meaning | From | To |
|--------|---------|------|----|
| READY_FOR_REVIEW | Code complete, needs review | build | review (or build-internal Vigil) |
| READY_FOR_QA | Review passed, needs QA | build/review | qa |
| READY_FOR_COMPLIANCE | QA passed, needs ISO doc check | qa | compliance |
| READY_FOR_DEPLOY | All gates passed, ready to deploy | compliance | devops |
| REJECTED | Work failed a gate, needs rework | any | build (usually) |

---

## Routing Table

### Valid Handoff Routes

```
BUILD ──────> REVIEW          (code ready for review)
BUILD ──────> QA              (if review is build-internal Vigil)
BUILD ──────> BUILD           (self-fix after rejection)

REVIEW ─────> QA              (review approved)
REVIEW ─────> BUILD           (review rejected -- rework needed)

QA ─────────> COMPLIANCE      (QA approved)
QA ─────────> BUILD           (QA rejected -- bugs found)

COMPLIANCE ──> DEVOPS         (all docs current, deploy-ready)
COMPLIANCE ──> BUILD          (missing docs that need code changes)

DEVOPS ──────> MONITOR        (deploy succeeded, enter monitoring)
DEVOPS ──────> BUILD          (hotfix needed after deploy failure)

MONITOR ─────> BACKLOG        (new issues found in production)
```

### Route Validation Matrix

| From \ To | Build | Review | QA | Compliance | DevOps | Monitor | Backlog |
|-----------|-------|--------|-----|------------|--------|---------|---------|
| Build | self-fix | yes | yes | -- | -- | -- | -- |
| Review | reject | -- | approve | -- | -- | -- | -- |
| QA | reject | -- | -- | approve | -- | -- | -- |
| Compliance | missing docs | -- | -- | -- | approve | -- | -- |
| DevOps | hotfix | -- | -- | -- | -- | deploy ok | -- |
| Monitor | -- | -- | -- | -- | -- | -- | new issue |

**Rule**: Any handoff to a route not in this table is INVALID and must be rejected
by the receiving team.

---

## Storage

Handoff envelopes are stored as JSON files:

```
_aegis-brain/handoffs/HO-001.json
_aegis-brain/handoffs/HO-002.json
_aegis-brain/handoffs/HO-NNN.json
```

### Counter Management

The handoff counter is stored in `_aegis-brain/counters.json` under a new key:

```json
{
  "project_key": "PROJ",
  "counters": {
    "US": 0,
    "J": 0,
    "E": 0,
    "T": 0,
    "ST": 0,
    "DOC": 0,
    "HO": 0
  },
  "last_updated": "2026-03-25T10:00:00Z"
}
```

To create a handoff:
1. Read `_aegis-brain/counters.json`
2. Increment `counters.HO`
3. Write updated counters.json
4. Derive ID: `HO-{NNN}` (zero-padded to 3 digits)
5. Write envelope to `_aegis-brain/handoffs/HO-{NNN}.json`
6. Log to `_aegis-brain/logs/activity.log`

---

## Creating a Handoff

### Protocol Steps

1. **Validate route**: Check the routing table. If the from_team -> to_team route
   is not valid, ABORT and log an error.

2. **Collect artifacts**: List all files produced during this stage for this task.
   Verify each file exists. If any artifact is missing, ABORT.

3. **Evaluate gate**: If this handoff crosses a gate boundary, record the gate result.
   - Build -> Review/QA boundary: Gate 1 must be evaluated
   - QA -> Compliance boundary: Gate 2 must be evaluated
   - Compliance -> DevOps boundary: Gate 3 must be evaluated

4. **Create envelope**: Populate all fields per the schema above.

5. **Write envelope**: Save to `_aegis-brain/handoffs/HO-{NNN}.json`.

6. **Update task**: Record the handoff in the task's history.md:
   ```
   | {timestamp} | {agent} | HANDOFF | {from_status} | {to_status} | HO-{NNN}: {from_team} -> {to_team} |
   ```

7. **Update task status**: Change meta.json status per the pipeline stage mapping
   (see sdlc-pipeline.md Status Mapping table).

8. **Notify receiving team**: The receiving team reads the handoff envelope to know
   what work is waiting and what context is available.

---

## Handling Rejections

When a gate fails (FAIL verdict), the sending team creates a REJECTED handoff:

```json
{
  "id": "HO-015",
  "timestamp": "2026-03-25T16:00:00Z",
  "from_team": "qa",
  "to_team": "build",
  "task_id": "PROJ-T-042",
  "status": "REJECTED",
  "artifacts": [
    "_aegis-output/qa/sprint-1/qa-report-PROJ-T-042.md",
    "_aegis-output/qa/sprint-1/raw-results-PROJ-T-042.md"
  ],
  "gate_results": {
    "gate_1": "PASS",
    "gate_2": "FAIL",
    "gate_3": "PENDING"
  },
  "notes": "3 test failures in edge case handling. See qa-report for details.",
  "rejection_reason": "Gate 2 FAIL: 2 P0 tests failing (auth timeout, null input). Overall pass rate 91% (threshold: 95%)."
}
```

### Rejection Rules

1. The rejection_reason field MUST be specific enough for the Build team to act on
   without reading every artifact. Include: which gate failed, how many failures,
   and the top issues.

2. The task status is moved back to IN_PROGRESS (per pm-state-protocol.md transitions).

3. The rejection is recorded in the task's history.md as a GATE_FAIL entry.

4. Findings are appended to the task's comments.md so the Build team can see them
   directly in the task context.

5. The Build team reads the REJECTED handoff, fixes the issues, then creates a new
   handoff (with a new HO-NNN ID) back to the team that rejected.

---

## Example: Full Task Lifecycle Handoffs

```
HO-010: build -> build-internal (READY_FOR_REVIEW)
  Vigil reviews Bolt's code
  Gate 1: PASS

HO-011: build -> qa (READY_FOR_QA)
  Sentinel receives code + review report
  Gate 1: PASS, Gate 2: PENDING

HO-012: qa -> build (REJECTED)
  Sentinel finds 2 P0 test failures
  Gate 2: FAIL
  rejection_reason: "2 P0 failures in auth module"

  [Bolt fixes issues]

HO-013: build -> qa (READY_FOR_QA)
  Sentinel re-tests
  Gate 1: PASS (carried forward), Gate 2: PENDING

HO-014: qa -> compliance (READY_FOR_COMPLIANCE)
  Scribe checks ISO docs
  Gate 1: PASS, Gate 2: PASS, Gate 3: PENDING

HO-015: compliance -> devops (READY_FOR_DEPLOY)
  Ops deploys
  Gate 1: PASS, Gate 2: PASS, Gate 3: PASS
```

---

## Querying Handoffs

To find all handoffs for a task:

```bash
# All handoffs for PROJ-T-042
grep -l '"task_id": "PROJ-T-042"' _aegis-brain/handoffs/*.json
```

To find all rejected handoffs:

```bash
grep -l '"status": "REJECTED"' _aegis-brain/handoffs/*.json
```

To find the latest handoff:

```bash
ls -t _aegis-brain/handoffs/*.json | head -1
```

---

## Gate-to-Handoff Mapping

| Gate | Triggered At Handoff | From | To | Pass Status | Fail Status |
|------|---------------------|------|-----|-------------|-------------|
| G1 (Code Review) | Build -> QA | build | qa | READY_FOR_QA | REJECTED (to build) |
| G2 (QA Verdict) | QA -> Compliance | qa | compliance | READY_FOR_COMPLIANCE | REJECTED (to build) |
| G3 (Compliance) | Compliance -> DevOps | compliance | devops | READY_FOR_DEPLOY | REJECTED (to build) |
| G4 (Deploy Health) | Deploy -> Monitor | devops | monitor | (internal) | Rollback + REJECTED (to build) |
| G5 (Post-Deploy) | Monitor -> Stable | devops | -- | Pipeline complete | Hotfix to backlog |

---

## Integration with PM State Protocol

Handoffs integrate with the existing task lifecycle:

- **meta.json**: Task status is updated when a handoff changes the pipeline stage
- **history.md**: Every handoff is recorded as a HANDOFF action entry
- **comments.md**: Rejection findings are appended as comments
- **metrics.json**: Sprint metrics are recomputed after status changes
- **kanban.md**: Kanban board is regenerated after status changes

The handoff envelope is an ADDITION to the existing protocol, not a replacement.
The meta.json status field remains the source of truth for task state. The handoff
envelope carries the context that explains WHY the status changed.

---

## Cross-References

- Pipeline stages and flow: `sdlc-pipeline.md`
- Task lifecycle and meta.json: `pm-state-protocol.md`
- Agent definitions: `.claude/agents/*.md`
- Handoff storage: `_aegis-brain/handoffs/`
- Counter management: `_aegis-brain/counters.json`
