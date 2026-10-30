# 🌉 MCP Bridges

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platforms](https://img.shields.io/badge/Platforms-Claude_•_Grok_•_Gemini_•_Cursor_•_Codex-8A2BE2)](#-universal-installation)
[![Dual-OS](https://img.shields.io/badge/Dual--OS-Windows_•_macOS_•_Linux-success)](#️-built-with-boostx-protocol)
[![Verification](https://img.shields.io/badge/Protocol-BoostX_Verified_✓-emerald)](#️-built-with-boostx-protocol)

> **Production-grade Model Context Protocol (MCP) & CAD automation bridges for Rhino 3D, Grasshopper, QGIS, Adobe Illustrator, and Figma.**  
> Built for AI coding assistants to operate deterministically across 3D CAD, parametric algorithms, GIS data, and presentation vector plates—with built-in **Elastic Cognitive Swarm (`/xultra`) Anti-"Multiple-Mouses" Live MCP Serialization**.

---

## 🚀 Universal Installation

Clone this repository, then run the universal installer or copy the `skills/*` folders into **your host's skill root** (same architecture as [boostx](https://github.com/iscvlab/boostx/releases/tag/v3.2.0)).

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

# Cursor / Codex / Windsurf / Project-local (.agents/skills)
mkdir -p ~/.agents/skills && cp -r mcp-bridges/skills/* ~/.agents/skills/
```

---

## 📦 Supported Creative, CAD & Spatial MCP Bridges (7 Skills)

```
mcp-bridges/
├── /qgis             ← Geospatial intelligence, PyQGIS & SIP-safe layer tree surgery
├── /rhino            ← 3D NURBS modeling, multi-slot sessions & RhinoCommon C#/Python
├── /grasshopper      ← Parametric canvas wiring (g1_*), batch solver lock & data tree surgery
├── /rhino-alias      ← Custom Rhino Python command aliases & persistent Dual-OS macro sync
├── /components-log   ← Grasshopper C# script component registry parser & Markdown/JSON sync
├── /illustrator      ← Swiss vector plates, typographic hierarchy & z-order-safe grouping
└── /figma            ← Bidirectional HTML/CSS & Figma MCP Auto-Layout sync
```

| Bridge | Slash Command | Capabilities | Supported Stack |
| :--- | :---: | :--- | :--- |
| **QGIS Bridge** | `/qgis` | Direct interaction with active **QGIS Desktop** sessions. Automates spatial joins, raster math, metric UTM buffers (`EPSG:32647`), cartographic `.qml` styling, and SIP pointer crash-safe layer tree surgery. | `qgis-mcp-server` • PyQGIS |
| **Rhino Bridge** | `/rhino` | Direct interaction with active **Rhinoceros 3D** sessions (`Rhino-MCP-Platform` `v0.3.0`). Automates multi-slot session management (`list_slots`/`spawn_slot`), NURBS/SubD/Mesh modeling, layer hierarchies, RhinoCommon C#/Python execution, and viewport capture. | `Rhino-MCP-Platform` • RhinoCommon |
| **Grasshopper Bridge** | `/grasshopper`, `/gh` | Active **Grasshopper (GH1)** parametric canvas automation via verified `g1_*` `v0.3.0` tools (`g1_apply_graph`, `g1_connect_many`, `solve=false` → single `g1_solve_graph`). Performs data tree surgery (*Simplify*, *Graft*, *Flatten*) and runtime diagnostics. | `g1_*` tools • `GH_Structure` |
| **Rhino Alias Utility** | `/rhino-alias`, `/alias` | Authors self-contained Rhino Python command scripts (`alias/<script_name>.py` and `~/Architecture/Rhino/Alias/<script_name>.py`) and generates copy-pasteable `! _-RunPythonScript` command macros for `Rhino Options → Aliases`. | RhinoPython • `rhinoscriptsyntax` |
| **Components Log Utility** | `/components-log`, `/looklog`, `/updatelog` | Parses Grasshopper C# (`Script_Instance`) `.cs` files (`void RunScript(...)` signatures and `/* ... INPUTS: ... OUTPUTS: ... */` block comments) to extract parameter types and `Item`/`List`/`Tree` access modes into `components_log.json` and `components_log.md`. | C# Signature Parser • Python CLI |
| **Illustrator Bridge** | `/illustrator` | Desktop **Adobe Illustrator** vector plate production. Automates Swiss architectural layout systems, typographic hierarchy (`Space Grotesk` / `Plus Jakarta Sans`), ascending z-order grouping, and print/digital export. | `illustrator-mcp-server` • ExtendScript |
| **Figma Bridge** | `/figma` | Bidirectional design-to-code synchronization. Pushes live HTML pages into Figma via Option B (`html.to.design` on port `8765`) and extracts Auto-Layout specs, typography tokens, and CSS variables back into code. | `figma-developer-mcp` • `figma_desktop` |

---

## 🧠 Elastic Cognitive Swarm (`/xultra`) Anti-"Multiple-Mouses" Live MCP Serialization

Desktop CAD, GIS, and vector design applications (**Rhino**, **Grasshopper**, **QGIS**, **Adobe Illustrator**) run on a **single main UI thread** where active selection, undo stacks, viewport cameras, and canvas solvers are global singletons. When paired with [`/xultra`](https://github.com/iscvlab/boostx), every bridge in this repository enforces the **Anti-"Multiple-Mouses" Serialization Protocol**:

1. **Multi-Slot / Multi-Instance Isolation (`spawn_slot` / `instance`)**:
   - In `/rhino` and `/grasshopper`, parallel `K`-vector tournament exploration spawns dedicated Rhino instances (`spawn_slot`) so each subagent binds exclusively to its own `slot`.
   - In `/qgis`, multi-window sessions route via explicit `instance` IDs from `list_qgis_instances`.
2. **Offline Compute Sharding + Single-Coordinator Live Applier (Default Single-Instance Mode)**:
   - Parallel Builders compute heavy geometry algorithms, `.cs` / `.py` scripts, `.gpkg` / `.qml` layers, or declarative `g1_apply_graph` JSON payloads in isolated workspace files (`Pointer-Not-Payload`) **without** calling live GUI mutation tools concurrently.
   - The single Coordinator (or designated Applier) then applies the verified artifacts to the live session sequentially—targeting disjoint layer subtrees (`Swarm::VectorA`), deferring Grasshopper solver passes (`solve=false` → single `g1_solve_graph`), guarding `QgsLayerTreeRegistryBridge`, and sharing a single local HTTP server on port `8765` for `/figma`.

---

## 🛡️ Built with BoostX Protocol

Every bridge in this repository adheres to strict production invariants:
* **Context Budget Protection**: Lightweight YAML frontmatters (`≤ 400` characters) with explicit negative exclusions (`Do NOT use for...`) to prevent false-positive context hijacking.
* **Progressive Disclosure**: Low-level crash mechanics (e.g., QGIS SIP pointer bugs) are disclosed into standalone reference files (`references/tree_surgery_protocol.md`), keeping prompt tokens lean.
* **Zero Hardcoding Invariant**: All paths use portable environment variables (`%USERPROFILE%`, `%APPDATA%`, `~`) and POSIX forward slashes (`/`), verified by `audit_engine.py --platform skill` and `--platform github` (`0` Blocking, `0` Advisory).
* **Dual-OS Parity**: Works seamlessly on Windows PowerShell and macOS/Linux Bash/Zsh.

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
│   ├── rhino-alias/SKILL.md
│   ├── components-log/
│   │   ├── SKILL.md
│   │   └── scripts/
│   │       ├── update_log.py
│   │       └── batch_update.py
│   ├── illustrator/SKILL.md
│   └── figma/SKILL.md
└── scripts/
    ├── install.sh                        ← Universal installer for macOS / Linux
    └── install.ps1                       ← Universal installer for Windows PowerShell
```

---

## 🔗 Related Toolkits

Looking for high-discipline developer protocols and Elastic Cognitive Swarm orchestration? Check out:
* **[boostx v3.2.0](https://github.com/iscvlab/boostx/releases/tag/v3.2.0)**: Composable 13-skill `/x*` AI agent ecosystem (`/xboost`, `/xbrief`, `/xcontext`, `/xcreate-skill`, `/xdeep-research`, `/xkickoff`, `/xlaya`, `/xobsidian`, `/xplan`, `/xpublish-audit`, `/xpublish-qgis`, `/xsync`, `/xultra`).

---

## 👤 Author

**Napat Phasundhiae**  
*Computational Design Technologist | Spatial Analytics • Urban & Environmental Simulation • Workflow Automation*

* **GitHub**: [@napattan](https://github.com/napattan) · [ISCV | Isocurve Research Lab (@iscvlab)](https://github.com/iscvlab)
* **LinkedIn**: [Napat Phasundhiae](https://www.linkedin.com/in/napatphas/)

---

## 📄 License

This repository is open-source under the [MIT License](LICENSE).
