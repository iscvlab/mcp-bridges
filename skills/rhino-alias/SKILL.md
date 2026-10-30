---
name: rhino-alias
description: >
  Write, manage, and configure Rhino Python alias scripts and command macros (/rhino-alias, /alias).
  Use when the user runs /rhino-alias or /alias, or asks to build a custom Rhino Python command alias and macro.
  Do NOT use for Grasshopper canvas wiring (/grasshopper) or live MCP viewport modeling (/rhino).
---

# Rhino Python Command Alias & Macro Builder (`/rhino-alias`)

Build, validate, and register custom Rhino Python alias scripts (`rhinoscriptsyntax` / `RhinoCommon` / `scriptcontext`) with Dual-OS + OneDrive multi-device path parity.

---

## 1. Standard Operating Procedure

1. **Clarify Intent & Target Path**:
   - Confirm what the Rhino alias script should accomplish (selection filter, geometry transformation, layer operation, export macro, etc.) if not already specified.
   - Resolve the target alias directory dynamically:
     * **Workspace Repository (`alias/`)**: Save to `alias/<script_name>.py` if the active workspace contains an `alias/` folder.
     * **Windows Global Alias Directory**: `%USERPROFILE%\Architecture\Rhino\Alias\<script_name>.py` (or user-configured Rhino scripts directory).
     * **macOS Global Alias Directory**: `~/Architecture/Rhino/Alias/<script_name>.py`.
2. **Rhino Python Engineering Standards**:
   - Follow `alias/GUIDE.md` when present in the active workspace.
   - Wrap viewport modifications inside `rs.EnableRedraw(False)` ... `rs.EnableRedraw(True)` (using `try ... finally:`) so batch geometry operations never freeze the Rhino UI.
   - Always guard cancel/empty user selections (`if not obj_ids: return`) cleanly before mutating document state.
   - Use `scriptcontext.doc.Views.Redraw()` when mixing `RhinoCommon` (`Rhino.Geometry`) with `rhinoscriptsyntax`.
3. **Dual-Copy Persistence**:
   - If the active workspace contains an `alias/` directory, save to `alias/<script_name>.py`.
   - Also write or sync the script to the user's global alias path (`~/Architecture/Rhino/Alias/<script_name>.py`) so Rhino can invoke it across projects.
4. **Output Copy-Pasteable Rhino Command Macro**:
   - Present the exact macro string for `Rhino Options → Aliases`:
     * **Windows**: `! _-RunPythonScript "%USERPROFILE%\Architecture\Rhino\Alias\<script_name>.py"`
     * **macOS**: `! _-RunPythonScript "~/Architecture/Rhino/Alias/<script_name>.py"`

---

## 2. Quality Rubric

- [ ] Null/empty selection guard included (`if not ids: return`).
- [ ] `rs.EnableRedraw(False)` wrapped in `try / finally: rs.EnableRedraw(True)` for multi-object operations.
- [ ] Zero hardcoded username paths (`%USERPROFILE%` or `~/` used).
- [ ] Copy-pasteable `! _-RunPythonScript "..."` macro provided.
