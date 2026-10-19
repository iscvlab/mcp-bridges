---
name: figma
description: >-
  Bidirectional HTML/CSS & Figma UI sync workflow using Option B (HTML-to-Design plugin + local HTTP server) and Figma MCP server.
  Use when the user asks to sync, import, or adjust HTML/CSS UI designs with Figma, or mentions /figma or "figma".
  Do NOT use for Adobe Illustrator vector plates, 3D CAD modeling, or pure backend database scripting.
---

# Figma UI/UX Sync & Design Workflow (/figma)

This skill automates the bidirectional design-to-code workflow between Figma and HTML/CSS using **Option B (HTML-to-Design / Local Server)** and **Figma MCP**.

---

## 1. Availability & Readiness Check

Before executing any sync operations, perform the following verification steps:

1. **Check Figma MCP Server Configuration** (Dual-OS Support: macOS & Windows):
   - In `~/.gemini/config/mcp_config.json` (macOS/Linux) or `%USERPROFILE%/.gemini/config/mcp_config.json` (Windows):
     ```json
     "figma": {
       "command": "npx",
       "args": ["-y", "figma-developer-mcp", "--stdio"],
       "env": {
         "FIGMA_API_KEY": "<token>"
       }
     }
     ```
   - Grok CLI (both macOS & Windows):
     `grok mcp add figma -e FIGMA_API_KEY=<token> -- npx -y figma-developer-mcp --stdio`
   - If token is missing, create a Personal Access Token (`file_content:read`) at Figma Settings → Security / Personal Access Tokens.
   - Note: Do NOT use the deprecated `@modelcontextprotocol/server-figma` package. Use Framelink `figma-developer-mcp`.

2. **Check Target HTML File**:
   - Confirm the target HTML file exists in the workspace (e.g., `thesis_architecture.html` or dashboard `index.html`).

3. **Check Local HTTP Server Status (Port 8765)**:
   - Check if a local server is running on port 8765 (e.g., `http://127.0.0.1:8765`).
   - **Autonomous Background Spawning**: If no server is running, the agent can launch one in the background using `run_command` (`IsDaemon: true`):
     - **Windows**: `python -m http.server 8765` (or project `serve.bat` / background runner)
     - **macOS / Linux**: `python3 -m http.server 8765` (or `./serve.sh`)
   - The user never needs to launch servers manually; the agent activates it silently and automatically.

---

## 2. Workflow Modes

### Mode A: Code ➔ Figma Push (Option B HTML-to-Design)

Use this mode when pushing a newly generated or updated HTML page into Figma for visual editing:

1. Serve the target HTML file at local URL (e.g., `http://localhost:8765/<path-to-file>.html`).
2. Provide the user with step-by-step instructions:
   - Open Figma (Browser or Desktop).
   - Launch plugin **`html.to.design`** (or **`Builder.io - Figma to Code`**).
   - Paste the local URL (`http://localhost:8765/...`) into the plugin input.
   - Click **Import** to convert the live DOM into editable Figma Auto-Layout frames.

---

### Mode B: Figma ➔ Code Pull (MCP Node Sync)

Use this mode when the user has visually tweaked frames in Figma and wants to sync the changes back into HTML/CSS code:

1. Ask the user for the Figma frame/node URL (e.g., `https://www.figma.com/design/.../file?node-id=101:2`).
2. Call Framelink `get_figma_data` with the file URL (optional `nodeId` / `fileKey`). Use `download_figma_images` when raster/SVG assets are needed. Extract:
   - Auto Layout specs (`flex-direction`, `gap`, `padding-top`, `padding-left`, `align-items`, `justify-content`).
   - Visual tokens (`background-color`, `border-radius`, `box-shadow`, `border`).
   - Typography (`font-family`, `font-size`, `font-weight`, `line-height`, `letter-spacing`).
3. Compute diffs against the local CSS/HTML files.
4. Update workspace code files using standard editing tools, strictly respecting project design protocols (e.g., `docs/UI_THEME_PROTOCOL.md` CSS variables if present).

---

## 3. Visual Browser Verification

After updating HTML/CSS from Figma:

1. Access the local web server URL (`http://localhost:8765/...`).
2. Use `browser_subagent` to visually verify the rendered output.
3. Confirm clean rendering, proper responsive bounds, and zero runtime console errors.
4. Report the sync completion summary to the user.
