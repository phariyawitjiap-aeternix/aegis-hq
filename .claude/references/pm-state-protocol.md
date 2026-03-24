# PM State Protocol — Task Lifecycle Rules

> Reference for: aegis-breakdown, aegis-kanban, aegis-sprint, aegis-qa
> All commands that create or mutate tasks MUST follow this protocol.

---

## Creating a Task

1. Read `_aegis-brain/counters.json`. If the file does not exist, create it:
   ```json
   {
     "project_key": "PROJ",
     "counters": { "US": 0, "J": 0, "E": 0, "T": 0, "ST": 0, "DOC": 0 },
     "last_updated": "<current ISO 8601 timestamp>"
   }
   ```
2. Increment the appropriate counter:
   - User story    → `US`
   - Journey       → `J`
   - Epic          → `E`
   - Task          → `T`
   - Subtask       → `ST`
   - Document      → `DOC`
3. Write the updated `counters.json` with `last_updated` set to the current timestamp.
4. Derive the ID: `{project_key}-{TYPE}-{NNN}` where NNN is zero-padded to 3 digits.
   If the counter exceeds 999, extend to 4 digits automatically.
   Examples: `PROJ-T-001`, `PROJ-E-003`, `PROJ-US-012`, `PROJ-DOC-001`.
5. Create directory: `_aegis-brain/tasks/{ID}/`
6. Write `meta.json` (see schema below).
7. Write initial `history.md` with a CREATED entry.
8. Write empty `comments.md` with the header block.

---

## meta.json Schema

```json
{
  "id": "PROJ-T-001",
  "title": "string",
  "type": "user_story|journey|epic|task|subtask|doc",
  "task_type": "arch|impl|test|review|ui|doc|research|data",
  "parent": "PROJ-E-001 or null",
  "children": [],
  "status": "BACKLOG|TODO|IN_PROGRESS|IN_REVIEW|QA|DONE|BLOCKED|CANCELLED",
  "assignee": "agent_name or unassigned",
  "points": 3,
  "priority": "critical|high|medium|low",
  "labels": [],
  "dependencies": {
    "blocks": [],
    "blocked_by": []
  },
  "created": "2026-03-24T10:00:00",
  "updated": "2026-03-24T10:00:00",
  "sprint": null,
  "time_tracking": {
    "estimated_hours": null,
    "logged_hours": 0
  }
}
```

**Field notes:**
- `task_type` is only required when `type` is `task`.
- `parent` holds the direct parent ID. The full hierarchy is US → J → E → T → ST.
- `children` is populated on the parent when a child is created (bidirectional link).
- `points` must be a Fibonacci number: 1, 2, 3, 5, 8, or 13.
- Tasks created by `/aegis-breakdown` start with `status: "BACKLOG"`, `assignee: "unassigned"`, `sprint: null`.

---

## Valid Status Values and Transitions

```
BACKLOG -> TODO -> IN_PROGRESS -> IN_REVIEW -> QA -> DONE
                       ^              |         |
                       |              v         |
                       +---- REJECTED ----------+
                       |
                  BLOCKED  (from any active status, requires reason)
                  CANCELLED (from any status, terminal)
```

| Status       | Description                                 |
|--------------|---------------------------------------------|
| BACKLOG      | Created but not yet scheduled               |
| TODO         | Committed to a sprint, not yet started      |
| IN_PROGRESS  | Agent actively working                      |
| IN_REVIEW    | Code review by Vigil                        |
| QA           | Quality assurance by Sentinel/Probe         |
| DONE         | Completed and accepted                      |
| BLOCKED      | Waiting on external dependency              |
| CANCELLED    | Abandoned (terminal state)                  |

---

## Moving a Task (State Transition)

1. Read `_aegis-brain/tasks/{ID}/meta.json`.
2. Validate the transition against the transition table above.
3. Check WIP limits by reading all `meta.json` files in the current sprint (do NOT count from kanban.md).
4. Update `status` and `updated` fields in `meta.json` and write the file.
5. Append to `_aegis-brain/tasks/{ID}/history.md`:
   ```
   | {timestamp} | {agent} | MOVED | {from_status} | {to_status} | {optional note} |
   ```
6. Recompute `_aegis-brain/sprints/sprint-N/metrics.json` (task counts + daily_burndown).
7. Regenerate `_aegis-brain/sprints/sprint-N/kanban.md` as a derived view (see Regenerating Kanban Board below).
8. Append to `_aegis-brain/logs/activity.log`.

---

## Adding a Comment

1. Append to `_aegis-brain/tasks/{ID}/comments.md`:
   ```
   ---
   **{YYYY-MM-DD HH:MM}** | @{agent}
   {comment text}

   ```
2. Append to `_aegis-brain/tasks/{ID}/history.md`:
   ```
   | {timestamp} | {agent} | COMMENT | - | - | "{first 50 chars of comment}" |
   ```

---

## Recording Gate Results

Append to `_aegis-brain/tasks/{ID}/history.md`:
```
| {timestamp} | {agent} | GATE_PASS | - | {gate_number} | {summary} |
```
or
```
| {timestamp} | {agent} | GATE_FAIL | - | {gate_number} | {summary} |
```

If the gate produced findings, also append a comment to `_aegis-brain/tasks/{ID}/comments.md`
with the QA summary text (use the format in "Adding a Comment" above).

---

## history.md Format

```markdown
## {ID} History

| Timestamp | Agent | Action | From | To | Note |
|-----------|-------|--------|------|----|------|
| 2026-03-24 10:00 | navi | CREATED | - | BACKLOG | Created from breakdown |
```

**Append protocol:** Every write MUST append a new row at the bottom of the table.
The file is NEVER truncated or rewritten.

**Action types:**

| Action            | Description                                    |
|-------------------|------------------------------------------------|
| CREATED           | Entity created                                 |
| MOVED             | Status changed                                 |
| ASSIGNED          | Assignee changed                               |
| COMMENT           | Comment added                                  |
| POINTS_CHANGED    | Story points modified                          |
| PRIORITY_CHANGED  | Priority modified                              |
| DEPENDENCY_ADDED  | Dependency link created                        |
| DEPENDENCY_REMOVED| Dependency link removed                        |
| SPRINT_ASSIGNED   | Added to a sprint                              |
| GATE_PASS         | Quality gate passed (Gate 1 = review, Gate 2 = QA) |
| GATE_FAIL         | Quality gate failed                            |
| TIME_LOGGED       | Hours logged                                   |
| LABEL_CHANGED     | Labels modified                                |

---

## comments.md Format

```markdown
## {ID} Comments

---
**{YYYY-MM-DD HH:MM}** | @{agent}
{comment text}

---
**{YYYY-MM-DD HH:MM}** | @{agent}
{comment text}

---
```

The initial `comments.md` written at creation time contains only the header:
```markdown
## {ID} Comments

```

---

## Regenerating Kanban Board

The file `_aegis-brain/sprints/current/kanban.md` is a DERIVED VIEW, not a source of truth.
After any state change, regenerate it as follows:

1. Read all `meta.json` files in `_aegis-brain/tasks/` where `sprint` equals the current sprint identifier.
2. Group tasks by `status` column.
3. Render as the markdown table format defined in `skills/kanban-board.md`.
4. Write to `_aegis-brain/sprints/sprint-N/kanban.md`.

If `kanban.md` is lost or corrupted, it can be regenerated at any time from the meta.json files.

---

## Recomputing Sprint Metrics

After any task status change within a sprint, recompute `_aegis-brain/sprints/sprint-N/metrics.json`:

1. Read all `meta.json` files where `sprint` equals the current sprint.
2. Count tasks by status.
3. Sum completed points (tasks with `status = DONE`).
4. Sum remaining points (all non-DONE, non-CANCELLED tasks).
5. If the current date differs from the last `daily_burndown` entry date, append a new entry.
6. Write `metrics.json`.

---

## Legacy ID Compatibility

Existing IDs in the format `TASK-NNN` or `US-NNN` (from pre-v7.0 kanban files) are NOT
retroactively renamed. New entities always use `PROJ-{TYPE}-NNN`. Commands that look up
a task by ID treat `TASK-NNN` as equivalent to `PROJ-T-NNN` for the purpose of locating
a task directory.
