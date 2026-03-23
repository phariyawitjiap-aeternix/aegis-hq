---
name: aegis-team-debate
description: "Spawn debate team via tmux — multi-perspective architecture decisions"
triggers:
  en: debate, architecture decision, team debate, decide
  th: ถกเถียง, ทีมถกเถียง, ตัดสินใจ
---

# /aegis-team-debate

When this command is triggered, you MUST execute the aegis-team.sh script via Bash to spawn real tmux agent sessions. Do NOT just describe what would happen — actually run the command.

## Step 1: Determine the topic

Look at the user's message for the debate topic:
- "ถกเถียง — SQL vs NoSQL" → task is "debate: SQL vs NoSQL for this project"
- "/aegis-team-debate monolith or microservices" → task is "debate: monolith vs microservices"
- Just "/aegis-team-debate" → ask: "What architecture decision should the team debate?"

## Step 2: Execute aegis-team.sh

Run this Bash command:

```
~/AEGIS-Team/aegis-team.sh --team debate --task "TASK" --project "$(pwd)"
```

If not found at ~/AEGIS-Team/, try:
```
find ~ -name "aegis-team.sh" -maxdepth 3 2>/dev/null | head -1
```

## Step 3: Show the user how to watch

```
🛡️ Debate Team Spawned in tmux!

Agents:
  📐 Sage — proposing options
  ⚡ Bolt — evaluating feasibility
  🔴 Havoc — challenging assumptions
  🧭 Navi — synthesizing consensus

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
| 📐 Sage | Proposer — architecture options | opus |
| ⚡ Bolt | Evaluator — implementation feasibility | sonnet |
| 🔴 Havoc | Challenger — stress-test decisions | opus |
| 🧭 Navi | Synthesizer — drives consensus, records ADR | opus |
