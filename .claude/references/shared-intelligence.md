# Shared Intelligence Protocol

> One agent learns -> ALL agents benefit. Knowledge flows upward to shared cache.
> Reference for: all agents, mother-brain, auto-learn-protocol

---

## Principle

Knowledge is not siloed per agent. When any agent discovers something useful during a task,
it writes to a shared cache. All agents read from this cache before starting work.
This creates a collective intelligence that improves with every task completed.

---

## Skill Cache Location

`_aegis-brain/skill-cache/`

---

## How It Works

### Write to Cache (any agent, after task completion)

When an agent discovers something useful during a task:

1. **Check reusability**: Is this insight task-specific or generally applicable?
   - Task-specific -> do NOT cache (stays in task comments/history only)
   - Generally applicable -> proceed to cache

2. **Categorize** into one of these files:

   | Category | File | Examples |
   |----------|------|----------|
   | CODE_PATTERN | `_aegis-brain/skill-cache/CODE_PATTERN.md` | "always add rate limit to upload endpoints" |
   | REVIEW_PATTERN | `_aegis-brain/skill-cache/REVIEW_PATTERN.md` | "missing null check on optional params" |
   | TEST_PATTERN | `_aegis-brain/skill-cache/TEST_PATTERN.md` | "always test cross-midnight for time functions" |
   | ARCH_PATTERN | `_aegis-brain/skill-cache/ARCH_PATTERN.md` | "use repository pattern for data access" |
   | SECURITY_PATTERN | `_aegis-brain/skill-cache/SECURITY_PATTERN.md` | "sanitize user input before SQL WHERE" |

3. **Append** to the appropriate file:

   ```
   ### SC-{counter} | {YYYY-MM-DD} | Source: {agent_name} | Task: {task_id}
   **Pattern**: {description}
   **Context**: {when to apply this pattern}
   **Example**: {code snippet or approach description}
   **Confidence**: {LOW|MEDIUM|HIGH}
   ```

   If the category file does not exist, create it with header:
   ```markdown
   # {CATEGORY} — Shared Skill Cache
   > Auto-populated by agents. Patterns are ranked by confidence level.
   ```

4. **Update stats**: Write updated `_aegis-brain/skill-cache/stats.json`

### Read from Cache (any agent, at task start)

Before starting a task:

1. Read `_aegis-brain/skill-cache/` files relevant to the task type:
   - `impl` task -> read CODE_PATTERN, ARCH_PATTERN, SECURITY_PATTERN
   - `review` task -> read REVIEW_PATTERN, SECURITY_PATTERN
   - `test` task -> read TEST_PATTERN, CODE_PATTERN
   - All tasks -> read SECURITY_PATTERN (always relevant)

2. Apply patterns based on confidence:
   - **HIGH** confidence: Apply automatically. These are proven patterns.
   - **MEDIUM** confidence: Consider applying. Mention in approach if relevant.
   - **LOW** confidence: Ignore for now. Still being validated.

3. Log cache usage:
   - If a pattern was applied -> increment `cache_hits` in stats.json
   - If no relevant patterns found -> increment `cache_misses` in stats.json

### Confidence Escalation

Confidence levels change based on validation:

```
First occurrence:                    LOW
Validated 2nd time (different task): MEDIUM
Validated 3rd time:                  HIGH (auto-apply from now on)
Contradicted (pattern caused issue): DEMOTE by 1 level
```

**Validation** means the same pattern was independently discovered or successfully applied
in a different task. The agent should note: `Validates SC-{N}` in its cache write.

**Contradiction** means applying the pattern caused a gate failure or bug. The agent should
note: `Contradicts SC-{N}` and the pattern gets demoted.

### Cache Statistics

Maintain `_aegis-brain/skill-cache/stats.json`:

```json
{
  "total_patterns": 0,
  "high_confidence": 0,
  "medium_confidence": 0,
  "low_confidence": 0,
  "cache_hits": 0,
  "cache_misses": 0,
  "last_updated": "ISO 8601 timestamp"
}
```

Update this file whenever:
- A new pattern is written (increment total + appropriate confidence level)
- A pattern confidence changes (adjust confidence counts)
- A cache read occurs (increment hits or misses)

---

## Integration Points

| System | How it connects |
|--------|----------------|
| Auto-Learn Protocol | Writes reusable insights to skill-cache after task DONE |
| Mother Brain (scan) | Reads stats.json for cache health check |
| Skill Evolution | Reads cache patterns when evolving skill files |
| All agents | Read relevant cache files before starting any task |

---

## Constraints

- Patterns MUST be general, not task-specific
- Each pattern MUST have a clear context (when to apply)
- NEVER cache secrets, credentials, or environment-specific values
- Counter (`SC-{N}`) is per-file, not global
- Maximum 50 patterns per category file (archive oldest LOW patterns if exceeded)
