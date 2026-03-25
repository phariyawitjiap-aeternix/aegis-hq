# Token Tracking Protocol

## Purpose
Measure actual token usage per task, per agent, per sprint.
Enable "ยิ่งใช้ยิ่งคุ้ม" (the more you use, the cheaper it gets).

## When to Track
Every time an agent completes a phase of work, log:
- Agent name
- Task ID
- Phase (spec, build, review, qa, comply, deploy)
- Estimated tokens used (based on context % change)

## Storage
`_aegis-brain/metrics/token-usage.json`:
```json
{
  "sprints": {
    "sprint-1": {
      "total_tokens": N,
      "per_task_avg": N,
      "per_agent": {
        "sage": N,
        "bolt": N,
        "vigil": N,
        "...": "..."
      },
      "per_phase": {
        "spec": N,
        "build": N,
        "review": N,
        "qa": N,
        "comply": N
      },
      "tasks": {
        "PROJ-T-001": { "tokens": N, "points": N, "tokens_per_point": N }
      }
    }
  },
  "trend": {
    "tokens_per_point": [N, N, N],
    "improvement_pct": N
  }
}
```

## Key Metric: Tokens Per Story Point
- Sprint 1: baseline (e.g., 15K tokens/point)
- Sprint 2: should decrease if learning works
- Sprint 3+: target 46% reduction (match OpenSpace)

## How to Estimate Tokens
Claude Code shows context usage as percentage.
- At task start: record context %
- At task end: record context %
- Delta x estimated context window = approximate tokens used
- Formula: tokens = (end_pct - start_pct) x 200000 (for 200K context)

## Dashboard Integration
/aegis-dashboard shows:
- Token usage this sprint vs last sprint
- Tokens per point trend (should decrease)
- Most expensive agent (optimize)
- Most expensive phase (optimize)
