---
name: aegis-dashboard
description: "Display sprint dashboard -- burndown, tasks, agents, activity"
triggers:
  en: dashboard, status, overview, metrics
  th: แดชบอร์ด, สถานะ, ภาพรวม
---

# /aegis-dashboard

> Triggers EN: dashboard, status, overview, metrics
> Triggers TH: แดชบอร์ด, สถานะ, ภาพรวม

## Purpose
Read-only command that computes and displays a comprehensive sprint dashboard from all JSON state files. Writes nothing.

## Subcommands

### /aegis-dashboard (default) -- Full Dashboard
Display the complete dashboard with all sections.

### /aegis-dashboard burndown
Display only the burndown chart and sprint progress.

### /aegis-dashboard agents
Display only agent workload distribution.

### /aegis-dashboard tasks
Display only task distribution by status.

### /aegis-dashboard recent
Display only the 10 most recent activities across all tasks.

---

## Data Sources

| Data | Source File |
|------|-------------|
| Current sprint info | `_aegis-brain/sprints/sprint-N/metrics.json` |
| Task details | `_aegis-brain/tasks/*/meta.json` (glob all) |
| Recent activity | `_aegis-brain/tasks/*/history.md` (last 10 entries across all tasks) |
| Document status | `_aegis-output/iso-docs/doc-registry.json` |
| ID counters | `_aegis-brain/counters.json` |

---

## Full Instructions

### Step 1: Locate Current Sprint
1. Read `_aegis-brain/sprints/current` symlink to find active sprint directory.
2. If symlink does not exist, scan `_aegis-brain/sprints/` for the highest sprint-N directory.
3. If no sprint directory exists, display "No active sprint found. Run /aegis-sprint plan first."

### Step 2: Read Sprint Metrics
1. Read `_aegis-brain/sprints/sprint-N/metrics.json`.
2. Extract: sprint name, started, planned_end, goal, capacity_pts, committed_pts, completed_pts, daily_burndown, tasks counts.
3. Compute sprint day: `current_day = (today - started) + 1`.
4. Compute total days: `total_days = (planned_end - started) + 1`.

### Step 3: Read All Task Metadata
1. Glob `_aegis-brain/tasks/*/meta.json` and read all files.
2. Filter to tasks where `sprint` matches current sprint for sprint-scoped views.
3. Group tasks by: status, assignee.

### Step 4: Compute Burndown Status
```
ideal_remaining(day) = committed_pts * (1 - day / total_days)
actual_remaining = committed_pts - completed_pts

deviation = (actual_remaining - ideal_remaining) / committed_pts * 100

Status:
  ON_TRACK   : actual <= ideal + (committed_pts * 0.10)    # within 10%
  AT_RISK    : actual <= ideal + (committed_pts * 0.25)    # 10-25% behind
  OFF_TRACK  : actual >  ideal + (committed_pts * 0.25)    # >25% behind
```

### Step 5: Read Recent Activity
1. Glob `_aegis-brain/tasks/*/history.md`.
2. Parse the last row from each file (timestamp, agent, action, from, to, note).
3. Sort all entries by timestamp descending.
4. Take the top 10.

### Step 6: Read Document Registry
1. Read `_aegis-output/iso-docs/doc-registry.json` if it exists.
2. List documents with id, type, title, current_version, status.

### Step 7: Display Dashboard

```
AEGIS DASHBOARD -- Sprint N (Day X of Y)
================================================================

BURNDOWN
  Committed: NN pts | Completed: NN pts | Remaining: NN pts
  Progress:  [===================>-------] XX%
  Status:    ON_TRACK | AT_RISK | OFF_TRACK

  Day  Ideal  Actual
   1    XX.X   XX.X
   2    XX.X   XX.X
   3    XX.X   XX.X  <-- ahead / behind / on target

TASK DISTRIBUTION
  BACKLOG:      N    TODO:         N    IN_PROGRESS:  N
  IN_REVIEW:    N    QA:           N    DONE:         N
  BLOCKED:      N    CANCELLED:    N

AGENT WORKLOAD
  @agent1    N tasks (NN pts) | N done, N in_progress
  @agent2    N tasks (NN pts) | N done, N in_review
  ...

BLOCKED TASKS
  PROJ-T-NNN  "title"  BLOCKED  @agent  [reason]
  (none) -- if no blocked tasks

UPCOMING (next to finish)
  PROJ-T-NNN  "title"  IN_PROGRESS  @agent  [Npts]
  PROJ-T-NNN  "title"  TODO         @agent  [Npts]

RECENT ACTIVITY (last 10)
  YYYY-MM-DD HH:MM  PROJ-T-NNN  ACTION  detail  @agent
  ...

DOCUMENTS (ISO 29110)
  PROJ-DOC-NNN  TYPE  Title         vN  Status
  ...
================================================================
```

### ASCII Burndown Chart (for /aegis-dashboard burndown)

When `burndown` subcommand is used, render a full ASCII chart:

```
Points
  26 |*
  22 |  *  .
  18 |     . *
  14 |       .   *
  10 |         .
   7 |           .  *
   3 |             .
   0 +--+--+--+--+--+--+--
     D1 D2 D3 D4 D5 D6 D7

  * = actual    . = ideal
  Status: ON_TRACK
```

### Agent Workload Bars (for /aegis-dashboard agents)

When `agents` subcommand is used, show bar chart:

```
AGENT WORKLOAD
  @bolt      [========--------]  5/8 tasks done  (13 pts)
  @vigil     [============----]  3/4 tasks done  ( 8 pts)
  @sage      [================]  2/2 tasks done  ( 5 pts)
  @sentinel  [====------------]  1/4 tasks done  ( 5 pts)
```

---

## Edge Cases

- **No metrics.json**: Display "Sprint metrics not initialized. Run /aegis-sprint plan first."
- **No tasks in sprint**: Display "No tasks committed to sprint. Run /aegis-sprint plan to commit tasks."
- **Empty history files**: Show "No recent activity" in the activity section.
- **No doc-registry.json**: Skip the DOCUMENTS section entirely.
- **Sprint overdue (current day > total days)**: Show day as "Day X of Y (OVERDUE +Z days)" and status as OFF_TRACK.

## Agent Routing
- **Primary**: Navi (read-only, no writes)
- **No sub-agents needed**: This is a pure read + compute + display command.

## Output Location
Display only (stdout). No files written.
