# Knowledge Pipeline — Distributed Intelligence

```
TASK COMPLETION → AUTO-EXTRACT → DISTILL → PROPAGATE → ALL AGENTS
     (raw)         (patterns)    (proven)   (shared)    (applied)
```

## Stage 1: RAW CAPTURE (every task completion)
When: Any task moves to DONE
Who: Mother Brain (automatic)
What: Read task's history.md + comments.md + gate results
Where: _aegis-brain/learnings/raw/YYYY-MM-DD.md (append)

Captures:
- What worked (gate first-pass)
- What failed (gate retries, findings)
- Time taken vs estimated
- Agent that discovered the insight

## Stage 2: PATTERN EXTRACTION (every 3 tasks)
When: Every 3rd task completion
Who: Mother Brain (automatic)
What: Read last 3 raw entries, find recurring patterns
Where: _aegis-brain/skill-cache/ (by category)

Rules:
- Same pattern 2x → confidence LOW → write to cache
- Same pattern 3x → confidence MEDIUM → promote
- Same pattern 4x → confidence HIGH → auto-apply

## Stage 3: KNOWLEDGE DISTILL (every sprint close)
When: /aegis-sprint close
Who: Navi + Scribe
What: Merge all sprint learnings into curated knowledge
Where: _aegis-brain/resonance/ (permanent)

Process:
1. Read all raw captures from this sprint
2. Read skill-cache stats (hits, misses, promotions)
3. Write sprint-N-knowledge.md with:
   - Top 5 patterns that saved time
   - Top 3 anti-patterns to avoid
   - Skill evolution recommendations
   - Metric improvements (tokens/point, gate pass rate)

## Stage 4: PROPAGATION (every /aegis-start)
When: Session start
Who: Mother Brain
What: Load latest resonance + HIGH cache patterns
Where: In-memory (included in agent prompts)

How:
1. Read _aegis-brain/resonance/evolved-patterns.md
2. Read _aegis-brain/resonance/anti-patterns.md
3. Read _aegis-brain/skill-cache/ (HIGH confidence only)
4. Inject into EVERY agent's task prompt:
   "Shared knowledge: [N] patterns, [N] anti-patterns loaded"

## Pipeline Metrics
Track in _aegis-brain/metrics/knowledge-pipeline.json:
- raw_captures_total: count
- patterns_extracted: count
- patterns_promoted: count (LOW→MEDIUM→HIGH)
- cache_hit_rate: percentage
- knowledge_propagation_lag: sprints between capture and propagation
