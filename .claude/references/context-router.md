# Context Router — Hermes Protocol

Mother Brain reads this table to route requests automatically.
User says natural language → Router matches intent → Right agent(s) activated.

---

## Routing Table

### Single-Agent Routes (fast, sub-agent mode)

| Intent Keywords (EN) | Intent Keywords (TH) | Agent | Skill | Command |
|----------------------|---------------------|-------|-------|---------|
| "write spec", "design", "architecture", "plan" | "เขียน spec", "ออกแบบ", "สถาปัตยกรรม" | Sage | super-spec | /aegis-breakdown |
| "build", "implement", "code", "create feature" | "สร้าง", "เขียนโค้ด", "implement" | Bolt | - | - |
| "review", "check code", "find bugs" | "รีวิว", "เช็คโค้ด", "หาบั๊ก" | Vigil | code-review | - |
| "test", "QA", "quality" | "เทสต์", "ทดสอบ", "คิวเอ" | Sentinel | qa-pipeline | /aegis-qa |
| "challenge", "devil's advocate", "stress test" | "ท้าทาย", "หาจุดอ่อน" | Havoc | adversarial-review | - |
| "scan", "research", "gather data" | "สแกน", "ค้นหา", "รวบรวม" | Forge | - | - |
| "docs", "README", "changelog" | "เอกสาร", "เขียน doc" | Muse | api-docs | - |
| "UI", "UX", "accessibility", "dark mode" | "ยูไอ", "ยูเอ็กซ์" | Pixel | - | - |
| "deploy", "ship", "release", "rollback" | "เดพลอย", "ปล่อย", "โรลแบค" | Ops | - | /aegis-deploy |
| "ISO", "compliance", "audit" | "ไอเอสโอ", "ตรวจสอบ" | Scribe | iso-29110-docs | /aegis-compliance |
| "sprint", "kanban", "standup" | "สปรินต์", "คันบัง", "สแตนอัพ" | Navi | sprint-manager | /aegis-sprint |
| "breakdown", "user story", "epic" | "แตกงาน", "ยูสเซอร์สตอรี่" | Sage | work-breakdown | /aegis-breakdown |
| "dashboard", "status", "overview" | "แดชบอร์ด", "สถานะ" | Navi | - | /aegis-dashboard |
| "security", "vulnerability", "OWASP" | "ความปลอดภัย", "ช่องโหว่" | Sentinel+Havoc | security-audit | - |

### Multi-Agent Routes (team mode, TeamCreate)

| Intent Pattern | Team | Agents |
|---------------|------|--------|
| "build feature", "implement X", "สร้าง feature" | aegis-build | Sage→Bolt→Vigil |
| "review everything", "full review", "รีวิวทั้งหมด" | aegis-review | Forge→Havoc→Vigil |
| "debate", "discuss options", "ถกเถียง" | aegis-debate | Sage→Bolt→Havoc→Navi |
| "full QA", "test everything", "เทสต์ทั้งหมด" | aegis-qa | Sentinel→Probe |
| "deploy", "ship to prod", "เดพลอยขึ้น prod" | aegis-devops | Ops→Bolt (hotfix) |
| "full pipeline", "do everything", "ทำทั้งหมด" | full SDLC | All 14 stages |

### Complexity Detection (solo vs team)

| Signal | Route |
|--------|-------|
| Task < 3 story points | Solo agent (sub-agent) |
| Task 3-8 points | Build team (3 agents) |
| Task > 8 points | Build team + QA team |
| "urgent", "hotfix", "ด่วน" | Bolt direct (skip spec) + Vigil review |
| "full", "everything", "ทั้งหมด" | Full SDLC pipeline |

### Ambiguity Resolution

If intent is unclear:
1. Check task context (meta.json if task ID mentioned)
2. Check sprint context (what's TODO on kanban?)
3. If still unclear: ask ONE question: "This sounds like [X]. Want me to [action]?"
   Never ask more than 1 clarifying question.

### Priority Override

These intents ALWAYS take priority:
- "stop", "หยุด" → Interrupt all agents immediately
- "rollback", "โรลแบค" → Ops emergency rollback
- "broken", "prod down", "พัง" → P-1 incident response
