# 🌉 MCP Bridges

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platforms](https://img.shields.io/badge/Platforms-Claude_•_Grok_•_Gemini_•_Cursor_•_Codex-8A2BE2)](#-universal-installation)
[![Dual-OS](https://img.shields.io/badge/Dual--OS-Windows_•_macOS_•_Linux-success)](#-dual-os-cross-platform-architecture)
[![Verification](https://img.shields.io/badge/Protocol-BoostX_Verified_✓-emerald)](#-the-boostx-engineering-discipline)

> **Production-grade Model Context Protocol (MCP) automation bridges for Rhino 3D, Grasshopper, QGIS, Adobe Illustrator, and Figma.**  
> Built for AI coding assistants to operate deterministically across 3D CAD, parametric algorithms, GIS data, and presentation vector plates.

---

## 🚀 Universal Installation

Clone this repository, then run the universal installer or copy the `skills/*` folders into **your host's skill root** (same architecture as [boostx](https://github.com/iscvlab/boostx/releases/tag/v3.0.0)).

| Host | Global Skill Root | Workspace Skill Root |
|:---|:---|:---|
| **Claude Code** | `~/.claude/skills` | `<repo>/.claude/skills` |
| **Grok** | `$GROK_HOME/skills` or `~/.grok/skills` | `<repo>/.grok/skills` |
| **Gemini / Antigravity** | `~/.gemini/config/skills` | `<repo>/.agents/skills` |
| **Cursor / Codex / Windsurf** | `~/.agents/skills` | `<repo>/.agents/skills` |

### Option A: Automated Multi-Host Installer (Recommended)

**Windows (PowerShell):**
```powershell
git clone https://github.com/iscvlab/mcp-bridges.git
cd mcp-bridges
.\scripts\install.ps1 -All
```

**macOS / Linux (Bash / Zsh):**
```bash
git clone https://github.com/iscvlab/mcp-bridges.git
cd mcp-bridges
chmod +x scripts/install.sh
./scripts/install.sh --all
```

### Option B: Direct Copy into a Specific Host Root

```bash
git clone https://github.com/iscvlab/mcp-bridges.git

# Claude Code
mkdir -p ~/.claude/skills && cp -r mcp-bridges/skills/* ~/.claude/skills/

# Grok
mkdir -p ~/.grok/skills && cp -r mcp-bridges/skills/* ~/.grok/skills/

# Google Gemini / Antigravity
mkdir -p ~/.gemini/config/skills && cp -r mcp-bridges/skills/* ~/.gemini/config/skills/

# Project-local (.agents/skills)
mkdir -p .agents/skills && cp -r mcp-bridges/skills/* .agents/skills/
```

---

## 📦 Supported Creative & Spatial MCP Bridges

```
mcp-bridges/
├── /qgis             ← Geospatial intelligence & PyQGIS automation
├── /rhino            ← 3D NURBS modeling & RhinoCommon C#/Python
├── /grasshopper      ← Parametric canvas wiring & data tree surgery
├── /illustrator      ← Swiss vector plates & typographic layout
└── /figma            ← Bidirectional HTML/CSS & Figma MCP sync
```

| Bridge | Slash Command | Capabilities | Supported Stack |
| :--- | :---: | :--- | :--- |
| **QGIS Bridge** | `/qgis` | Direct interaction with active **QGIS Desktop** sessions. Automates spatial joins, raster math, metric UTM buffers (`EPSG:32647`), cartographic QML styling, and SIP pointer crash-safe layer tree surgery. | `qgis-mcp-server` • PyQGIS |
| **Rhino Bridge** | `/rhino` | Direct interaction with active **Rhinoceros 3D** sessions via McNeel's router. Automates CAD/NURBS modeling, layer hierarchies, programmatic RhinoCommon C#/Python execution, and viewport render capture. | `Rhino-MCP-Platform` • RhinoCommon |
| **Grasshopper Bridge** | `/grasshopper` | Active **Grasshopper (GH1)** parametric canvas automation. Places and wires components, performs data tree surgery (*Flatten-before-Graft*, path alignment), diagnoses red/orange solver errors, and automates geometry baking. | `g1_*` tools • Elefront |
| **Illustrator Bridge** | `/illustrator` | Desktop **Adobe Illustrator** vector plate production. Automates Swiss architectural layout systems, typographic hierarchy (`Space Grotesk` / `Plus Jakarta Sans`), z-index-safe grouping, and print/digital export. | `illustrator-mcp-server` • ExtendScript |
| **Figma Bridge** | `/figma` | Bidirectional design-to-code synchronization. Pushes live HTML pages into Figma via Option B and extracts Auto-Layout specs, typography tokens, and CSS properties back into source code. | `figma-developer-mcp` • Local HTTP |

---

## 🛡️ Built with BoostX Protocol

Every bridge in this repository adheres to strict production invariants:
* **Context Budget Protection**: Lightweight frontmatters with explicit negative exclusions (`Do NOT use for...`) to prevent false-positive context hijacking.
* **Progressive Disclosure**: Low-level crash mechanics (e.g. QGIS SIP pointer bugs) are disclosed into standalone reference files (`references/tree_surgery_protocol.md`), keeping prompt tokens lean.
* **Zero Hardcoding Invariant**: All paths are sanitized using universal environment variables (`%USERPROFILE%`, `%APPDATA%`, `~`) and POSIX forward slashes (`/`).
* **Dual-OS Parity**: Works seamlessly on Windows PowerShell and macOS/Linux zsh.

---

## 📂 Repository Layout

```
mcp-bridges/
├── README.md
├── LICENSE                               ← MIT License
├── .gitignore
├── skills/
│   ├── qgis/
│   │   ├── SKILL.md
│   │   └── references/tree_surgery_protocol.md
│   ├── rhino/SKILL.md
│   ├── grasshopper/SKILL.md
│   ├── illustrator/SKILL.md
│   └── figma/SKILL.md
└── scripts/
    ├── install.sh                        ← Universal installer for macOS / Linux
    └── install.ps1                       ← Universal installer for Windows PowerShell
```

---

## 🔗 Related Toolkits

Looking for high-discipline developer protocols and agent reasoning tools? Check out:
* **[boostx v3.0.0](https://github.com/iscvlab/boostx/releases/tag/v3.0.0)**: Composable 13-skill AI agent ecosystem (`/boostx`, `/briefx`, `/contextx`, `/create-skillx`, `/deep-researchx`, `/kickoffx`, `/layax`, `/obsidianx`, `/planx`, `/publishx-audit`, `/publishx-qgis`, `/researchx`, `/syncx`).

---

## 👤 Author

**Napat Phasundhiae**  
*Computational Design Technologist | Spatial Analytics • Urban & Environmental Simulation • Workflow Automation*

* **GitHub**: [@napattan](https://github.com/napattan) · [ISCV | Isocurve Research Lab (@iscvlab)](https://github.com/iscvlab)
* **LinkedIn**: [Napat Phasundhiae](https://www.linkedin.com/in/napatphas/)

---

## 📄 License

This repository is open-source under the [MIT License](LICENSE).
