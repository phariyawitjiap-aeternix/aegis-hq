---
name: aegis-team-review
description: "Spawn review team via tmux — Vigil leads, Havoc challenges, Forge gathers"
triggers:
  en: team review, review team, spawn reviewers
  th: ทีมรีวิว, รีวิวแบบทีม
---

# /aegis-team-review

When this command is triggered, you MUST execute the aegis-team.sh script via Bash to spawn real tmux agent sessions. Do NOT just describe what would happen — actually run the command.

## Step 1: Determine the task

Look at the user's message for what they want reviewed:
- "ทีมรีวิว — ดู src/ ทั้งหมด" → task is "review src/ directory"
- "/aegis-team-review check auth module" → task is "review auth module"
- Just "/aegis-team-review" → task is "review entire project codebase"

## Step 2: Execute aegis-team.sh

Run this Bash command:

```
~/AEGIS-Team/aegis-team.sh --team review --task "TASK" --project "$(pwd)"
```

If not found at ~/AEGIS-Team/, try:
```
find ~ -name "aegis-team.sh" -maxdepth 3 2>/dev/null | head -1
```

## Step 3: Show the user how to watch

```
🛡️ Review Team Spawned in tmux!

Agents:
  🔧 Forge — scanning codebase
  🔴 Havoc — challenging assumptions
  🛡️ Vigil — synthesizing findings

Watch: tmux attach -t aegis-team
```

## Step 4: If fails

1. `which tmux` — not found → `brew install tmux`
2. `ls ~/AEGIS-Team/aegis-team.sh` — not found → clone AEGIS-Team
3. `which claude` — not found → `npm install -g @anthropic-ai/claude-code`

tmux is REQUIRED — no fallback.

## Team

| Agent | Role | Model |
|-------|------|-------|
| 🔧 Forge | Scanner — gathers data | haiku |
| 🔴 Havoc | Challenger — adversarial | opus |
| 🛡️ Vigil | Lead — quality gate | sonnet |
