#!/usr/bin/env bash
# MCP Bridges — Universal Installer (macOS & Linux)
# Links the 7 creative, CAD & spatial MCP bridge skills into Claude Code (~/.claude/skills),
# Grok (~/.grok/skills), Gemini/Antigravity (~/.gemini/config/skills), and Cursor/Codex (~/.agents/skills).

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_SRC="$SCRIPT_DIR/skills"

echo "============================================================"
echo "  ⚡ MCP Bridges (7 Skills) — Universal Installer"
echo "============================================================"
echo "Source: $SKILLS_SRC"

MODE="copy"
TARGET_DIR="${AGENT_SKILLS_DIR:-}"
WORKSPACE_DIR=""
FLAG=""

while [ $# -gt 0 ]; do
    case "$1" in
        --symlink)
            MODE="symlink"
            shift
            ;;
        --target)
            TARGET_DIR="$2"
            shift 2
            ;;
        --target=*)
            TARGET_DIR="${1#*=}"
            shift
            ;;
        --all|--claude|--antigravity|--grok|--agents|--codex)
            FLAG="$1"
            shift
            ;;
        *)
            if [ -z "$WORKSPACE_DIR" ] && [ -d "$1" ]; then
                WORKSPACE_DIR="$1"
            fi
            shift
            ;;
    esac
done

install_to() {
    local target_dir="$1"
    local name="$2"

    mkdir -p "$target_dir"
    echo ""
    echo "Installing into $name ($target_dir)..."

    for skill in "$SKILLS_SRC"/*; do
        if [ -d "$skill" ]; then
            local skill_name
            skill_name="$(basename "$skill")"
            local dest="$target_dir/$skill_name"

            if [ -L "$dest" ] || [ -d "$dest" ]; then
                rm -rf "$dest"
            fi
            if [ "$MODE" == "symlink" ]; then
                ln -s "$skill" "$dest"
                echo "  ✓ Linked /$skill_name"
            else
                cp -R "$skill" "$dest"
                echo "  ✓ Installed /$skill_name"
            fi
        fi
    done
}

NO_FLAG=false
if [ -z "$FLAG" ] && [ -z "$TARGET_DIR" ] && [ -z "$WORKSPACE_DIR" ]; then
    NO_FLAG=true
fi

# 0. Custom Agent Target (--target <dir> or $AGENT_SKILLS_DIR)
if [ -n "$TARGET_DIR" ]; then
    install_to "$TARGET_DIR" "Custom Agent Target ($TARGET_DIR)"
fi

# 1. Claude Code (~/.claude/skills)
if [ "$FLAG" == "--claude" ] || [ "$FLAG" == "--all" ] || { [ "$NO_FLAG" == true ] && [ -d "$HOME/.claude" ]; }; then
    install_to "$HOME/.claude/skills" "Claude Code"
fi

# 2. Gemini / Antigravity (~/.gemini/config/skills)
if [ "$FLAG" == "--antigravity" ] || [ "$FLAG" == "--all" ] || { [ "$NO_FLAG" == true ] && [ -d "$HOME/.gemini" ]; }; then
    install_to "$HOME/.gemini/config/skills" "Gemini / Antigravity"
fi

# 3. Grok (~/.grok/skills)
GROK_ROOT="${GROK_HOME:-$HOME/.grok}"
if [ "$FLAG" == "--grok" ] || [ "$FLAG" == "--all" ] || { [ "$NO_FLAG" == true ] && [ -d "$GROK_ROOT" ]; }; then
    install_to "$GROK_ROOT/skills" "Grok"
fi

# 4. Universal ~/.agents/skills & ~/.codex/skills (Cursor / Codex / Windsurf / Local LLM Agents)
if [ "$FLAG" == "--agents" ] || [ "$FLAG" == "--all" ] || { [ "$NO_FLAG" == true ] && [ -d "$HOME/.agents" ]; }; then
    install_to "$HOME/.agents/skills" "Universal .agents (Cursor / Codex / Windsurf / Local LLM Agents)"
fi
if [ "$FLAG" == "--codex" ] || [ "$FLAG" == "--all" ] || { [ "$NO_FLAG" == true ] && [ -d "$HOME/.codex" ]; }; then
    install_to "$HOME/.codex/skills" "Codex (.codex)"
fi

# 5. Target workspace if provided
if [ -n "$WORKSPACE_DIR" ] && [ -d "$WORKSPACE_DIR" ]; then
    install_to "$WORKSPACE_DIR/.agents/skills" "Workspace .agents ($WORKSPACE_DIR)"
    if [ -d "$WORKSPACE_DIR/.claude" ] || [ "$FLAG" == "--claude" ] || [ "$FLAG" == "--all" ]; then
        install_to "$WORKSPACE_DIR/.claude/skills" "Workspace .claude ($WORKSPACE_DIR)"
    fi
    if [ -d "$WORKSPACE_DIR/.grok" ] || [ "$FLAG" == "--grok" ]; then
        install_to "$WORKSPACE_DIR/.grok/skills" "Workspace .grok ($WORKSPACE_DIR)"
    fi
fi

echo ""
echo "============================================================"
echo "  ✓ Installation Complete! All 7 skills ready to trigger."
echo "============================================================"
