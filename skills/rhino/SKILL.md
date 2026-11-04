---
name: rhino
description: >
  3D geometry modeling, layer & object management, RhinoCommon C#/Python automation, viewport rendering, and CAD/GIS bridge via Rhino MCP (/rhino).
  Use when inspecting, modeling, querying, or scripting Rhino 3D geometry or slots.
  Do NOT use for Grasshopper canvas wiring or data tree surgery (/grasshopper) or 2D Adobe Illustrator plates (/illustrator).
---

# Rhino 3D Computational Design & Automation Workflow (`/rhino`)

This skill enables direct AI agent interaction with active **Rhinoceros 3D** sessions via the official McNeel **Rhino MCP Platform** router (`Rhino-MCP-Platform` `v0.3.0+`). It automates 3D CAD/NURBS modeling, multi-slot instance management, layer architecture, programmatic RhinoCommon C#/Python execution, viewport image feedback, and CAD/GIS data exchange across architectural, urban, landscape, product, and engineering workflows.

---

## 1. Availability, Slot Lifecycle & Readiness Check

Before executing any Rhino operation, verify the live connection and target slot:

1. **Verify MCP Server Configuration** (Dual-OS Support: macOS & Windows):
   - **Unified Cross-OS Launcher (`mcp_config.json`)**: Uses a dynamic `node -e` resolver across Windows (`win-x64` / `win-arm64`) and macOS (`osx-arm64` / `osx-x64`) that automatically selects the highest installed `Rhino-MCP-Platform` version:
     ```json
     "rhino": {
       "command": "node",
       "args": [
         "-e",
         "const os=require('os'),fs=require('fs'),p=require('path'),cp=require('child_process'),h=os.homedir(),w=process.platform==='win32',a=process.arch==='arm64'?'arm64':'x64',roots=[p.join(process.env.APPDATA||p.join(h,'AppData','Roaming'),'McNeel','Rhinoceros','packages','8.0','Rhino-MCP-Platform'),p.join(h,'.mcneel','rhinoceros','8.0','packages','Rhino-MCP-Platform'),p.join(h,'Library','Application Support','McNeel','Rhinoceros','packages','8.0','Rhino-MCP-Platform')],r=roots.find(x=>fs.existsSync(x)),b=w?'rhino-mcp-router.exe':'rhino-mcp-router',pf=w?['win-'+a,'win-x64','win-arm64']:['osx-'+a,'osx-arm64','osx-x64'],bin=r&&fs.readdirSync(r).sort((x,y)=>y.localeCompare(x,undefined,{numeric:true})).flatMap(v=>pf.map(d=>p.join(r,v,'router',d,b))).find(x=>fs.existsSync(x));if(!bin){console.error('Rhino-MCP-Platform router not found');process.exit(1);}cp.spawn(bin,process.argv.slice(1),{stdio:'inherit'}).on('exit',k=>process.exit(k??0));"
       ]
     }
     ```
   - **Underlying Binary Paths** (installed via Rhino 8 `_PackageManager` → `Rhino-MCP-Platform`):
     - **macOS (Apple Silicon / Intel)**: `~/Library/Application Support/McNeel/Rhinoceros/packages/8.0/Rhino-MCP-Platform/<version>/router/<osx-arm64|osx-x64>/rhino-mcp-router`
     - **Windows (x64 / ARM64)**: `%APPDATA%/McNeel/Rhinoceros/packages/8.0/Rhino-MCP-Platform/<version>/router/<win-x64|win-arm64>/rhino-mcp-router.exe`
2. **Slot Discovery & Multi-Instance Lifecycle (`list_slots`, `spawn_slot`, `close_slot`, `get_context`)**:
   - **Query Active Slots**: Call `list_slots` (takes `{}`). Running user-opened Rhinos automatically advertise themselves and are adopted under animal-name slot IDs; router-launched Rhinos return spawned slot IDs.
   - **1-Call Context Snapshot**: Call `get_context(slot=...)` for an instant read-only snapshot of active selection, active viewport/camera, document object/layer counts, and open Grasshopper (GH1/GH2) canvas summaries.
   - **Spawn & Close Isolated Slots**:
     - `spawn_slot(version="8"|"9"|"BETA"|"WIP")`: Launches a dedicated Rhino instance and returns its `slot` ID. Pass `slot="<id>"` on subsequent tool calls (`run_python`, `run_csharp`, `open_doc`, `save_doc`, etc.) to target that specific Rhino instance.
     - `close_slot(slot="<id>")`: Closes a router-spawned Rhino instance. *(Note: Never call `close_slot` on a user-started adopted animal-name slot, which returns `cannot_close_adopted`).*
   - **Document Lifecycle (`open_doc`, `save_doc`, `close_doc`, `ask_user`)**:
     - `open_doc(path="<abs_path>", clearFirst=false, slot=...)`: Imports into the current document by default (`clearFirst=false`) or opens in-place (`clearFirst=true`).
     - `save_doc(path="<abs_path.3dm>", slot=...)`: Headlessly saves the document (`*path` is required and overwrites if existing).
     - `close_doc(path=null, slot=...)`: Starts a fresh empty document (optionally saving to `path` first).
     - `ask_user(questions=[...], slot=...)`: Displays a non-blocking prompt in Rhino's AI panel; when `status: "ok"`, **immediately end your turn** and wait for the user's reply.
3. **Check Document Units & Tolerance**:
   - Inspect active units via `get_context` or `__rhino_doc__.ModelUnitSystem`.
   - For site, architectural, and urban modeling, default to **Meters** (`UnitSystem.Meters`) with absolute tolerance `0.01` to `0.001` meters unless the project specifies millimeters (`mm`).
   - When converting units from `mm` to `m`, always verify whether geometry requires `× 0.001` coordinate scaling or unit-label redefinition only.

---

## 2. Core Workflow Modes

### Mode A: Document Discovery & Geometry Inspection
Use this mode to query objects, layer structures, bounding boxes, and geometric integrity:
1. **1-Call Context & Object Query**:
   - Call `get_context(slot=...)` first for overall document state.
   - Use `list_objects(geometryType="point|pointset|curve|surface|brep|mesh|annotation|light|block", layer=null, names=null, includeHidden=false, includeLocked=true, limit=1000, slot=...)` to read bounding box extents, centroids, object IDs, and geometry types.
2. **Inspect Layer & Selection Structure**:
   - Query layer hierarchy, parent-child relationships, and per-layer object counts using `run_python` on `__rhino_doc__`.
   - Inspect active selections via `get_selection(slot=...)` and set focus via `set_selection(ids=[...], layer=..., names=[...], geometryType=..., slot=...)` (note: `set_selection` clears any previous selection first).
3. **Analyze Spatial Extents**:
   - Calculate total model extents (`BoundingBox.Union`) to verify coordinate placement and scale against real-world dimensions.

---

### Mode B: Native Rhino Command Execution
Use this mode to discover and trigger standard Rhino commands:
1. **Discover Commands**:
   - Call `get_commands(filter="<substring>", slot=...)` to search available Rhino command names case-insensitively.
2. **Execute Commands**:
   - Use `run_command(command="_-SelAll ...", slot=...)` with hyphen-prefixed command syntax for non-interactive execution (`_-Purge`, `_-Offset`, `_-BooleanUnion`, `_-Contour`), terminating arguments properly with `_Enter`.
3. **Batch Processing**:
   - Combine selections and transformations using chained commands (e.g. `_-SelLayer "00_CONTEXT" _-Hide`).

---

### Mode C: Programmatic RhinoCommon C# & Python Engine
Use this mode for high-performance geometric computation, custom algorithms, and data transformation:
1. **Python 3 Scripting (`run_python`)**:
   - Both `run_python(script=..., slot=...)` and `run_csharp(script=..., slot=...)` inject **`__rhino_doc__`** as the target slot's `RhinoDoc` handle. **Always use `__rhino_doc__`** (never rely on `scriptcontext.doc`, `rhinoscriptsyntax`, or `RhinoDoc.ActiveDoc` in MCP scripts).
   - Use `System.Drawing.Color` and standard RhinoCommon types (`Rhino.Geometry.*`, `Rhino.DocObjects.*`).
   - Wrap enum lookups safely in Python 3 (e.g. `System.Enum.Parse(EnumClass, "Name")`).
2. **High-Performance C# Scripting (`run_csharp`)**:
   - `System`, `System.Linq`, and `System.Collections.Generic` are pre-imported automatically.
   - Use `run_csharp` with `Parallel.For` and primitive array structures (`double[]`, `Point3d[]`) for point cloud processing, distance matrices, and voxel/mesh calculations, then commit results to `__rhino_doc__` on the main thread.

---

### Mode D: Semantic Layer Hierarchy, Materials & Architectural Standards
Use this mode to maintain clean layer organization and render materials:

1. **Default 4-Tier Semantic Layer Hierarchy** *(when the active workspace does not specify its own layer standard)*:
   * **`00_CONTEXT`** *(Slate Gray `#64748b`)*: Site boundary, surrounding context buildings, roads, waterways, and base topography.
   * **`01_BUILDINGS_FACILITIES`** *(Warm Amber `#d97706`)*: Existing structures, proposed architectural massing, and structural envelopes.
   * **`02_LANDSCAPE_DESIGN`** *(Emerald Green `#059669`)*: Hardscape outlines, paving patterns, planting envelopes, water edges, and grading earthworks.
   * **`03_ANNOTATION`** *(Sky Blue `#0284c7`)*: Section/elevation cut lines, spot levels, callout tags, and legend symbols.
2. **Layer Render Material Assignment (`set_layer_material`)**:
   - Call `set_layer_material(layer="Parent::Child", color="#059669", gloss=0.2, transparency=0.0, applyToLayerColor=true, slot=...)` to configure display/render materials and synchronize viewport wireframe colors.
3. **Safe Layer Purge Protocol**:
   - In Rhino, block definitions (`__rhino_doc__.InstanceDefinitions`) may contain entities referencing otherwise empty CAD layers (e.g. `A-WALL`, `C-TOPO`).
   - **Remap before Purge**: Re-assign internal block entity `LayerIndex` to `Layer 0` via `idef.ModifyGeometry(...)` before calling `__rhino_doc__.Layers.Delete(idx, True)`.

---

### Mode E: Viewport Renders, Camera & Visual Feedback
Use this mode to capture visual verification images directly from the Rhino viewport:
1. **Camera Positioning (`set_camera`, `zoom_to_layer`, `zoom_to_object`)**:
   - Frame specific layers or objects via `zoom_to_layer(layer="...", slot=...)` or `zoom_to_object(ids=[...], slot=...)`.
   - Fine-tune camera placement via `set_camera(location={x,y,z}, target={x,y,z}, up={x,y,z}, projection="parallel"|"perspective", lensLength=..., boxMin={x,y,z}, boxMax={x,y,z}, slot=...)`.
2. **Image Capture (`get_viewport_image`)**:
   - Call `get_viewport_image(view="top"|"bottom"|"left"|"right"|"front"|"back"|"perspective", displayMode="Wireframe"|"Shaded"|"Rendered"|"Ghosted"|"X-Ray"|"Technical"|"Artistic"|"Pen"|"Monochrome"|"Arctic"|"Raytraced", width=480..1280, height=270..720, boxMin={...}, boxMax={...}, cameraLocation={...}, target={...}, zoom=..., slot=...)`.
   - Always inspect the returned JSON metadata (`on-screen object count` and framed scene bounds) alongside the image to verify that target geometry is visible in frame.

---

### Mode F: GIS & CAD Interoperability Bridge ([`/qgis`](../qgis/SKILL.md) ↔ `/rhino`)
Use this mode to align Rhino geometry with metric GIS layers:
1. **Coordinate Alignment**:
   - Preserve real-world metric UTM coordinates (matching the active [`/qgis`](../qgis/SKILL.md) project CRS) or apply a locked document origin offset `(ΔX, ΔY)` when importing GeoJSON / DXF vectors.
2. **Attribute Baking**:
   - Store simulation metadata, spatial evaluation scores, and GIS feature attributes into `Rhino.DocObjects.ObjectAttributes.UserDictionary` / `UserString`.

---

## 3. Composable `/xboost` & `/xultra` Elastic Cognitive Swarm (Anti-"Multiple-Mouses" Protocol)

When `/rhino` is chained with `/xboost` and `/xultra` (`/rhino /xboost /xultra`), parallel subagents **MUST NEVER** fight over the same active selection, command bar, or camera viewport. Enforce this **2-Pillar Anti-"Multiple-Mouses" Execution Protocol**:

1. **Pillar 1 — Multi-Slot Process Isolation (`spawn_slot` → `slot` → `close_slot`) for `K`-Vector Tournaments**:
   - When running an **Archetype 1 (`K`-Vector Tournament)** where competing builders test destructive booleans, heavy mesh operations, or full-model alternatives:
     * Each parallel Builder calls `spawn_slot(version="8")` (or receives a pre-spawned `slot_k` ID from the main thread) and passes `slot=slot_k` on **every** MCP tool call (`open_doc`, `run_python`, `run_csharp`, `save_doc`).
     * Each Builder saves its output via `save_doc(path="<candidate_vK>.3dm", slot=slot_k)` and closes its temporary instance via `close_slot(slot=slot_k)`.
2. **Pillar 2 — Same-Slot Disjoint Sub-Layer Partitioning & Zero-Selection Headless Scripting**:
   - When `N` or `K` parallel Builders operate against a **single shared Rhino document (`slot`)**:
     * **Strictly Forbidden in Wave 1 Parallel Threads**: Never call `set_selection`, `get_selection`, `run_command`, `set_camera`, `zoom_to_layer`, `zoom_to_object`, or `get_viewport_image` concurrently.
     * **Headless Object-Table Writes Only**: Wave 1 subagents write standalone Python/C# scripts (or execute `run_python`/`run_csharp` sequentially) that query inputs by explicit layer/GUID (`__rhino_doc__.Objects.FindByLayer(...)`) and write outputs exclusively to **disjoint sub-layers** (`02_LANDSCAPE_DESIGN::Candidate_vA`, `::Candidate_vB`, or `<ParentLayer>::<Shard_ID>`) via `ObjectAttributes.LayerIndex` + `__rhino_doc__.Objects.Add*(geom, attr)`.
     * **Serialized Wave 2 Blind Critic (`Maker ≠ Checker`)**: A single Critic subagent runs after Wave 1 finishes—calling `get_context` + `list_objects` to verify solid/manifold invariants (`brep.IsSolid`, zero `NaN`/`Inf` coordinates), isolating each candidate layer sequentially to capture `get_viewport_image(view="perspective", displayMode="Arctic", boxMin=..., boxMax=...)`, and promoting the winning geometry.

---

## 4. Visual, Geometric & Safety Verification Checklist

- [ ] **Slot & Document Grounding**: Verified active `slot` via `list_slots` / `get_context` and used `__rhino_doc__` in all `run_python` / `run_csharp` scripts.
- [ ] **Modal Suppression**: Used hyphen-prefixed commands (`_-`) in `run_command` to prevent blocking GUI popups.
- [ ] **Safe Block & Layer Handling**: Checked `__rhino_doc__.InstanceDefinitions` before deleting layers; wrote algorithmic outputs to non-destructive sub-layers.
- [ ] **Geometric Integrity**: Verified Breps are closed/solid (`brep.IsSolid`), meshes are manifold, and curves are closed planar loops where required.
- [ ] **Saved Milestone**: Committed verified changes via `save_doc(path="<abs_path.3dm>", slot=...)`.
