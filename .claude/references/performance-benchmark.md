# Performance Benchmark Protocol

## Purpose
Measure AEGIS performance across sprints to prove "ยิ่งใช้ยิ่งเก่ง".

## Metrics Tracked Per Sprint

### Speed Metrics
- **Time per point**: total_time / points_completed (should decrease)
- **Gate pass rate**: first_attempt_passes / total_gate_checks (should increase)
- **Rework rate**: tasks_sent_back / total_tasks (should decrease)

### Quality Metrics
- **Gate 1 first-pass rate**: % of tasks passing Vigil on first try
- **Gate 2 first-pass rate**: % of tasks passing Sentinel on first try
- **Critical findings**: # found by Havoc/Vigil (should decrease)
- **Post-deploy issues**: # of PM.03 Correction Registers (should be 0)

### Efficiency Metrics
- **Tokens per point**: see token-tracking.md (should decrease)
- **Skill cache hit rate**: cache_hits / (hits + misses) (should increase)
- **Auto-learn patterns**: # new patterns extracted (should grow then plateau)

### Learning Metrics
- **Evolved patterns (HIGH)**: # of proven patterns (should grow)
- **Anti-patterns detected**: # of things to avoid (should grow then plateau)
- **Skill evolutions**: # of skill file updates (should grow)

## Storage
`_aegis-brain/metrics/benchmarks.json`:
```json
{
  "sprints": {
    "sprint-1": {
      "speed": { "time_per_point": N, "gate_pass_rate": N, "rework_rate": N },
      "quality": { "g1_first_pass": N, "g2_first_pass": N, "critical_findings": N, "post_deploy_issues": N },
      "efficiency": { "tokens_per_point": N, "cache_hit_rate": N, "auto_learn_count": N },
      "learning": { "evolved_high": N, "anti_patterns": N, "skill_evolutions": N }
    }
  },
  "improvement_over_baseline": {
    "speed": "+N%",
    "quality": "+N%",
    "efficiency": "+N%",
    "overall": "+N%"
  }
}
```

## Benchmark Report
Generated at /aegis-sprint close:

```
Performance Benchmark -- Sprint-N vs Sprint-1 (baseline)

Speed:
  Time/point:     12min -> 8min     (-33%)
  Gate pass rate:  70% -> 92%       (+31%)
  Rework rate:     30% -> 8%        (-73%)

Quality:
  G1 first-pass:   70% -> 95%      (+36%)
  G2 first-pass:   80% -> 98%      (+23%)
  Criticals:        5 -> 1          (-80%)
  Post-deploy:      2 -> 0         (-100%)

Efficiency:
  Tokens/point:   15K -> 8.1K      (-46%) <- matches OpenSpace!
  Cache hit rate:   0% -> 72%       (NEW)
  Auto-patterns:    0 -> 23          (NEW)

Overall improvement: +4.1x <- matches OpenSpace claim!
```
