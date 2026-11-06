---
name: figma
description: Bidirectional HTML/CSS and Figma UI sync workflow via Option B (HTML-to-Design + local HTTP server) and Figma MCP (/figma). Use when syncing, importing, or adjusting HTML/CSS UI designs with Figma. Do NOT use for Adobe Illustrator vector plates (/illustrator), 3D CAD modeling (/rhino), or backend scripting.
---

# Figma UI/UX Sync & Design Workflow (`/figma`)

This skill automates the bidirectional design-to-code workflow between Figma and HTML/CSS using **Option B (HTML-to-Design / Local HTTP Server)** and the **Figma MCP Server** (`figma-developer-mcp` or `figma_desktop`).

---

## 1. Availability & Readiness Check

Before executing any sync operations, perform the following verification steps:

1. **Check Figma MCP Server Configuration** (Dual-OS Support: macOS & Windows):
   - Supports either the **Figma Desktop MCP** server (`figma_desktop`) or **Framelink `figma-developer-mcp`** in your AI agent's MCP configuration (`mcp_config.json` or `.mcp.json`):
     ```json
     "figma": {
       "command": "npx",
       "args": ["-y", "figma-developer-mcp", "--stdio"],
       "env": {
         "FIGMA_API_KEY": "<token>"
       }
     }
     ```
   - CLI Agent MCP Registration (macOS & Windows):
     `<agent-cli> mcp add figma -e FIGMA_API_KEY=<token> -- npx -y figma-developer-mcp --stdio`
   - If the token is missing, create a Personal Access Token (`file_content:read`) at *Figma Settings → Security / Personal Access Tokens*.
   - Note: Do NOT use the deprecated `@modelcontextprotocol/server-figma` package.
2. **Check Target HTML File**:
   - Confirm the target HTML file exists in the workspace (e.g., `index.html` or the active dashboard/presentation `.html` file).
3. **Check Local HTTP Server Status (Port `8765`)**:
   - Check if a local server is running on port `8765` (`http://127.0.0.1:8765`).
   - **Autonomous Background Spawning**: If no server is running, launch **one** background server using `run_command` (`IsDaemon: true`, `WaitMsBeforeAsync: 500`):
     - **Windows**: `python -m http.server 8765`
     - **macOS / Linux**: `python3 -m http.server 8765`
   - Never spawn duplicate HTTP servers on port `8765` if one is already active.

---

## 2. Workflow Modes

### Mode A: Code → Figma Push (Option B HTML-to-Design)

Use this mode when pushing a newly generated or updated HTML page into Figma for visual editing:

1. Serve the target HTML file at a local URL (`http://localhost:8765/<path-to-file>.html`).
2. Provide the user with concise import instructions:
   - Open Figma (Browser or Desktop).
   - Launch plugin **`html.to.design`** (or **`Builder.io - Figma to Code`**).
   - Paste the local URL (`http://localhost:8765/...`) into the plugin input and click **Import** to convert the live DOM into editable Figma Auto-Layout frames.

---

### Mode B: Figma → Code Pull (MCP Node Sync)

Use this mode when the user has visually tweaked frames in Figma and wants to sync the changes back into HTML/CSS code:

1. Ask the user for the Figma frame/node URL (`https://www.figma.com/design/.../file?node-id=101:2`) or active Figma Desktop selection.
2. Call `get_figma_data` with the file URL (optional `nodeId` / `fileKey`) and `download_figma_images` when raster/SVG assets are needed. Extract:
   - Auto Layout specs (`flex-direction`, `gap`, `padding-top`, `padding-left`, `align-items`, `justify-content`).
   - Visual tokens (`background-color`, `border-radius`, `box-shadow`, `border`).
   - Typography (`font-family`, `font-size`, `font-weight`, `line-height`, `letter-spacing`).
3. Compute diffs against the local CSS/HTML files.
4. Update workspace code files using standard editing tools, respecting any active workspace design protocol (e.g., `docs/UI_THEME_PROTOCOL.md` CSS custom properties if present) and `/ui-design-brain` component conventions.

---

## 3. Visual Verification

After updating HTML/CSS from Figma:
1. Verify that the local HTTP server (`http://localhost:8765/...`) serves the updated file cleanly with HTTP `200`.
2. Inspect rendered layout, responsive bounds, and ensure zero runtime console or CSS syntax errors.
3. Report the sync completion summary to the user.

---

## 4. Composable `/ui-design-brain`, `/xboost` & `/xultra` Elastic Cognitive Swarm

| Chained Skill | Synergy & Execution Handoff |
|:---|:---|
| **`/figma` + `/ui-design-brain`** | **Component Pattern Grounding**: When pulling Figma frames into HTML/CSS or preparing pages for Option B import, apply `/ui-design-brain` component patterns and CSS custom properties (`var(--token)`). |
| **`/figma` + `/xboost`** | **DOM-to-Auto-Layout Fidelity Loop**: Verify CSS flexbox/grid alignment, computed styles, and zero clipped text containers before and after syncing with Figma. |
| **`/figma` + `/xultra`** | **Single Port-`8765` Daemon + Disjoint `_vA.._vK.html` Tournament**: When running a `K`-vector UI exploration swarm (`/figma /ui-design-brain /xultra`), the Coordinator starts a **single** HTTP server on port `8765` (parallel subagents must never call `python -m http.server 8765` concurrently). Each Builder writes to a disjoint file (`<page>_vA.html`..`<page>_vK.html`) served simultaneously at `http://localhost:8765/<page>_vA.html`..`_vK.html` for side-by-side Figma import or blind visual judging. |
