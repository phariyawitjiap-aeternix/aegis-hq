# Skill Evolution Engine

> Skills are NOT static markdown files. They EVOLVE based on usage data.
> Reference for: mother-brain (every 5 tasks), aegis-retro, aegis-distill

---

## Principle

Skills start as human-written templates but improve through practice. After enough tasks
use a skill, the engine analyzes what worked and what didn't, then updates the skill file
with real-world refinements. Small, auditable increments -- never radical rewrites.

---

## Evolution Triggers

### After every 5 tasks that use a skill:

Mother Brain tracks skill usage via task `task_type` and `labels` in meta.json.
When a skill reaches a multiple of 5 uses since last evolution, trigger evolution:

1. **Read the skill file** (e.g., `skills/code-review.md`)
2. **Read all learnings** tagged to that skill from `_aegis-brain/learnings/auto-learned.md`
3. **Read skill-cache patterns** related to that skill from `_aegis-brain/skill-cache/`
4. **Read anti-patterns** from `_aegis-brain/resonance/anti-patterns.md` relevant to this skill
5. **Generate skill update**:
   - Add new checklist items discovered through practice
   - Remove steps that consistently add no value (zero gate catches in 5+ uses)
   - Reorder steps based on actual effectiveness (high-catch steps move up)
   - Add "Common Pitfalls" section from anti-patterns
6. **Write updated skill** with version bump in header

### Version Header Format

Every evolved skill file gets a version comment at the top of its content (after frontmatter):

```markdown
<!-- Evolved: v{N} | {YYYY-MM-DD} | Based on {M} tasks -->
```

---

## Evolution Record

Append to `_aegis-brain/skill-cache/evolution-log.md`:

```
### EVO-{counter} | {YYYY-MM-DD}
- **Skill**: {skill_name} ({skill_file_path})
- **Version**: v{old} -> v{new}
- **Changes**:
  - ADDED: {new checklist item or section}
  - REMOVED: {step that added no value}
  - REORDERED: {step X moved before step Y}
  - UPDATED: {modified wording or criteria}
- **Based on**: {N} tasks, {M} learnings, {K} cache patterns
- **Expected improvement**: {description of what should get better}
```

**Counter management**: Read the file, count existing `### EVO-` entries, increment by 1.

---

## Evolution Constraints

These constraints are HARD LIMITS that the evolution engine MUST NOT violate:

1. **NEVER remove safety-critical steps**
   - Security checks (input validation, auth verification, injection prevention)
   - Gate validation steps (Gate 1-5 criteria)
   - Error handling requirements

2. **NEVER change ISO 29110 required outputs**
   - Work products defined by ISO 29110 are mandatory
   - Compliance steps in skills MUST remain intact
   - Scribe-related outputs are immutable

3. **MAX 3 changes per evolution**
   - Small increments only (add/remove/reorder/update)
   - If more than 3 changes are warranted, split across multiple evolution cycles
   - This prevents radical rewrites that could destabilize the process

4. **All evolutions logged for audit trail**
   - Every change recorded in evolution-log.md
   - Git history preserves previous skill versions
   - Rollback is always possible via git

5. **Human override**
   - Human can revert any evolution via git
   - Human can freeze a skill: add `<!-- FROZEN: do not evolve -->` to the file
   - Frozen skills are skipped by the evolution engine

---

## Skill Usage Tracking

Mother Brain maintains a mental count of skill usage per session. Across sessions,
the count is derived by scanning `_aegis-brain/learnings/auto-learned.md` entries
and mapping tasks to skills via their `task_type`.

Mapping:

| task_type | Primary skill |
|-----------|--------------|
| impl | code patterns (skills relevant to implementation) |
| test | qa-pipeline, test planning |
| review | code-review |
| arch | architecture, debate |
| ui | frontend patterns |
| doc | documentation, ISO compliance |
| research | research, analysis |
| data | data modeling |

---

## Integration Points

| System | How it connects |
|--------|----------------|
| Mother Brain | Checks evolution trigger every 5 tasks; executes evolution |
| Auto-Learn Protocol | Provides learnings data that feeds evolution decisions |
| Shared Intelligence | Provides cache patterns that inform skill updates |
| aegis-distill | Can trigger evolution review as part of knowledge distillation |
| Git | Preserves all previous versions for audit and rollback |
