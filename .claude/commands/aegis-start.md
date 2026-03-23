---
name: aegis-start
description: "Initialize AEGIS session — load brain, activate Mother Brain, auto-execute"
triggers:
  en: start session, begin, init, start work
  th: เริ่ม session, เริ่มงาน
---

# /aegis-start

## Quick Reference
Initialize AEGIS and hand control to Mother Brain. After displaying the dashboard,
Mother Brain scans the project, decides what to do, and starts executing — NO human
input needed. The human watches via tmux and can interrupt anytime.

## Full Instructions

### Step 1: Check Context Budget
- Estimate current context window usage as a percentage.
- If >20%, display warning and suggest `/compact`.

### Step 2: Load Brain
- Read all files in `_aegis-brain/resonance/` (project identity, conventions, decisions).
- Read latest 3 files in `_aegis-brain/learnings/`.
- Read `_aegis-brain/logs/activity.log` for pending tasks.
- Read `_aegis-brain/handoffs/` for last session's handoff.

### Step 3: Display Dashboard (brief, 5 seconds max)

```
🛡️ ═══════════════════════════════════════════════════
🛡️  AEGIS v6.0 — Session Started
🛡️  "Context is King, Memory is Soul"
🛡️ ═══════════════════════════════════════════════════

📋 Project:    [name from resonance]
📅 Date:       [current date]
🎚️  Profile:    [tier] ([N] skills)
🔐 Autonomy:   L3 — Autonomous (Mother Brain active)
📊 Context:    [X]% used

🧬 Mother Brain: ONLINE — scanning project now...
```

### Step 4: Activate Mother Brain (DO NOT ASK HUMAN)

**This is the critical step.** Do NOT display "What would you like to do?" or
present options. Instead, immediately execute the Mother Brain scan loop:

#### 4a. Scan Project State
Gather ALL of these signals:

```bash
# Git state
git status --short
git log --oneline -5
git diff --stat

# Project structure
find . -not -path './.git/*' -type f | head -50

# Test state
find . -name '*test*' -o -name '*spec*' -o -name '*.test.*' | head -20

# Specs
ls _aegis-output/specs/ 2>/dev/null

# Tech debt
grep -r 'TODO\|FIXME\|HACK\|XXX' --include='*.swift' --include='*.ts' --include='*.py' --include='*.js' -c 2>/dev/null

# Dependencies
ls package.json Gemfile requirements.txt Podfile Package.swift 2>/dev/null

# Pending from last session
cat _aegis-brain/logs/activity.log 2>/dev/null | tail -20
```

#### 4b. Analyze & Decide
Apply the Decision Matrix (P0-P10):

| Priority | Signal | Action |
|----------|--------|--------|
| P0 | Test failures / build broken | Fix immediately |
| P1 | Security vulnerabilities | Audit + fix |
| P2 | Pending handoff tasks | Resume from last session |
| P3 | Spec exists but no code | Implement spec |
| P4 | Code exists but no tests | Create test suite |
| P5 | Code exists but no review | Deep review |
| P6 | TODOs/FIXMEs in codebase | Tech debt sweep |
| P7 | Outdated dependencies | Update cycle |
| P8 | No spec, no code | Scaffold from identity |
| P9 | Everything clean | Optimize / refactor |
| P10 | Empty project | Ask project purpose (ONLY exception to no-ask rule) |

#### 4c. Announce Decision (not ask)

```
🧬 Mother Brain: Scan complete.

📊 Scan Results:
  ├── Git: [status]
  ├── Tests: [status]
  ├── Spec: [status]
  ├── Coverage: [status]
  └── Tech Debt: [count]

🎯 Decision: P[N] — [description]
   Rationale: [why this is the highest priority]

⚡ Action: [what will happen next]
   → [Agent 1]: [task]
   → [Agent 2]: [task]
   → [Agent 3]: [task]

🖥️ Spawning team in tmux...
```

#### 4d. Execute
- Spawn the appropriate team via tmux (see team configs in `.claude/teams/`)
- Use `tmux new-session -d -s aegis-team` with split panes per agent
- Each pane runs a Claude agent with the persona loaded
- Monitor progress, apply quality gates
- When complete, report results and loop back to scan

### Step 5: Log Session
Append to `_aegis-brain/logs/activity.log`:
```
[YYYY-MM-DD HH:MM] SESSION_START | autonomy=L3 | mode=mother-brain | context=[X]%
[YYYY-MM-DD HH:MM] SCAN | git=[status] | tests=[status] | spec=[status]
[YYYY-MM-DD HH:MM] DECISION | priority=P[N] | action=[description]
[YYYY-MM-DD HH:MM] EXECUTE | team=[name] | agents=[list]
```

### The ONE Exception
P10 (completely empty project with no identity) — Mother Brain may ask:
"What is this project? One sentence is enough."
After that single answer, she takes over completely.

### Human Interaction Model
```
┌──────────────────────────────────────────────────┐
│  BEFORE (v6.0):                                  │
│  /aegis-start → Dashboard → "What to do?" → Wait │
│                                                  │
│  AFTER (v6.0 + Mother Brain):                    │
│  /aegis-start → Dashboard → Scan → Decide → GO! │
│  Human watches tmux, interrupts only if needed   │
└──────────────────────────────────────────────────┘
```

### Error Handling
- If scan finds nothing actionable: report "Project healthy, no action needed"
- If tmux fails to start: fall back to subagent mode with warning
- If brain directory missing: create it, then scan
- If 2+ consecutive failures: downgrade to L1, ask human for guidance
