---
name: grasshopper
description: >-
  Parametric definition authoring, component wiring, data tree surgery, and solver automation via Rhino MCP g1_* tools and Python/C# (/grasshopper, /gh).
  Use when creating, debugging, wiring, or solving Grasshopper definitions, or managing data trees (Graft/Flatten/Simplify).
  Do NOT use for standalone Rhino 3D modeling without a canvas (/rhino) or QGIS cartography (/qgis).
---

# Grasshopper Parametric Engine & Automation Workflow (/grasshopper)

This skill enables direct AI agent interaction with active **Grasshopper (GH1)** parametric canvases via the **Rhino MCP Grasshopper Bridge** (`g1_*` tools) and programmatic `Grasshopper.Instances.ActiveCanvas.Document` automation. It automates parametric algorithm authoring, data tree surgery, component wiring, solver diagnostics, and bi-directional Rhino/GIS synchronization.

---

## 1. Availability & Readiness Check

Before executing Grasshopper operations:

1. **Verify Rhino & Grasshopper Connection** (Dual-OS Support: macOS & Windows):
   - Grasshopper rides on the **rhino** MCP server (`g1_*` tools). Ensure `rhino` is running in `mcp_config.json`.
   - Ensure Rhino 8 is active with `MCPStart` listening on port `10501` (works identically on macOS and Windows).
   - Call `list_slots`, then `g1_get_canvas_graph`.
   - If Grasshopper is closed or not initialized, call `g1_start` or prompt the user:
     > *"Please open Grasshopper in Rhino (type `_Grasshopper` in macOS or `Grasshopper` in Windows command bar).*"

2. **Inspect Canvas State**:
   - Query active objects, component types, input/output parameters, and volatile data summaries using `g1_get_canvas_graph` (`include_data=true`).

---

## 2. Core Workflow Modes

### Mode A: Canvas Discovery & Component Inspection
Use this mode to inspect canvas components, parameters, and active runtime states:
1. **Explore Graph Topology**:
   - Retrieve full object list and wire connections using `g1_get_canvas_graph`.
   - Search for specific component GUIDs or names using `g1_search_components`.
   - Inspect component parameter descriptions and type expectations with `g1_describe_component`.
2. **Volatile Data Inspection**:
   - Inspect data branch paths, item counts, and data types flowing through wires.
   - Flag mismatching branch counts or empty/null branches.

---

### Mode B: Parametric Graph Construction & Wiring
Use this mode to build, place, and wire algorithmic networks on the canvas:
1. **Component Placement**:
   - Place components onto canvas coordinates using `g1_place_component` (`selector="Loft"`, `x=800`, `y=300`, `solve=false`).
   - Place numerical sliders using `g1_place_slider` (`name="Distance"`, `val=5.0`, `min=0.0`, `max=50.0`, `digits=2`).
2. **Wiring Components**:
   - Connect parameters using `g1_connect` (`from_id`, `from_param`, `to_id`, `to_param`).
   - Batch connect multiple wires using `g1_connect_many`.
3. **Graph Replacement / Templates**:
   - Construct or replace entire graph definitions using `g1_apply_graph`.

---

### Mode C: Data Tree Alignment & Tree Surgery
Use this mode to resolve tree depth mismatches, grafting/flattening issues, and multi-stream pairing:
1. **Data Tree Matching Principles**:
   - **Graft (`↑`)**: Creates a new branch for every single item (`{0}` with 5 items → `{0;0}`, `{0;1}`, ..., `{0;4}`).
   - **Flatten (`↓`)**: Collapses all branches into a single list (`{0}`).
   - **Simplify**: Removes leading ancestral branch indices that are shared across all paths (`{0;0;1}` → `{1}`).
2. **Plugin Sub-Branch Handling**:
   - Plugins like *Pufferfish*, *Anemone*, or *Kangaroo* often add extra nested path dimensions (e.g. `OffCrv` outputting `{0;i}` instead of `{i}`).
   - **Flatten-before-Graft Protocol**: When combining native inputs with plugin outputs into a `Merge` or multi-input component, flatten incoming streams to `{0}` before applying `Graft` to ensure identical branch depths (`{0}`, `{1}`, ..., `{N-1}`).
3. **Multi-Input Pairing**:
   - Prefer using a dedicated **`Merge`** component before multi-curve operations (`Loft`, `Ruled Surface`, `Brep Join`) rather than shift-dragging multiple wires directly into single parameter slots.

---

### Mode D: Solver Execution & Error Diagnostics
Use this mode to solve definitions and resolve runtime errors:
1. **Trigger Solution**:
   - Solve the active canvas using `g1_solve_graph` or programmatic `gh_doc.NewSolution(True)`.
   - Invalidate canvas display using `Grasshopper.Instances.ActiveCanvas.Invalidate()`.
2. **Error & Warning Inspection**:
   - Query component runtime messages:
     - `RuntimeMessages(GH_RuntimeMessageLevel.Error)` → Red components (e.g. *"Loft could not be constructed"*).
     - `RuntimeMessages(GH_RuntimeMessageLevel.Warning)` → Orange components (e.g. *"Input parameter contains null data"*).
   - Trace backwards from the red component to find where data became empty or misaligned.

---

### Mode E: Custom C# & Python 3 Components
Use this mode when native components are insufficient for complex simulation or algorithms:
1. **Rhino 8 Python 3 / C# Script Components**:
   - Write multi-threaded computational loops (`Parallel.For`) inside C# script components for 10x-100x performance in agent pathfinding, MCDA overlays, and raycasting.
2. **Environmental & Simulation Plugins**:
   - Coordinate workflows with Ladybug Tools (Solar PV yield, UTCI microclimate), Butterfly / OpenFOAM (CFD odor plume dispersion), and KovaPedSim (pedestrian agents).

---

### Mode F: Automated Geometry Baking & Layer Sync
Use this mode to bake parametric outputs directly into structured Rhino layers:
1. **Layer-Targeted Baking**:
   - Use `Elefront` or custom RhinoCommon Python to bake geometry directly into standard semantic groups (`02_LANDSCAPE_DESIGN`, `01_ON_NUT_FACILITIES`).
   - Attach user attributes (`UserText` / `UserDictionary`) containing simulation metrics, area calculations, or parametric IDs.

---

## 3. Data Tree Debugging Diagnostic Protocol

When a Grasshopper component is red or producing unexpected results, follow this 4-step checklist:

1. **Step 1: Check Path Counts & Depths**:
   - Does Wire A have N branches while Wire B has M branches?
   - Does Wire A have depth 1 (`{0}`) while Wire B has depth 2 (`{0;0}`)?
2. **Step 2: Check Items-per-Branch**:
   - Components expecting pairs (e.g. `Loft` between 2 rails, `Line` from 2 points) must receive **2 items per branch**, not 1 item across 2 separate branches.
3. **Step 3: Check for Nulls & Invalid Geometries**:
   - Insert `Clean Tree` (`Clean`) to remove nulls or empty branches generated by failed offsets or intersections.
4. **Step 4: Check Curve Seams & Directions**:
   - If lofts/surfaces twist like candy wrappers, insert **`Flip Curve`** with a guide curve, or **`Adjust Closed Curve Seam`** (`Seam`).

---

## 4. Safety & Canvas Hygiene Rules

1. **Infinite Solution Loops**: Never connect an output back to an input without a specialized iterative component (like *Anemone* or *Hoopsnake*).
2. **Heavy Computations**: When adding heavy simulation components (Ladybug / Kangaroo / Volumetric Booleans), place components with `solve=false` first, configure all input sliders, and solve once.
3. **Canvas Layout**: Keep canvas organization tidy with left-to-right signal flow and aligned component clusters.
4. **Do Not Block UI**: Avoid synchronous sleep or blocking loops inside Grasshopper script components.
