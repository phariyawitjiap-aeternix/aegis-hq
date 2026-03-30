#!/usr/bin/env bash
# ============================================================================
# AEGIS v8.2.1 — Remote Installer (one-liner, no clone needed)
#
# Usage:
#   bash <(curl -sL https://raw.githubusercontent.com/phariyawitjiap-aeternix/aegis-hq/main/install-remote.sh) --profile full --project-name "My Project"
#
# Or:
#   curl -sL https://raw.githubusercontent.com/phariyawitjiap-aeternix/aegis-hq/main/install-remote.sh | bash -s -- --profile full --project-name "My Project"
# ============================================================================

set -euo pipefail

VERSION="8.2.1"
REPO_URL="https://github.com/phariyawitjiap-aeternix/aegis-hq.git"
TMP_DIR="/tmp/aegis-install-$$"
TARGET_DIR="$(pwd)"
PROFILE="standard"
PROJECT_NAME=""
UPGRADE=false

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; }

# Parse args
while [[ $# -gt 0 ]]; do
    case "$1" in
        --profile)     PROFILE="$2"; shift 2 ;;
        --project-name) PROJECT_NAME="$2"; shift 2 ;;
        --target-dir)  TARGET_DIR="$2"; shift 2 ;;
        --upgrade)     UPGRADE=true; shift ;;
        --help)
            echo -e "${BOLD}AEGIS v${VERSION} — Remote Installer${NC}"
            echo ""
            echo "Usage:"
            echo "  bash <(curl -sL URL) [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --profile <tier>       minimal | standard | full (default: standard)"
            echo "  --project-name <name>  Project name for brain identity"
            echo "  --target-dir <path>    Target directory (default: current dir)"
            echo "  --upgrade              Update existing install (preserve brain)"
            echo ""
            echo "Examples:"
            echo "  New install:"
            echo "    cd ~/Documents/my-project && git init"
            echo "    bash <(curl -sL $REPO_URL/raw/main/install-remote.sh) --profile full --project-name \"My App\""
            echo ""
            echo "  Upgrade:"
            echo "    cd ~/Documents/my-project"
            echo "    bash <(curl -sL $REPO_URL/raw/main/install-remote.sh) --upgrade"
            exit 0
            ;;
        *) error "Unknown option: $1"; exit 1 ;;
    esac
done

echo -e "${BOLD}${CYAN}================================================${NC}"
echo -e "${BOLD}${CYAN}  AEGIS v${VERSION} — Remote Installer${NC}"
echo -e "${BOLD}${CYAN}================================================${NC}"
echo ""
info "Profile: ${BOLD}${PROFILE}${NC}"
info "Target:  ${BOLD}${TARGET_DIR}${NC}"
[[ -n "$PROJECT_NAME" ]] && info "Project: ${BOLD}${PROJECT_NAME}${NC}"
[[ "$UPGRADE" == true ]] && info "Mode:    ${BOLD}UPGRADE${NC} (preserving brain)"
echo ""

# Pre-flight
info "Checking dependencies..."

if ! command -v git &>/dev/null; then
    error "git is required. Install: brew install git"
    exit 1
fi
success "git found"

if ! command -v node &>/dev/null; then
    error "Node.js is required. Install: brew install node"
    exit 1
fi
success "node found: $(node --version)"

if ! command -v claude &>/dev/null; then
    warn "Claude Code CLI not found. Install: npm install -g @anthropic-ai/claude-code"
else
    success "claude found: $(claude --version 2>&1 | head -1)"
fi

# Clone to temp
info "Downloading AEGIS v${VERSION}..."
rm -rf "$TMP_DIR"
git clone --depth 1 --quiet "$REPO_URL" "$TMP_DIR"
success "Downloaded to temp"

# Backup on upgrade
if [[ "$UPGRADE" == true ]] && [[ -f "${TARGET_DIR}/CLAUDE.md" ]]; then
    BACKUP_DIR="${TARGET_DIR}/_aegis-backup/$(date +%Y%m%d-%H%M%S)"
    info "Backing up user data to ${BACKUP_DIR}..."
    mkdir -p "$BACKUP_DIR"
    cp -r "${TARGET_DIR}/_aegis-brain/" "$BACKUP_DIR/" 2>/dev/null || true
    cp -r "${TARGET_DIR}/_aegis-output/iso-docs/" "$BACKUP_DIR/" 2>/dev/null || true
    cp "${TARGET_DIR}/CLAUDE_lessons.md" "$BACKUP_DIR/" 2>/dev/null || true
    success "Backup complete"

    # Remove old framework files (NOT user data)
    info "Removing old framework files..."
    rm -rf "${TARGET_DIR}/.claude/agents/" "${TARGET_DIR}/.claude/commands/"
    rm -rf "${TARGET_DIR}/.claude/references/" "${TARGET_DIR}/.claude/teams/"
    rm -f "${TARGET_DIR}/.claude/settings.json"
    rm -rf "${TARGET_DIR}/skills/"
    rm -f "${TARGET_DIR}/CLAUDE.md" "${TARGET_DIR}/CLAUDE_agents.md"
    rm -f "${TARGET_DIR}/CLAUDE_safety.md" "${TARGET_DIR}/CLAUDE_skills.md"
    rm -f "${TARGET_DIR}/install.sh" "${TARGET_DIR}/aegis-team.sh"
    rm -f "${TARGET_DIR}/GETTING_STARTED.md"
    # Delete old merged references (v6/v7 → v8.2 migration)
    rm -f "${TARGET_DIR}/.claude/references/review-checklist.md"
    rm -f "${TARGET_DIR}/.claude/references/output-format.md"
    rm -f "${TARGET_DIR}/.claude/references/progress-protocol.md"
    rm -f "${TARGET_DIR}/.claude/references/handoff-protocol.md"
    rm -f "${TARGET_DIR}/.claude/references/auto-learn-protocol.md"
    rm -f "${TARGET_DIR}/.claude/references/shared-intelligence.md"
    rm -f "${TARGET_DIR}/.claude/references/skill-evolution.md"
    rm -f "${TARGET_DIR}/.claude/references/knowledge-pipeline.md"
    rm -f "${TARGET_DIR}/.claude/references/performance-benchmark.md"
    rm -f "${TARGET_DIR}/.claude/references/token-tracking.md"
    success "Old files removed"
fi

# Install framework files
info "Installing AEGIS framework files..."

# Core docs
cp "${TMP_DIR}/CLAUDE.md" "${TARGET_DIR}/"
cp "${TMP_DIR}/CLAUDE_agents.md" "${TARGET_DIR}/"
cp "${TMP_DIR}/CLAUDE_safety.md" "${TARGET_DIR}/"
cp "${TMP_DIR}/CLAUDE_skills.md" "${TARGET_DIR}/"
# Preserve CLAUDE_lessons.md on upgrade
if [[ "$UPGRADE" != true ]] || [[ ! -f "${TARGET_DIR}/CLAUDE_lessons.md" ]]; then
    cp "${TMP_DIR}/CLAUDE_lessons.md" "${TARGET_DIR}/" 2>/dev/null || true
fi
success "Core docs installed"

# Agents (13)
mkdir -p "${TARGET_DIR}/.claude/agents/"
cp "${TMP_DIR}/.claude/agents/"*.md "${TARGET_DIR}/.claude/agents/"
success "$(ls "${TARGET_DIR}/.claude/agents/"*.md | wc -l | tr -d ' ') agents installed"

# Commands (22)
mkdir -p "${TARGET_DIR}/.claude/commands/"
cp "${TMP_DIR}/.claude/commands/"*.md "${TARGET_DIR}/.claude/commands/"
success "$(ls "${TARGET_DIR}/.claude/commands/"*.md | wc -l | tr -d ' ') commands installed"

# References (11)
mkdir -p "${TARGET_DIR}/.claude/references/"
cp "${TMP_DIR}/.claude/references/"*.md "${TARGET_DIR}/.claude/references/"
success "$(ls "${TARGET_DIR}/.claude/references/"*.md | wc -l | tr -d ' ') references installed"

# Teams (7)
mkdir -p "${TARGET_DIR}/.claude/teams/"
cp "${TMP_DIR}/.claude/teams/"*.md "${TARGET_DIR}/.claude/teams/"
success "$(ls "${TARGET_DIR}/.claude/teams/"*.md | wc -l | tr -d ' ') team configs installed"

# Settings
cp "${TMP_DIR}/.claude/settings.json" "${TARGET_DIR}/.claude/" 2>/dev/null || true
success "settings.json installed"

# Skills based on profile
mkdir -p "${TARGET_DIR}/skills/"

minimal_skills=(ai-personas orchestrator code-review code-standards git-workflow bug-lifecycle project-navigator)
standard_skills=(super-spec test-architect security-audit tech-debt-tracker sprint-tracker kanban-board work-breakdown)
full_skills=(aegis-distill aegis-observe adversarial-review code-coverage retrospective course-correction skill-marketplace aegis-builder qa-pipeline iso-29110-docs)

copy_skills() {
    for skill in "$@"; do
        src="${TMP_DIR}/skills/${skill}.md"
        [[ -f "$src" ]] && cp "$src" "${TARGET_DIR}/skills/"
    done
}

copy_skills "${minimal_skills[@]}"
[[ "$PROFILE" == "standard" || "$PROFILE" == "full" ]] && copy_skills "${standard_skills[@]}"
[[ "$PROFILE" == "full" ]] && copy_skills "${full_skills[@]}"

SKILL_COUNT=$(ls "${TARGET_DIR}/skills/"*.md 2>/dev/null | wc -l | tr -d ' ')
success "${SKILL_COUNT} skills installed (profile: ${PROFILE})"

# Scripts
cp "${TMP_DIR}/install.sh" "${TARGET_DIR}/" 2>/dev/null || true
cp "${TMP_DIR}/aegis-team.sh" "${TARGET_DIR}/" 2>/dev/null || true
cp "${TMP_DIR}/install-remote.sh" "${TARGET_DIR}/" 2>/dev/null || true
chmod +x "${TARGET_DIR}/install.sh" "${TARGET_DIR}/aegis-team.sh" "${TARGET_DIR}/install-remote.sh" 2>/dev/null || true

# Create directories
info "Creating directory structure..."
mkdir -p "${TARGET_DIR}/_aegis-brain/tasks"
mkdir -p "${TARGET_DIR}/_aegis-brain/sprints/current"
mkdir -p "${TARGET_DIR}/_aegis-brain/resonance"
mkdir -p "${TARGET_DIR}/_aegis-brain/learnings/raw"
mkdir -p "${TARGET_DIR}/_aegis-brain/skill-cache"
mkdir -p "${TARGET_DIR}/_aegis-brain/metrics"
mkdir -p "${TARGET_DIR}/_aegis-brain/logs"
mkdir -p "${TARGET_DIR}/_aegis-brain/handoffs"
mkdir -p "${TARGET_DIR}/_aegis-brain/backlog"
mkdir -p "${TARGET_DIR}/_aegis-brain/retrospectives"
mkdir -p "${TARGET_DIR}/_aegis-output/specs"
mkdir -p "${TARGET_DIR}/_aegis-output/breakdown"
mkdir -p "${TARGET_DIR}/_aegis-output/qa/results"
mkdir -p "${TARGET_DIR}/_aegis-output/iso-docs"
mkdir -p "${TARGET_DIR}/_aegis-output/sessions"
mkdir -p "${TARGET_DIR}/_aegis-output/deployments"
mkdir -p "${TARGET_DIR}/_aegis-output/reviews"
mkdir -p "${TARGET_DIR}/_aegis-output/architecture/archive"
success "Directory structure created"

# Initialize counters.json if not exists
if [[ ! -f "${TARGET_DIR}/_aegis-brain/counters.json" ]]; then
    cat > "${TARGET_DIR}/_aegis-brain/counters.json" << 'COUNTERS'
{
  "project_key": "PROJ",
  "counters": {"US":0,"J":0,"E":0,"T":0,"ST":0,"DOC":0,"ADR":0,"TD":0,"REL":0,"HO":0},
  "last_updated": "2026-01-01T00:00:00"
}
COUNTERS
    success "counters.json initialized"
fi

# Initialize brain files if not exists
if [[ ! -f "${TARGET_DIR}/_aegis-brain/resonance/project-identity.md" ]] && [[ -n "$PROJECT_NAME" ]]; then
    cat > "${TARGET_DIR}/_aegis-brain/resonance/project-identity.md" << IDENTITY
# Project Identity
- Name: ${PROJECT_NAME}
- Created: $(date +%Y-%m-%d)
- Framework: AEGIS v${VERSION}
IDENTITY
    success "Project identity created"
fi

# .gitignore
if [[ ! -f "${TARGET_DIR}/.gitignore" ]]; then
    cat > "${TARGET_DIR}/.gitignore" << 'GITIGNORE'
_aegis-output/
_aegis-backup/
.env
.env.*
*.key
*.pem
*secret*
.DS_Store
node_modules/
__pycache__/
*.log
!_aegis-brain/logs/activity.log
GITIGNORE
    success ".gitignore created"
fi

# Git init if needed
if [[ ! -d "${TARGET_DIR}/.git" ]]; then
    cd "${TARGET_DIR}" && git init --quiet
    success "Git repository initialized"
fi

# Cleanup temp
rm -rf "$TMP_DIR"
success "Temp files cleaned up"

echo ""
echo -e "${BOLD}${GREEN}================================================${NC}"
echo -e "${BOLD}${GREEN}  AEGIS v${VERSION} — Installation Complete!${NC}"
echo -e "${BOLD}${GREEN}================================================${NC}"
echo ""
echo -e "${BOLD}Profile:${NC}  ${PROFILE}"
[[ -n "$PROJECT_NAME" ]] && echo -e "${BOLD}Project:${NC}  ${PROJECT_NAME}"
echo -e "${BOLD}Location:${NC} ${TARGET_DIR}"
echo -e "${BOLD}Skills:${NC}   ${SKILL_COUNT}"
echo ""
echo -e "${BOLD}Next:${NC}"
echo "  cd ${TARGET_DIR}"
echo "  claude --dangerously-skip-permissions"
echo "  > /aegis-start"
echo ""
echo -e "${CYAN}Happy building! — AEGIS v${VERSION}${NC}"
