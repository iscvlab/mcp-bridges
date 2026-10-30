---
name: components-log
description: Manage and sync the Grasshopper C# Components Registry Log (/components-log, /looklog, /updatelog). Use when viewing components_log.md (/looklog) or parsing Grasshopper C# script components to update components_log.json and components_log.md (/updatelog). Do NOT use for live canvas wiring (/grasshopper) or Rhino modeling (/rhino).
---

# Components Log (`/components-log`)

## Purpose

Maintain a centralized components registry log (`components_log.md` and `components_log.json`) documenting Grasshopper C# script components (`RunScript`), parameter naming, types, access patterns (`Item`/`List`/`Tree`), and hover descriptions to prevent context loss and signature drift across [`/grasshopper`](../grasshopper/SKILL.md), `/xboost`, and `/xultra` workflows.

## Commands

### 1. View Log (`/looklog`)
Read and display `components_log.md` from the active workspace root.

### 2. Update Single Component (`/updatelog <filepath>`)
Parse the specified C# component file and update `components_log.json` and `components_log.md` in the workspace root:

* **Windows (PowerShell)**:
  ```powershell
  python "$env:USERPROFILE\.gemini\config\skills\components-log\scripts\update_log.py" "<workspace_root>" "<filepath>"
  ```
* **macOS / Linux**:
  ```bash
  python ~/.gemini/config/skills/components-log/scripts/update_log.py "<workspace_root>" "<filepath>"
  ```

### 3. Batch Update All Latest Components
Scan the workspace for the highest-versioned C# script components (`<Prefix>_<Name>_v<N>.cs` or `<Name>_v<N>.cs`) containing `RunScript` and rebuild the registry:

* **Windows (PowerShell)**:
  ```powershell
  python "$env:USERPROFILE\.gemini\config\skills\components-log\scripts\batch_update.py" "<workspace_root>"
  ```
* **macOS / Linux**:
  ```bash
  python ~/.gemini/config/skills/components-log/scripts/batch_update.py "<workspace_root>"
  ```

If a command fails, report the stderr diagnostic and ask the user for guidance.
