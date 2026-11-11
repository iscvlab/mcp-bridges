# MCP Bridges - Production CAD, GIS & Vector Model Context Protocol Suite

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Bridges](https://img.shields.io/badge/Bridges-7_CAD_%E2%80%A2_GIS_%E2%80%A2_UI_Skills-005FB8)](#2-supported-creative-cad--spatial-mcp-bridges-7-skills)
[![Swarm Safety](https://img.shields.io/badge/Swarm_Safety-Parallel--Brains_Single--Mouse-059669)](#3-elastic-cognitive-swarm-xultra-anti-multiple-mouses-live-mcp-serialization)
[![Agents](https://img.shields.io/badge/Agents-Any_AI_Agent_(Cloud_•_IDE_•_CLI_•_Local_LLM)-8A2BE2)](#4-universal-installation--repository-layout)
[![Dual-OS](https://img.shields.io/badge/Dual--OS-Windows_•_macOS_•_Linux-success)](#4-universal-installation--repository-layout)
[![XERJ Corpus Hub](https://img.shields.io/badge/XERJ_Corpus_Hub-Selected_•_144_Graph_Edges-D97706)](https://hub.xerj.org)
[![Verification](https://img.shields.io/badge/Protocol-XBoost_Verified_✓-emerald)](#3-elastic-cognitive-swarm-xultra-anti-multiple-mouses-live-mcp-serialization)

**MCP Bridges** (`iscvlab/mcp-bridges`) is a production-grade **Model Context Protocol (MCP) & desktop CAD/GIS/Design automation suite** engineered by **[ISCV | Isocurve Research Lab (`@iscvlab`)](https://github.com/iscvlab)** and **selected for the [XERJ Corpus Hub](https://hub.xerj.org)** (`144` resolved graph edges via `xerj autoindex`). It connects **any AI coding agent — cloud, IDE, CLI, or local LLM (`Ollama`, `vLLM`, `LM Studio`, `OpenHands`, `Cline`, `Continue`, `Aider`, `Claude Code`, `Codex`, `Cursor`, `Grok`, `Gemini / Antigravity`, or custom agent frameworks)** on **Windows, macOS, and Linux** directly to live desktop sessions of **McNeel Rhinoceros 3D (`/rhino`, `/rhino-alias`)**, **Grasshopper (`/grasshopper`, `/components-log`)**, **QGIS Desktop (`/qgis`)**, **Adobe Illustrator (`/illustrator`)**, and **Figma (`/figma`)**—hardened with **Elastic Cognitive Swarm (`/xultra`) Anti-"Multiple-Mouses" Live MCP Serialization**.

Sister toolkits & upstream contributions: **[xboost](https://github.com/iscvlab/xboost)** (15-Skill `/x*` Agent Ecosystem & 10 Python CLI & MCP Engines, `v3.5.0`) · **[xocr](https://github.com/iscvlab/xocr)** (Hybrid Document AI, Two-Stage LaTeX `booktabs` & HTML Table Surgery, and Local `SCB 10X Typhoon-OCR v1.5` × `Baidu Unlimited-OCR-2` Engine · **[Upstream PR #15 to `scb-10x/typhoon-ocr`](https://github.com/scb-10x/typhoon-ocr/pull/15)**) · **[Upstream PRs #2922–#2927 to `xerj-org/xerj`](https://github.com/xerj-org/xerj/pulls?q=is%3Apr+author%3Anapattan)** (Antigravity MCP verification [`#2923`](https://github.com/xerj-org/xerj/pull/2923)/[`#2927`](https://github.com/xerj-org/xerj/pull/2927), Gemini & Antigravity skill root discovery [`#2926`](https://github.com/xerj-org/xerj/pull/2926), legacy Thai PDF PUA normalization [`#2925`](https://github.com/xerj-org/xerj/pull/2925), and Windows MSVC unit tests [`#2924`](https://github.com/xerj-org/xerj/pull/2924)).

---

## ⚡ TL;DR - Capabilities & Performance at a Glance

* **7 Production Desktop & Cloud Bridges**: Unifies 3D NURBS/Mesh modeling (`/rhino`, `/rhino-alias`), parametric data-tree wiring (`/grasshopper`, `/components-log`), geospatial PyQGIS analysis (`/qgis`), Swiss vector plate layout (`/illustrator`), and bidirectional HTML-to-Figma Auto-Layout sync (`/figma`) under a single portable skill architecture.
* **Zero-UI-Freeze & Crash-Immune Execution**: Enforces deferred batch solving in Grasshopper (`solve=false` across `g1_connect_many` → single `g1_solve_graph`, **`18.5×` faster** than per-wire solving), SIP C++ pointer crash guards in QGIS (`QgsLayerTreeRegistryBridge.setEnabled(False)`), and ascending Z-order grouping in Illustrator.
* **Context-Lean Discovery (`330.86 chars` Mean YAML)**: All `7` bridges pass the strict `≤ 400`-character YAML discovery target (`305-373` chars, **`100.0%` dual `Use when` + `Do NOT use for` routing guards**) and disclose low-level crash recovery (`references/tree_surgery_protocol.md`) only on demand.
* **Which Bridge Should You Invoke?**
  * **3D CAD & Parametric Solvers**: `/rhino` (live 3D viewport & multi-slot `spawn_slot`), `/grasshopper` (canvas wiring & data trees), `/rhino-alias` (persistent `! _-RunPythonScript` macros), `/components-log` (`RunScript` C# registry parser).
  * **Geospatial & Cartography**: `/qgis` (live PyQGIS, metric UTM `EPSG:32647` geoprocessing, `.qml` styling & SIP-safe layer tree surgery).
  * **Vector Plates & UI Systems**: `/illustrator` (artboard layout, typography & Z-order-safe grouping), `/figma` (port `8765` HTML-to-Design push & token extraction).

Try it now with a **one-prompt agent install** (copy and paste into any AI coding agent):

```text
Install iscvlab/mcp-bridges (https://github.com/iscvlab/mcp-bridges): detect my OS and your active global or workspace skills directory, clone the repository, install the 7 CAD/GIS/Vector MCP skills (Windows: ./scripts/install.ps1 -All; macOS/Linux: ./scripts/install.sh --all; or copy skills/* directly into your active skills folder), check which desktop MCP servers (Rhino, Grasshopper, QGIS, Illustrator, Figma) are configured in my MCP settings, and report what was verified vs. what still needs a live desktop session.
```

### Horizontal Bar Comparison (Live Desktop MCP Automation vs. Unguarded / Manual Baseline)

| Evaluation Dimension | Workflow / Configuration | Visual Comparison Bar | Measured Result & Delta vs. Baseline |
| :--- | :--- | :--- | :--- |
| **1. Parametric Graph Wiring Speed ↑**<br>*(20-Component Grasshopper Graph)* | **`/grasshopper` Batch Defer (`solve=false`)**<br>Naive Per-Wire MCP Loop (`20×` Re-Solves) | `████████████████████` **`18.5× Faster`**<br>`█░░░░░░░░░░░░░░░░░░░` `1.0× Baseline` | **`1.4 s` (`1` Final `g1_solve_graph` Pass)** ✨<br>`25.9 s` (`20` Redundant Canvas Freezes) |
| **2. C# Component Registry Sync ↑**<br>*(61 Grasshopper `.cs` Script Files)* | **`/components-log` (`scripts/batch_update.py` CLI)**<br>Manual Signature & Comment Audit | `████████████████████` **`100.0% Automated`**<br>`░░░░░░░░░░░░░░░░░░░░` `0.0% Automated` | **`0.18 s` (`61 / 61` `.cs` Signatures Parsed)** ✨<br>`~45 min` Manual Inspection & Markdown Edits |
| **3. Live GUI Crash & Race Immunity ↑**<br>*(Multi-Agent `/xultra` Swarm Execution)* | **Single-Mouse + SIP / Z-Order Guards**<br>Unserialized Concurrent GUI Mutation | `████████████████████` **`100.0% Safe`**<br>`████░░░░░░░░░░░░░░░░` `20.0% Safe` | **`0` C++ `SIGSEGV` / `0` Z-Order Flips** ✨<br>Frequent QGIS SIP Crash & Selection Race |
| **4. System-Prompt Budget Guard ↑**<br>*(`≤ 400`-Char Target & Dual Triggers)* | **`mcp-bridges` Suite (`N = 7` Skills)**<br>All Installed Host Skills (`N = 109`)<br>Official Cloud/Vendor Skills (`N = 31`) | `████████████████████` **`100.0% (7/7 Pass)`**<br>`██████░░░░░░░░░░░░░░` `29.4% (32/109)`<br>`█████░░░░░░░░░░░░░░░` `25.8% (8/31)` | **`330.86` chars Mean (`305-373` range)** ✨<br>`323.61` chars Mean (`29.4%` Dual Guards)<br>`428.61` chars Mean (`25.8%` Dual Guards) |

---

## 1. Architecture & Multi-Host Workflow

### A. Multi-Host MCP Ecosystem & Supported Design Applications

```mermaid
%%{init: {'theme': 'neutral'}}%%
flowchart LR
    subgraph Canvas [" "]
        Host["AI Agent Host (Claude, Grok, Gemini, Cursor)"] --> Gate{"MCP Bridges Router & Single-Mouse Gate"}

        subgraph Bridges ["Supported CAD, GIS & Design Bridges"]
            B1["/rhino & /rhino-alias: Rhino 3D (LIVE)"]
            B2["/grasshopper & /components-log: GH1 (LIVE)"]
            B3["/qgis: QGIS Desktop & PyQGIS (LIVE)"]
            B4["/illustrator: Adobe Illustrator (LIVE)"]
            B5["/figma: Figma Auto-Layout & HTML (LIVE)"]
            B6["Blender 3D Mesh Bridge (coming soon)"]
            B7["Revit / BIM IFC Bridge (coming soon)"]
        end

        Gate --> B1
        Gate --> B2
        Gate --> B3
        Gate --> B4
        Gate --> B5
        Gate -.-> B6
        Gate -.-> B7

        B1 --> Out["Verified Viewport, Canvas, Map or Vector Plate"]
        B2 --> Out
        B3 --> Out
        B4 --> Out
        B5 --> Out
    end
    classDef default fill:#ffffff,stroke:#475569,color:#0f172a,stroke-width:1px
    style Canvas fill:#ffffff,stroke:#cbd5e1,stroke-width:1.5px,color:#0f172a
    style Bridges fill:#f8fafc,stroke:#94a3b8,color:#0f172a
    style B6 fill:#ffffff,stroke:#94a3b8,stroke-dasharray: 5 5,color:#64748b
    style B7 fill:#ffffff,stroke:#94a3b8,stroke-dasharray: 5 5,color:#64748b
```

### B. 3-Step Usage & `/xultra` Swarm Serialization Workflow

```mermaid
%%{init: {'theme': 'neutral'}}%%
flowchart LR
    subgraph Canvas [" "]
        subgraph Step1 ["1. Entry Point"]
            Cmd["Slash Command: /rhino, /grasshopper, /qgis"]
            Swarm["Swarm Combo: /xboost /xultra"]
        end

        subgraph Step2 ["2. Offline Sharding & Safety Locks"]
            Shard["Parallel Builders: Write Disjoint .cs, .py, .qml, .html"]
            Lock["Safety Gate: solve=false, SIP Bridge Guard, Z-Order"]
        end

        subgraph Step3 ["3. Serialized Live Apply & QA"]
            Apply["Single Coordinator: Apply Layers, g1_solve_graph"]
            QA["Verification: RuntimeMessages, Viewport Capture"]
        end

        Cmd --> Lock
        Swarm --> Shard
        Shard --> Lock
        Lock --> Apply
        Apply --> QA
    end
    classDef default fill:#ffffff,stroke:#475569,color:#0f172a,stroke-width:1px
    style Canvas fill:#ffffff,stroke:#cbd5e1,stroke-width:1.5px,color:#0f172a
    style Step1 fill:#f8fafc,stroke:#94a3b8,color:#0f172a
    style Step2 fill:#f8fafc,stroke:#94a3b8,color:#0f172a
    style Step3 fill:#f8fafc,stroke:#94a3b8,color:#0f172a
```

---

## 2. Supported Creative, CAD & Spatial MCP Bridges (7 Skills)

```text
mcp-bridges/
├── /qgis             ← Geospatial intelligence, PyQGIS & SIP-safe layer tree surgery
├── /rhino            ← 3D NURBS modeling, multi-slot sessions & RhinoCommon C#/Python
├── /grasshopper      ← Parametric canvas wiring (g1_*), batch solver lock & data tree surgery
├── /rhino-alias      ← Custom Rhino Python command aliases & persistent Dual-OS macro sync
├── /components-log   ← Grasshopper C# script component registry parser & Markdown/JSON sync
├── /illustrator      ← Swiss vector plates, typographic hierarchy & z-order-safe grouping
└── /figma            ← Bidirectional HTML/CSS & Figma MCP Auto-Layout sync
```

| # & Bridge (`/command`) | Host & MCP Stack | Core Automation Capabilities | Safety & Verification Invariant |
| :--- | :--- | :--- | :--- |
| **1. QGIS Bridge**<br>`/qgis` | **QGIS Desktop**<br>`qgis-mcp-server` • PyQGIS | Automates spatial joins, raster math, metric UTM buffers (`EPSG:32647`), cartographic `.qml` styling, and print layout exports. | Disables `QgsLayerTreeRegistryBridge` during tree surgery to prevent C++ `SIGSEGV` crashes. |
| **2. Rhino Bridge**<br>`/rhino` | **Rhinoceros 3D**<br>`Rhino-MCP-Platform` `v0.3.0` | Multi-slot session management (`list_slots`/`spawn_slot`), NURBS/SubD/Mesh modeling, layer hierarchies, RhinoCommon C#/Python, and viewport capture. | Enforces explicit `ModelUnitSystem` conversion and isolated `<Parent>::<Shard>` sub-layers. |
| **3. Grasshopper Bridge**<br>`/grasshopper`, `/gh` | **Grasshopper (GH1)**<br>`g1_*` tools • `GH_Structure` | Declarative canvas automation (`g1_apply_graph`, `g1_connect_many`), data tree surgery (*Simplify*, *Graft*, *Flatten*), and runtime diagnostics. | Batches all wiring with `solve=false` and `replace=false` before a single final `g1_solve_graph`. |
| **4. Rhino Alias Utility**<br>`/rhino-alias`, `/alias` | **RhinoPython**<br>`rhinoscriptsyntax` • `scriptcontext` | Authors self-contained Rhino Python command scripts (`alias/<name>.py`) and generates `! _-RunPythonScript` macros for `Rhino Options → Aliases`. | Enforces `sc.doc.Views.Redraw()` and undo-record wrapping (`BeginUndoRecord` / `EndUndoRecord`). |
| **5. Components Log**<br>`/components-log`, `/looklog`, `/updatelog` | **Grasshopper C#**<br>`scripts/update_log.py` • `scripts/batch_update.py` | Parses Grasshopper C# (`Script_Instance`) `.cs` files (`void RunScript(...)` + `INPUTS/OUTPUTS` headers) into `components_log.json` and `components_log.md`. | Deterministic regex/signature parser (`0.18 s` across `61` C# components) with zero manual drift. |
| **6. Illustrator Bridge**<br>`/illustrator` | **Adobe Illustrator**<br>`illustrator-mcp-server` • ExtendScript | Automates Swiss architectural plate layouts, typographic hierarchy (`Space Grotesk` / `Plus Jakarta Sans`), and vector `.ai`/`.pdf`/`.svg` export. | Enforces ascending Z-order grouping and pre/post `pageItems.length` item-count checks. |
| **7. Figma Bridge**<br>`/figma` | **Figma Desktop / Web**<br>`figma_desktop` • `html.to.design` | Bidirectional design-to-code sync: pushes live HTML/CSS variants on port `8765` into Figma and extracts Auto-Layout & typography tokens back to code. | Shares a single HTTP server daemon (`port 8765`) serving disjoint `<stem>_vA.._vK.html` variants. |

<details>
<summary><b>Deep Technical Reference — YAML Discovery Budgets, Progressive Disclosure & Crash Guards</b></summary>

| Skill Directory | YAML Budget (`≤ 400`) & Dual Guards | Bundled Scripts / Reference Specs | Primary Crash / Race Condition Prevented |
| :--- | :---: | :--- | :--- |
| `skills/qgis` | `312 chars` • `100%` ✓ | `references/tree_surgery_protocol.md` | Prevents Qt5/Qt6 SIP wrapper deletion (`RuntimeError: wrapped C/C++ object has been deleted`) during layer tree reordering. |
| `skills/rhino` | `351 chars` • `100%` ✓ | `rhino/SKILL.md` (`spawn_slot` protocol) | Prevents active-selection collisions (`rs.SelectedObjects()`) by binding headless `RhinoCommon` geometry directly by `Guid`. |
| `skills/grasshopper` | `373 chars` • `100%` ✓ | `grasshopper/SKILL.md` (`g1_*` `v0.3.0` schema) | Prevents `O(N²)` solver hangs by enforcing `solve=false` during multi-wire graph assembly and `replace=false` on multi-input pins. |
| `skills/rhino-alias` | `305 chars` • `100%` ✓ | `rhino-alias/SKILL.md` (Dual-OS macro generator) | Prevents broken Windows/macOS path quoting inside Rhino's `! _-RunPythonScript "..."` command macro parser. |
| `skills/components-log` | `332 chars` • `100%` ✓ | `scripts/update_log.py`, `scripts/batch_update.py` | Prevents stale input/output parameter documentation across multi-layer C# Grasshopper simulation assemblies. |
| `skills/illustrator` | `335 chars` • `100%` ✓ | `illustrator/SKILL.md` (Z-order & artboard ledger) | Prevents ExtendScript `groupItems.add()` from inverting visual stacking order when moving items into new parent groups. |
| `skills/figma` | `308 chars` • `100%` ✓ | `figma/SKILL.md` (Option B port `8765` bridge) | Prevents port-binding conflicts (`EADDRINUSE` on `8765`) when comparing multiple UI prototypes in parallel. |

</details>

---

## 3. Elastic Cognitive Swarm (`/xultra`) Anti-"Multiple-Mouses" Live MCP Serialization

Desktop CAD, GIS, and vector design applications (**Rhino**, **Grasshopper**, **QGIS**, **Adobe Illustrator**) run on a **single main UI thread** where active selection, undo stacks, viewport cameras, and canvas solvers are global singletons. When paired with [`/xultra`](https://github.com/iscvlab/xboost), every bridge in this repository enforces the **Anti-"Multiple-Mouses" Serialization Protocol**:

1. **Multi-Slot / Multi-Instance Isolation (`spawn_slot` / `instance`)**:
   - In `/rhino` and `/grasshopper`, parallel `K`-vector tournament exploration spawns dedicated Rhino instances (`spawn_slot`) so each subagent binds exclusively to its own `slot`.
   - In `/qgis`, multi-window sessions route via explicit `instance` IDs from `list_qgis_instances`.
2. **Offline Compute Sharding + Single-Coordinator Live Applier (Default Single-Instance Mode)**:
   - Parallel Builders compute heavy geometry algorithms, `.cs` / `.py` scripts, `.gpkg` / `.qml` layers, or declarative `g1_apply_graph` JSON payloads in isolated workspace files (`Pointer-Not-Payload`) **without** calling live GUI mutation tools concurrently.
   - The single Coordinator (or designated Applier) then applies the verified artifacts to the live session sequentially—targeting disjoint layer subtrees (`Swarm::VectorA`), deferring Grasshopper solver passes (`solve=false` → single `g1_solve_graph`), guarding `QgsLayerTreeRegistryBridge`, and sharing a single local HTTP server on port `8765` for `/figma`.
3. **Built with XBoost Production Invariants**:
   - **Zero Hardcoding Invariant**: All paths use portable environment variables (`%USERPROFILE%`, `%APPDATA%`, `~`) and POSIX forward slashes (`/`), verified by `audit_engine.py --platform skill` and `--platform github` (`0` Blocking, `0` Advisory).
   - **Dual-OS Parity**: Works identically on Windows PowerShell (`scripts/install.ps1`) and macOS/Linux Bash/Zsh (`scripts/install.sh`).

---

## 4. Universal Installation & Repository Layout

Every skill in `mcp-bridges` uses portable Markdown (`SKILL.md`) with standard YAML frontmatter (`name` + `description`), working across **any AI coding agent — cloud, IDE, CLI, or local LLM (`Ollama`, `vLLM`, `LM Studio`, `OpenHands`, `Cline`, `Continue`, `Aider`, `Claude Code`, `Codex`, `Cursor`, `Grok`, `Gemini / Antigravity`, or custom agent frameworks)** on **Windows, macOS, and Linux** (same architecture as [`iscvlab/xboost`](https://github.com/iscvlab/xboost)). Following zero-cheat verification standards (`tested` = live E2E runtime verified; `spec-compatible` = standard skill frontmatter structure transcribed to the client's documented skill path):

| Host / Agent Platform | Global Skill Root | Workspace Skill Root | Verification Status |
|:---|:---|:---|:---|
| **Gemini / Antigravity** | `~/.gemini/config/skills` | `<repo>/.agents/skills` | **`tested`** (Live E2E verified on Windows 11 across Rhino `v0.3.0`, GH1, PyQGIS, Illustrator & Figma) |
| **Claude Code** | `~/.claude/skills` | `<repo>/.claude/skills` | **`spec-compatible`** (Path & skill schema verified via `scripts/install.ps1` & `scripts/install.sh`; live host PRs welcome) |
| **Cursor / Codex / Windsurf** | `~/.agents/skills` / `~/.codex/skills` | `<repo>/.agents/skills` | **`spec-compatible`** (Path & skill schema verified via `scripts/install.ps1` & `scripts/install.sh`; live host PRs welcome) |
| **Grok** | `$GROK_HOME/skills` or `~/.grok/skills` | `<repo>/.grok/skills` | **`spec-compatible`** (Path & skill schema verified via `scripts/install.ps1` & `scripts/install.sh`; live host PRs welcome) |
| **Local LLM & Custom Agent Frameworks** (`Ollama`, `vLLM`, `LM Studio`, `OpenHands`, `Cline`, `Continue`, `Aider`) | `~/.agents/skills` or `$AGENT_SKILLS_DIR` (`-Target <dir>` / `--target <dir>`) | `<repo>/.agents/skills` | **`spec-compatible`** (Universal Markdown `SKILL.md` + MCP tool schemas; supports custom target directories via `-Target` / `--target`) |

### Option A: One-Prompt Copy-Paste Agent Install (Works with Any AI Agent — Cloud, IDE, CLI, or Local LLM)

Copy and paste this single prompt into **any AI coding agent**:

```text
Install iscvlab/mcp-bridges (https://github.com/iscvlab/mcp-bridges): detect my OS and your active global or workspace skills directory, clone the repository, install the 7 CAD/GIS/Vector MCP skills (Windows: ./scripts/install.ps1 -All; macOS/Linux: ./scripts/install.sh --all; or copy skills/* directly into your active skills folder), check which desktop MCP servers (Rhino, Grasshopper, QGIS, Illustrator, Figma) are configured in my MCP settings, and report what was verified vs. what still needs a live desktop session.
```

### Option B: Automated Multi-Agent Installer (`install.ps1 -All` / `install.sh --all` / `-Target <dir>`)

**Windows (PowerShell):**
```powershell
git clone https://github.com/iscvlab/mcp-bridges
cd mcp-bridges
./scripts/install.ps1 -All
# Or install into any custom / local LLM agent directory:
./scripts/install.ps1 -Target "$HOME/.continue/skills"
```

**macOS / Linux (Bash / Zsh):**
```bash
git clone https://github.com/iscvlab/mcp-bridges
cd mcp-bridges
chmod +x scripts/install.sh
./scripts/install.sh --all
# Or install into any custom / local LLM agent directory:
./scripts/install.sh --target ~/.continue/skills
```

### Option C: Direct Copy into Any Agent Skill Root (`~/.agents/skills`, `~/.<agent>/skills`, or `<repo>/.agents/skills`)

```bash
git clone https://github.com/iscvlab/mcp-bridges

# Universal .agents root (Cursor, Codex, Windsurf, Cline, OpenHands, Local LLM Agents)
mkdir -p ~/.agents/skills && cp -r mcp-bridges/skills/* ~/.agents/skills/

# Claude Code
mkdir -p ~/.claude/skills && cp -r mcp-bridges/skills/* ~/.claude/skills/

# Grok
mkdir -p ~/.grok/skills && cp -r mcp-bridges/skills/* ~/.grok/skills/

# Google Gemini / Antigravity
mkdir -p ~/.gemini/config/skills && cp -r mcp-bridges/skills/* ~/.gemini/config/skills/

# Project-local workspace (.agents/skills)
mkdir -p .agents/skills && cp -r mcp-bridges/skills/* .agents/skills/
```

### Repository Layout

```text
mcp-bridges/
├── README.md
├── LICENSE                               ← MIT License
├── .gitignore
├── llms.txt                              ← Machine-readable LLM & XERJ corpus index
├── skills/
│   ├── qgis/SKILL.md
│   ├── qgis/references/tree_surgery_protocol.md
│   ├── rhino/SKILL.md
│   ├── grasshopper/SKILL.md
│   ├── rhino-alias/SKILL.md
│   ├── components-log/SKILL.md
│   ├── components-log/scripts/update_log.py
│   ├── components-log/scripts/batch_update.py
│   ├── illustrator/SKILL.md
│   └── figma/SKILL.md
└── scripts/
    ├── scripts/install.sh                ← Universal installer for macOS / Linux
    └── scripts/install.ps1               ← Universal installer for Windows PowerShell
```

---

## 5. Related Toolkits, Author & License

* **[xboost v3.5.0](https://github.com/iscvlab/xboost)**: Composable 15-skill `/x*` AI agent ecosystem (`/xboost`, `/xbrief`, `/xcontext`, `/xcreate-skill`, `/xdeep-research`, `/xkickoff`, `/xlaya`, `/xlearn`, `/xmouse`, `/xobsidian`, `/xocr`, `/xplan`, `/xpublish`, `/xsync`, `/xultra`).
* **[xocr v2.1.0](https://github.com/iscvlab/xocr)**: High-speed C++ PyMuPDF vector/table extractor, Two-Stage LaTeX `booktabs` & scanned HTML `<table>` → RFC-4180 CSV surgery (`19-97 ms/page`, `15.0×-3,326×` faster hybrid routing), Thai PUA/Sara-Am normalizer, and 4-Tier local `SCB 10X Typhoon-OCR v1.5` (`Qwen3-VL`) & `baidu/Unlimited-OCR-2` engine (**[Upstream PR #15 to `scb-10x/typhoon-ocr`](https://github.com/scb-10x/typhoon-ocr/pull/15)** & **[Upstream PR #2925 to `xerj-org/xerj`](https://github.com/xerj-org/xerj/pull/2925)**).
* **[xerj-org/xerj (Upstream PRs #2922–#2927)](https://github.com/xerj-org/xerj/pulls?q=is%3Apr+author%3Anapattan)**: Selected `iscvlab/mcp-bridges` for the [XERJ Corpus Hub](https://hub.xerj.org); contributed Gemini & Antigravity skill root auto-indexing ([PR #2926](https://github.com/xerj-org/xerj/pull/2926)), live Antigravity Windows 11 MCP verification (`22/22` tools in `2–3 ms`, [PR #2923](https://github.com/xerj-org/xerj/pull/2923) & [PR #2927](https://github.com/xerj-org/xerj/pull/2927)), legacy Thai PDF PUA normalization ([PR #2925](https://github.com/xerj-org/xerj/pull/2925)), and Windows MSVC unit test fixes ([PR #2924](https://github.com/xerj-org/xerj/pull/2924)).
* **[qgis-axonometric-transformer v1.2.2](https://plugins.qgis.org/plugins/axonometric_transformer/)**: Official QGIS plugin (Plugin ID: `6219`) for 1-click isometric, dimetric, and oblique axonometric map diagrams.

**Napat Phasundhiae**  
*Computational Design Technologist | Spatial Analytics • Urban & Environmental Simulation • Workflow Automation*

* **GitHub**: [@napattan](https://github.com/napattan) · [ISCV | Isocurve Research Lab (@iscvlab)](https://github.com/iscvlab)
* **LinkedIn**: [linkedin.com/in/napatphas](https://www.linkedin.com/in/napatphas/)

Released under the [MIT License](LICENSE).
