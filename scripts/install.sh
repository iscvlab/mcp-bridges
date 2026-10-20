#!/usr/bin/env bash
# MCP Bridges — Universal Installer (macOS & Linux)
# Links the 5 MCP bridge skills into Claude Code (~/.claude/skills), Grok (~/.grok/skills), and Gemini/Antigravity (~/.gemini/config/skills)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_SRC="$SCRIPT_DIR/skills"

echo "============================================================"
echo "  ⚡ Computational Agent Skills — Universal Installer"
echo "============================================================"
echo "Source: $SKILLS_SRC"

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
            ln -s "$skill" "$dest"
            echo "  ✓ Linked /$skill_name"
        fi
    done
}

# 1. Claude Code (~/.claude/skills)
if [ -d "$HOME/.claude" ] || [ "$1" == "--claude" ] || [ "$1" == "--all" ]; then
    install_to "$HOME/.claude/skills" "Claude Code"
fi

# 2. Gemini / Antigravity (~/.gemini/config/skills)
if [ -d "$HOME/.gemini" ] || [ "$1" == "--antigravity" ] || [ "$1" == "--all" ]; then
    install_to "$HOME/.gemini/config/skills" "Gemini / Antigravity"
fi

# 3. Grok (~/.grok/skills)
GROK_ROOT="${GROK_HOME:-$HOME/.grok}"
if [ -d "$GROK_ROOT" ] || [ "$1" == "--grok" ] || [ "$1" == "--all" ]; then
    install_to "$GROK_ROOT/skills" "Grok"
fi

# 4. Target workspace if provided
if [ -n "$2" ] && [ -d "$2" ]; then
    install_to "$2/.agents/skills" "Workspace .agents ($2)"
    if [ -d "$2/.grok" ] || [ "$1" == "--grok" ]; then
        install_to "$2/.grok/skills" "Workspace .grok ($2)"
    fi
fi

echo ""
echo "============================================================"
echo "  ✓ Installation Complete! All skills ready to trigger."
echo "============================================================"
