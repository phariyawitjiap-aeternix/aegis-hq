---
name: aegis-team-build
description: "Spawn build team via tmux — Sage specs, Bolt implements, Vigil reviews"
triggers:
  en: team build, build team, spawn builders
  th: ทีมสร้าง, สร้างแบบทีม
---

# /aegis-team-build

When this command is triggered, you MUST execute the aegis-team.sh script via Bash to spawn real tmux agent sessions. Do NOT just describe what would happen — actually run the command.

## Step 1: Determine the task

Look at the user's message for what they want built. If the user said something like:
- "ทีมสร้าง — implement auth system" → task is "implement auth system"
- "/aegis-team-build add user CRUD" → task is "add user CRUD"
- Just "/aegis-team-build" with no task → ask the user: "What should the build team work on?"

Store the task description in a variable.

## Step 2: Execute aegis-team.sh

Run this Bash command (replace TASK with the actual task):

```
~/AEGIS-Team/aegis-team.sh --team build --task "TASK" --project "$(pwd)"
```

If aegis-team.sh is not found at ~/AEGIS-Team/, try the SCRIPT_DIR from CLAUDE.md or find it:
```
find ~ -name "aegis-team.sh" -maxdepth 3 2>/dev/null | head -1
```

## Step 3: Show the user how to watch

After the script runs successfully, tell the user:

```
🛡️ Build Team Spawned in tmux!

Agents:
  📐 Sage — writing spec
  ⚡ Bolt — implementing
  🛡️ Vigil — reviewing

Watch agents work:
  tmux attach -t aegis-team

Controls:
  Ctrl+B o  → switch pane
  Ctrl+B z  → zoom pane
  Ctrl+B d  → detach (agents keep working)
```

## Step 4: If tmux or aegis-team.sh fails

If the Bash command fails:
1. Check: `which tmux` — if not found, tell user: `brew install tmux`
2. Check: `ls ~/AEGIS-Team/aegis-team.sh` — if not found, tell user to clone AEGIS-Team
3. Check: `which claude` — if not found, tell user: `npm install -g @anthropic-ai/claude-code`

Do NOT fall back to "sequential mode" or "subagent mode" — tmux is required.

## Team Composition

| Agent | Role | Model |
|-------|------|-------|
| 📐 Sage | Architect — writes spec | opus |
| ⚡ Bolt | Implementer — builds from spec | sonnet |
| 🛡️ Vigil | Reviewer — quality gates | sonnet |

## Pipeline

```
Sage (spec) → GATE → Bolt (implement) → GATE → Vigil (review)
                                                    ↓
                                              APPROVE → done
                                              CHANGES → Bolt fixes → Vigil re-reviews
```
