<p align="center">
  <img src="https://img.shields.io/badge/version-8.3-blue?style=for-the-badge" alt="Version 8.3"/>
  <img src="https://img.shields.io/badge/agents-13-green?style=for-the-badge" alt="13 Agents"/>
  <img src="https://img.shields.io/badge/skills-25-orange?style=for-the-badge" alt="25 Skills"/>
  <img src="https://img.shields.io/badge/commands-24-yellow?style=for-the-badge" alt="24 Commands"/>
  <img src="https://img.shields.io/badge/gates-5-red?style=for-the-badge" alt="5 Gates"/>
  <img src="https://img.shields.io/badge/dashboard-pixel--office-ff69b4?style=for-the-badge" alt="Pixel Office"/>
  <img src="https://img.shields.io/badge/ISO--29110-compliant-brightgreen?style=for-the-badge" alt="ISO 29110"/>
  <img src="https://img.shields.io/badge/license-MIT-purple?style=for-the-badge" alt="MIT License"/>
</p>

<h1 align="center">:shield: AEGIS HQ v8.3</h1>
<h3 align="center">AI Agent Team Framework for Claude Code</h3>

<p align="center">
  <b>"Context is King, Memory is Soul"</b><br/>
  <sub>:dna: Mother Brain · 13 AI Agents · 25 Skills · 24 Commands · 5-Gate Quality · Dashboard + Pixel Office</sub>
</p>

---

## :zap: 30-Second Demo

```
$ bash <(curl -sL .../install-remote.sh) --profile full --project-name "My SaaS App"

================================================
  AEGIS v8.3 — Remote Installer
================================================

[INFO] Profile: full
[INFO] Target:  ~/Documents/my-project

[OK] git found
[OK] node found: v22.x
[OK] claude found: 2.x (Claude Code)
[OK] Downloaded AEGIS v8.3
[OK] 13 agents installed
[OK] 24 commands installed
[OK] 11 references installed
[OK] 25 skills installed (profile: full)
[OK] Directory structure created
[OK] counters.json initialized

================================================
  AEGIS v8.3 — Installation Complete!
================================================

Next:
  claude --dangerously-skip-permissions
  > /aegis-start
```

```
$ claude
> /aegis-start

🛡️ ═══════════════════════════════════════════════════
🛡️  AEGIS v8.3 — Session Started
🛡️  "Context is King, Memory is Soul"
🛡️ ═══════════════════════════════════════════════════

📋 Project:    My SaaS App
🎚️  Profile:    full (25 skills)
🔐 Autonomy:   L3 — Autonomous (Mother Brain active)

🧬 Mother Brain: ONLINE — persistent heartbeat active

💓 Heartbeat: Scanning project state...
   Mother Brain will continuously monitor and dispatch agents.

🧬 Mother Brain: Scan complete.

📊 Scan Results:
  ├── Git: clean (main)
  ├── Sprint: sprint-1 active
  ├── Kanban: 3 TODO, 1 WIP, 2 DONE
  └── Context: 8% used

🎯 Decision: P2.5 — Pick next TODO from kanban
   → 📐 Sage: Writing spec...
   → ⚡ Bolt: Waiting for spec...
   → 🛡️ Vigil: Waiting for code review...
```

```
$ cd dashboard && npm install && npm run dev
# Open http://localhost:4321

🎮 Pixel Office — 13 agents in a pixel-art office
   Agents walk around, chat, get coffee when idle
   When work arrives: they sit down, code, and report to Mother Brain

┌────────────────────────────────────────────────────────────┐
│ SPRINT-2 Kanban  ████████████░░░ 70%  19/27pts            │
│ TODO    WIP     DONE                                       │
│ ┌────┐ ┌────┐  ┌────┐┌────┐┌────┐                        │
│ │T-12│ │T-08│  │✓T05││✓T06││✓T07│                        │
│ └────┘ └────┘  └────┘└────┘└────┘                        │
│                                                            │
│  📐Sage  ⚡Bolt  🛡️Vigil  🔴Havoc  🔧Forge               │
│  [desk]  [typing] [desk]  [coffee] [walking]              │
│                                                            │
│  🧬 Mother Brain: sleeping — no work  Zzz                 │
└────────────────────────────────────────────────────────────┘
```

---

## What is AEGIS HQ?

**AEGIS** (**A**utonomous **E**nhanced **G**roup **I**ntelligence **S**ystem) — production-grade AI agent team framework for Claude Code.

One command installs **13 AI agents** that autonomously plan, code, review, test, and deploy your project. Mother Brain scans your repo, decides what to do, spawns the right team, and drives to completion — while you watch from the **Pixel Office dashboard**.

:dna: **ยิ่งใช้ยิ่งเก่ง** — self-evolving intelligence learns from every sprint.

### Why AEGIS HQ?

| Without AEGIS | With AEGIS HQ |
|:-------------|:-------------|
| You tell Claude what to do | Mother Brain decides + acts |
| One agent at a time | 13 agents in parallel |
| No memory between sessions | Persistent brain + handoff |
| No quality gates | 5-gate pipeline (code → QA → ISO → deploy → monitor) |
| No project management | JIRA-like sprints + kanban + velocity |
| Invisible agent work | **Pixel Office** — watch agents work in real-time |

---

## :rocket: New Install (one command)

```bash
brew install node && npm install -g @anthropic-ai/claude-code
```

```bash
cd ~/Documents/my-project && git init
```

```bash
bash <(curl -sL https://raw.githubusercontent.com/phariyawitjiap-aeternix/aegis-hq/main/install-remote.sh) --profile full --project-name "My Project"
```

```bash
claude --dangerously-skip-permissions
```

> :bulb: Profile options: `minimal` (7 skills) · `standard` (15 skills) · `full` (25 skills)

**Permissions (one-time):**

```bash
cat > ~/.claude/settings.json << 'EOF'
{"permissions":{"defaultMode":"bypassPermissions","allow":["Bash","Edit","Write","Read","Glob","Grep","Agent","TeamCreate","TeamDelete","SendMessage"]},"env":{"CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS":"1"}}
EOF
```

---

## :arrows_counterclockwise: Upgrade Existing Install

```bash
cd ~/Documents/my-project
```

```bash
bash <(curl -sL https://raw.githubusercontent.com/phariyawitjiap-aeternix/aegis-hq/main/install-remote.sh) --upgrade
```

```bash
claude --dangerously-skip-permissions
```

**What `--upgrade` does:**

| Step | Action |
|:----:|--------|
| 1 | :lock: **Backup** `_aegis-brain/`, `iso-docs/`, `CLAUDE_lessons.md` → `_aegis-backup/` |
| 2 | :wastebasket: **Remove** old agents, commands, references, teams, skills |
| 3 | :arrow_down: **Download** latest AEGIS from GitHub (to `/tmp/`, auto-cleaned) |
| 4 | :package: **Install** new 13 agents, 24 commands, 11 references, 6 teams, 25 skills |
| 5 | :mag: **Verify** all files present + migrate old versions (v6→v8, v7→v8) |

**:lock: NEVER touched by upgrade:** `_aegis-brain/` (tasks, sprints, patterns, learnings), `iso-docs/`, `CLAUDE_lessons.md`, project source code

> :warning: **Always exit Claude Code before upgrading** — Claude caches files at session start

---

## :movie_camera: See It In Action

### `/aegis-start` — Mother Brain activates with heartbeat

```
🛡️ ═══════════════════════════════════════════════════
🛡️  AEGIS v8.3 — Session Started
🛡️  "Context is King, Memory is Soul"
🛡️ ═══════════════════════════════════════════════════

📋 Project:    My SaaS App
📅 Date:       2026-03-30
🎚️  Profile:    full (25 skills)
🔐 Autonomy:   L3 — Autonomous (Mother Brain active)
📊 Context:    8% used

🧬 Mother Brain: ONLINE — persistent heartbeat active

💓 Heartbeat: Scanning project state...
   Mother Brain will continuously monitor and dispatch agents.
   She never sleeps until the session ends.

👀 Watch: Shift+Down to view agent detail | Shift+Up to return
🛑 Stop: Ctrl+C to interrupt | /aegis-mode --autonomy L1 for manual
```

```
🧬 Mother Brain: Scan complete.

📊 Scan Results:
  ├── Git: clean (main, 12 commits)
  ├── Tests: PASS (28/28)
  ├── Sprint: sprint-2 active (day 3/5)
  ├── Kanban: 3 TODO, 1 IN_PROGRESS, 2 DONE
  ├── QA: pending for PROJ-T-007
  ├── Compliance: 8/11 ISO docs current
  └── Tech Debt: 5 TODOs, 2 FIXMEs

🎯 Decision: P2.5 — Active sprint, pick next TODO from kanban
   Task: PROJ-T-008 "Add payment webhook handler" [5pts]
   Rationale: Highest priority TODO in sprint-2, spec exists.

⚡ Action: Spawning build team...
   → 📐 Sage: Validate spec for PROJ-T-008
   → ⚡ Bolt: Implement webhook handler
   → 🛡️ Vigil: Code review (Gate 1)

💓 Heartbeat: 3 agents alive | context 15% | next pulse in 30s
```

### `/aegis-status` — Live dashboard with heartbeat

```
╔══════════════════════════════════════════════════════════════════╗
║  AEGIS Team Status                              v8.3            ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                 ║
║  💓 Mother Brain: ALIVE (last pulse: 8s ago)                    ║
║     Cycle: #4 | Agents spawned: 3 | Tasks done: 2              ║
║                                                                 ║
║  Agent          Task                    Status      Progress    ║
║  ─────────────  ──────────────────────  ──────────  ────────    ║
║  📐 Sage        Validating spec         ✅ Done     100%        ║
║  ⚡ Bolt        Implementing webhook    🔄 Working  60%         ║
║  🛡️ Vigil       Waiting for Bolt        ⏳ Waiting  —           ║
║                                                                 ║
║  Pipeline: Build Team [████████████░░░░░░░░] Step 2/3           ║
║  Context: 22% used 🟢 | ~78% remaining                         ║
║                                                                 ║
╚══════════════════════════════════════════════════════════════════╝
```

### `/super-spec` — Human Q&A then full autonomy

```
📐 Sage: I've analyzed your brief and researched similar systems.
Before I write the spec, I need your input:

📌 BUSINESS CONTEXT
1. Who are the primary users?
2. What specific problem does this solve?
3. How do they solve this today?

📌 SCOPE & PRIORITIES
4. What are the MUST-HAVE features for v1? (top 3-5)
5. What is explicitly OUT of scope?

📌 CONSTRAINTS
7. Tech stack preference?
8. Timeline pressure?

📌 SUCCESS
10. How will you measure success?
```

> :bulb: After you answer and approve the spec, Mother Brain enters **Spec Proxy mode** — she answers all team questions using your approved spec. No more interruptions.

```
🧬 Mother Brain: Spec approved. Entering Spec Proxy mode.
   I now have full context from BRD + SRS + UX Blueprint.
   I will answer team questions on your behalf.
   I'll only ask you for business decisions outside the spec.

💓 Resuming full autonomy (L3)...
   → Running /aegis-breakdown from spec...
   → Running /aegis-sprint plan...
   → Spawning build team for first task...
```

---

## :busts_in_silhouette: The 13 Agents

| # | Agent | Model | Role |
|:-:|:------|:-----:|:-----|
| :dna: | **Mother Brain** | `opus` | Autonomous Controller — scans, decides, spawns teams |
| :compass: | **Navi** | `opus` | Navigator/Lead — orchestrates, synthesizes, retros |
| :triangular_ruler: | **Sage** | `opus` | Architect — specs, system design, ADRs |
| :zap: | **Bolt** | `sonnet` | Implementer — writes code, builds features |
| :shield: | **Vigil** | `sonnet` | Reviewer — code review, quality gates |
| :red_circle: | **Havoc** | `opus` | Devil's Advocate — challenges, finds flaws |
| :wrench: | **Forge** | `haiku` | Scanner/Research — gathers data, metrics |
| :art: | **Pixel** | `sonnet` | UX Designer — UI/UX, accessibility |
| :paintbrush: | **Muse** | `haiku` | Content Creator — docs, changelogs |
| :dart: | **Sentinel** | `sonnet` | QA Lead — test strategy, release gate |
| :microscope: | **Probe** | `haiku` | QA Executor — runs tests, reports |
| :scroll: | **Scribe** | `haiku` | Compliance — ISO 29110, traceability |
| :rocket: | **Ops** | `sonnet` | DevOps — deploy, health check, rollback |

> **Routing:** Opus thinks, Sonnet builds, Haiku gathers.

---

## :factory: 14-Stage SDLC Pipeline

```
IDEA → BREAKDOWN → SPRINT → [ SPEC → BUILD → REVIEW(G1) → QA(G2) → COMPLY(G3) ] → CLOSE → DEPLOY(G4) → MONITOR(G5) → FEEDBACK
                              └──────────── per-task loop ────────────┘
```

---

## :vertical_traffic_light: 5-Gate Quality System

| Gate | Name | Owner | Checks |
|:----:|:-----|:------|:-------|
| G1 | Code Review | Vigil | 5-pass review: correctness, security, performance, maintainability, compliance |
| G2 | Product QA | Sentinel | Test plan, execution, coverage, verdict |
| G3 | Compliance | Scribe | ISO 29110 work products, traceability matrix |
| G4 | Deploy | Ops | Build, deploy, health check, smoke test |
| G5 | Monitor | Ops | Post-deploy health, metrics, rollback readiness |

---

## :keyboard: Commands (23)

| Command | Purpose |
|:--------|:--------|
| `/aegis-start` | Begin session — Mother Brain activates |
| `/aegis-retro` | End session — retrospective + lessons |
| `/aegis-handoff` | Handoff document for next session |
| `/aegis-pipeline` | Full analysis pipeline (all agents) |
| `/aegis-status` | Check all agent progress |
| `/aegis-mode` | Switch profile: `minimal` / `standard` / `full` |
| `/aegis-context` | Context budget usage + token breakdown |
| `/aegis-distill` | Compress conversation context |
| `/aegis-memory` | Read/write persistent brain |
| `/aegis-verify` | Verify outputs meet acceptance criteria |
| `/aegis-launch` | Launch specific agent with task |
| `/aegis-flow` | Visualize pipeline flow + dependencies |
| `/aegis-team-build` | Spawn build team (Sage + Bolt + Vigil) |
| `/aegis-team-review` | Spawn review team (Vigil + Havoc + Forge) |
| `/aegis-team-debate` | Spawn debate team (Sage + Havoc + Navi) |
| `/aegis-kanban` | Task board with WIP limits |
| `/aegis-breakdown` | Decompose stories → epics → tasks |
| `/aegis-sprint` | Sprint ceremonies — plan, standup, review, close |
| `/aegis-qa` | QA pipeline — plan, run, report, gate |
| `/aegis-compliance` | ISO 29110 document management + audit |
| `/aegis-deploy` | Deploy pipeline — build, deploy, health, monitor |
| `/aegis-dashboard` | Project dashboard — burndown, metrics, workload |

---

## :jigsaw: Skill Profiles

| Profile | Skills | Context | Use Case |
|:--------|:------:|:-------:|:---------|
| `minimal` | 7 | ~3K tokens | Quick tasks, small projects |
| `standard` | 15 | ~6K tokens | Normal development (default) |
| `full` | 25 | ~10K tokens | Enterprise, full SDLC |

Switch: `/aegis-mode minimal` · `/aegis-mode standard` · `/aegis-mode full`

---

## :star2: Key Features

- **:heartbeat: Mother Brain Heartbeat** — persistent background agent that never sleeps: scans, decides, dispatches, monitors agent health, auto-respawns stuck agents
- **:brain: Two-Phase Autonomy** — human answers questions during spec (L2), then Mother Brain takes over as Spec Proxy and answers all team questions (L3/L4)
- **:speech_balloon: Spec Proxy Mode** — after spec approval, Mother Brain answers team questions using BRD + SRS + research. Only escalates business decisions to human
- **Self-Evolving Intelligence** — auto-learn from tasks, shared cache across agents, skill evolution
- **JIRA-like PM State** — sequential IDs, per-task history, sprint dashboard
- **ISO 29110 Compliance** — 14 work products, activity-time generation, audit trail
- **Sprint/Scrum/Kanban** — ceremonies, velocity tracking, WIP limits, burndown
- **Context Router** — Hermes-like routing to the right agent based on intent
- **Knowledge Pipeline** — 4-stage: capture :arrow_right: extract :arrow_right: distill :arrow_right: propagate
- **Architecture Decision Records (ADRs)** — structured decisions with status tracking
- **Tech Debt Tracking** — continuous scanning, sprint-integrated, priority scoring
- **Release Management** — semver, checklist, rollback, health monitoring
- **Persistent Brain** — resonance, learnings, retrospectives survive across sessions

---

## :thailand: Thai Triggers (ภาษาไทย)

| พิมพ์ | Triggers |
|:------|:---------|
| "เริ่ม session" | `/aegis-start` |
| "รีวิวโค้ดให้" | code-review + Vigil |
| "ทีมสร้าง" | `/aegis-team-build` |
| "ทีมรีวิว" | `/aegis-team-review` |
| "ถกเถียง" | `/aegis-team-debate` |
| "เช็ค context" | `/aegis-context` |
| "สถานะ" | `/aegis-status` |
| "จบ session" | `/aegis-retro` |
| "ส่งต่อ" | `/aegis-handoff` |
| "วางแผน" | orchestrator + Navi |
| "เขียน spec" | super-spec + Sage |
| "ตรวจความปลอดภัย" | security-audit |
| "หนี้เทคนิค" | tech-debt-tracker |
| "ท้าทายการตัดสินใจ" | adversarial-review + Havoc |

---

## :file_folder: Directory Structure

```
your-project/
├── CLAUDE.md                    # Hub file (loaded every session)
├── CLAUDE_agents.md             # Agent quick reference
├── CLAUDE_skills.md             # Skill catalog
├── CLAUDE_safety.md             # Safety rules
├── CLAUDE_lessons.md            # Accumulated learnings
├── .claude/
│   ├── commands/                # 23 slash commands
│   ├── agents/                  # 13 agent personas
│   ├── references/              # Protocol files
│   ├── teams/                   # Team configurations
│   └── settings.json            # Permissions + env
├── skills/                      # 25 skill definitions
└── _aegis-brain/                # Persistent memory (never overwritten)
    ├── resonance/               # Project identity + conventions + ADRs
    ├── learnings/               # Accumulated lessons
    ├── retrospectives/          # Session retros + AI diaries
    └── logs/                    # Activity tracking
```

---

## :sparkles: What's New in v8.3

| Feature | Before (v8.2) | After (v8.3) |
|:--------|:-------------|:-------------|
| **Mother Brain** | Inline scan, one-shot | Persistent background agent + heartbeat loop |
| **Agent Health** | No monitoring | Auto-nudge (>120s), auto-respawn (>300s) |
| **Spec Phase** | AI guesses requirements | Human Q&A (10 questions) + approval gate |
| **Post-Spec** | Asks human everything | Spec Proxy — Mother Brain answers for human |
| **Agent Mode** | tmux panes | In-process background agents (Agent tool) |
| **Haiku Models** | Mixed (3-5 / 4-5) | All standardized to `claude-haiku-4-5` |
| **Logging** | activity.log only | + heartbeat.log + spec-proxy.log |

---

## :handshake: Credits

| Contribution | Credit |
|:-------------|:-------|
| Oracle Brain (ψ/) | **Nat Weerawan** — [Soul-Brews-Studio](https://github.com/Soul-Brews-Studio) |
| MAW Framework | **Soul-Brews-Studio** |
| Claude Thailand Community | **Joon**, **Mickey** (AX Digital), **New** (Debox) |
| Claude Code Agent Teams | **Anthropic** |

---

## :scroll: License

MIT License. See [LICENSE](LICENSE) for details.

---

<p align="center">
  <b>Built with :brain: by the AEGIS community</b><br/>
  <sub>Powered by Claude Code · Anthropic</sub>
</p>
