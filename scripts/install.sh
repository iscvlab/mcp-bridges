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
if [ "$1" == "--symlink" ] || [ "$2" == "--symlink" ]; then
    MODE="symlink"
fi

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
if [ -z "$1" ] || [ "$1" == "--symlink" ]; then
    NO_FLAG=true
fi

# 1. Claude Code (~/.claude/skills)
if [ "$1" == "--claude" ] || [ "$1" == "--all" ] || { [ "$NO_FLAG" == true ] && [ -d "$HOME/.claude" ]; }; then
    install_to "$HOME/.claude/skills" "Claude Code"
fi

# 2. Gemini / Antigravity (~/.gemini/config/skills)
if [ "$1" == "--antigravity" ] || [ "$1" == "--all" ] || { [ "$NO_FLAG" == true ] && [ -d "$HOME/.gemini" ]; }; then
    install_to "$HOME/.gemini/config/skills" "Gemini / Antigravity"
fi

# 3. Grok (~/.grok/skills)
GROK_ROOT="${GROK_HOME:-$HOME/.grok}"
if [ "$1" == "--grok" ] || [ "$1" == "--all" ] || { [ "$NO_FLAG" == true ] && [ -d "$GROK_ROOT" ]; }; then
    install_to "$GROK_ROOT/skills" "Grok"
fi

# 4. Cursor / Codex / Windsurf (~/.agents/skills & ~/.codex/skills)
if [ "$1" == "--agents" ] || [ "$1" == "--all" ] || { [ "$NO_FLAG" == true ] && [ -d "$HOME/.agents" ]; }; then
    install_to "$HOME/.agents/skills" "Cursor / Codex / Windsurf (.agents)"
fi
if [ "$1" == "--codex" ] || [ "$1" == "--all" ] || { [ "$NO_FLAG" == true ] && [ -d "$HOME/.codex" ]; }; then
    install_to "$HOME/.codex/skills" "Codex (.codex)"
fi

# 5. Target workspace if provided
if [ -n "$2" ] && [ "$2" != "--symlink" ] && [ -d "$2" ]; then
    install_to "$2/.agents/skills" "Workspace .agents ($2)"
    if [ -d "$2/.claude" ] || [ "$1" == "--claude" ] || [ "$1" == "--all" ]; then
        install_to "$2/.claude/skills" "Workspace .claude ($2)"
    fi
    if [ -d "$2/.grok" ] || [ "$1" == "--grok" ]; then
        install_to "$2/.grok/skills" "Workspace .grok ($2)"
    fi
fi

echo ""
echo "============================================================"
echo "  ✓ Installation Complete! All 7 skills ready to trigger."
echo "============================================================"
