---
name: grasshopper
description: Parametric definition authoring, component wiring, data tree surgery, and solver automation via Rhino MCP g1_* tools and Python/C# (/grasshopper, /gh). Use when creating, debugging, wiring, or solving Grasshopper definitions, or managing data trees (Graft/Flatten/Simplify). Do NOT use for standalone Rhino 3D modeling without a canvas (/rhino) or QGIS cartography (/qgis).
---

# Grasshopper Parametric Definition & Data Tree Protocol (`/grasshopper`, `/gh`)

Use this skill when the user invokes `/grasshopper` or `/gh`, or asks to create, wire, inspect, debug, or optimize Grasshopper (`.gh` / `.ghx`) parametric definitions via the **`rhino` MCP server (`Rhino-MCP-Platform` `v0.3.0`)**.

---

## 0. Pre-Flight MCP & Canvas Inspection

Before placing components or mutating wires on an active Grasshopper canvas, always inspect the live state:
1. **Launch / Connect Grasshopper (`g1_start`)**: Ensure the Grasshopper plugin and canvas are active inside the target Rhino instance (`slot`).
2. **Context & Canvas Graph Audit (`get_context` + `g1_get_canvas_graph`)**:
   - Call `get_context` (optional `slot`) for a unified snapshot of Rhino document/layers/objects alongside open GH1/GH2 canvas summaries.
   - Call `g1_get_canvas_graph` (`include_data`: `true` default, `sample_size`: `3` default, optional `slot`) to inspect all existing component GUIDs, nicknames, wire connections, data tree samples, and runtime errors/warnings.
3. **Component Discovery (`g1_search_components` → `g1_describe_component`)**:
   - Never guess a component's internal name or parameter nickname. Search first with `g1_search_components(query=...)`, then call `g1_describe_component(name=...)` to verify exact input/output parameter names, types, and `Access` modes (`item`, `list`, `tree`).

---

## 1. Rhino MCP `g1_*` Tool Catalog & Exact `v0.3.0` Parameter Schemas

All `g1_*` tools accept an optional `slot` string when targeting a named multi-instance Rhino session (see `list_slots` / `spawn_slot` in `/rhino`).

| Tool | Purpose & Exact `v0.3.0` Schema Notes |
|:---|:---|
| `g1_start` | Open Grasshopper inside the active Rhino session and initialize the canvas bridge (`slot` optional). |
| `g1_get_canvas_graph` | Return canvas components, wires, runtime diagnostics, and live output data (`include_data` default `true`, `sample_size` default `3`, `slot` optional). |
| `g1_search_components` | Search installed Grasshopper and plugin components (`query` required; optional `category`, `subcategory`, `includeDeprecated` default `false`, `limit` default `20`, `slot`). |
| `g1_describe_component` | Inspect a component's exact input/output parameter names, types, and access modes (`name` required; optional `includeDeprecated` default `false`, `slot`). |
| `g1_place_component` | Place a component on the canvas (`selector` required — Component Guid or Name; optional `includeDeprecated` default `false`, `x` default `100`, `y` default `100`, `solve` default `true`, `slot`). Pass `solve=false` during multi-step wiring. |
| `g1_place_slider` | Place a numeric slider (`min`, `value`, `max` required; optional `type`: `"float"` \| `"int"` \| `"even"` \| `"odd"`, `name`, `x`, `y`, `solve` default `true`, `slot`). |
| `g1_connect` | Wire one output to one input (`src_id`, `src`, `dst_id`, `dst` required; optional `replace` default `true`, `solve` default `true`, `slot`). **Crucial**: Set `replace=false` when connecting multiple wires into a multi-input parameter (e.g., `Merge`, `Addition`, `Entwine`), and `solve=false` until wiring is complete. |
| `g1_connect_many` | Batch-wire multiple connections in a single call (`wires` required — array of `{SrcId, Src, DstId, Dst}`; optional top-level `replace` default `true`, `solve` default `true`, `slot`). |
| `g1_apply_graph` | Declaratively build a subgraph of sliders, components, and wires in one transaction (`sliders`, `components`, `wires` array of `{SrcKey, Src, DstKey, Dst}` required; optional `replace` default `true` — removes prior wires on targeted destination inputs before wiring when `true`, or appends alongside existing wires when `false`; `includeDeprecated` default `false`, `solve` default `true`, `slot`). |
| `g1_solve_graph` | Recompute the Grasshopper canvas and return structured solve results (`zoom_views`: `true` \| `false` \| `null` default `null`, `slot` optional). |
| `g1_delete_component` | Delete a specific component from the canvas (`selector` required — Component instance Guid; optional `solve` default `false`, `slot`). |
| `g1_clear_canvas` | Remove all components from the active Grasshopper document (`confirm` required — must pass `confirm=true` as a safety guard; optional `solve` default `true`, `slot`). |

---

## 2. Solver Lock & Batch Wiring Discipline (`solve=false` → `g1_solve_graph`)

Because `g1_place_component`, `g1_place_slider`, `g1_connect`, `g1_connect_many`, and `g1_apply_graph` default to **`solve=true`** in `v0.3.0`, calling incremental placement/wiring tools one-by-one with default arguments triggers a full Grasshopper solver recomputation on every single wire—causing UI freezes on heavy spatial or mesh definitions.

### Mandatory Batch Wiring Pattern
1. **Prefer `g1_apply_graph`** when constructing a new node cluster so all `sliders`, `components`, and `wires` (`{SrcKey, Src, DstKey, Dst}`) are placed and solved in a single pass. Set `replace=false` when wiring into destination inputs that already hold upstream wires you want to keep!
2. **When using incremental calls (`g1_place_component`, `g1_place_slider`, `g1_connect`, `g1_connect_many`)**:
   - Explicitly pass **`solve=false`** on every intermediate placement and connection call.
   - Explicitly pass **`replace=false`** whenever appending an additional wire to an input that already holds a wire.
   - Call **`g1_solve_graph`** **once** at the end of the wiring sequence and inspect its returned runtime messages.

```json
// Example: Incremental wiring with solver deferred and multi-input preserved
// 1. Place component with exact v0.3.0 schema (selector, x, y, solve=false)
{"selector": "Offset Curve", "x": 300, "y": 150, "solve": false}

// 2. Place slider with exact v0.3.0 schema (min, value, max, type, solve=false)
{"min": 0.0, "value": 5.0, "max": 20.0, "type": "float", "name": "OffsetDist", "x": 100, "y": 150, "solve": false}

// 3. Connect wire using exact v0.3.0 schema (src_id, src, dst_id, dst, replace, solve)
{"src_id": "<slider-guid>", "src": "Output", "dst_id": "<offset-guid>", "dst": "Distance", "replace": true, "solve": false}

// 4. Trigger a single solver pass once all wires are in place
{"zoom_views": false} // g1_solve_graph
```

---

## 3. Data Tree Surgery Protocol (Graft, Flatten, Simplify, Path Mapper)

90% of Grasshopper bugs come from **Data Tree path mismatches** causing unintended Cartesian cross-products (`100 × 100 = 10,000` geometries instead of `100` paired operations).

1. **Inspect Before Wiring**: Check whether upstream outputs emit `Item` (`{0}`), `List` (`{0}[i]`), or `Tree` (`{0;b}[i]`) structures via `g1_get_canvas_graph(include_data=true, sample_size=3)`.
2. **Match Branch Depth & Count (`Simplify`)**:
   - When two inputs represent 1-to-1 paired branches (e.g., 50 building footprints in `{0;0}`..`{0;49}` and 50 height values in `{0;0;0}`..`{0;0;49}`), **Simplify** both inputs or use `Trim Tree` so branch paths align (`{0}`..`{49}`) before they enter a component.
3. **Controlled `Graft` vs. `Flatten`**:
   - **Graft** when each item in a list requires its own isolated sub-operation (e.g., lofting curve pairs per floor).
   - **Flatten** only when aggregating into a global collection (e.g., `Bounding Box (Union)`, `Mesh Join`, or final spatial index). Never blindly Flatten mid-pipeline if branch metadata maps back to feature attributes.
4. **Heavy Iterations in C# / Python (`GH_Structure` / `DataTree<T>`)**:
   - When a data tree operation requires complex conditional filtering, spatial R-Tree indexing, or graph traversal, encapsulate it inside a single compiled **C# Script component** (`DataTree<T>` / `IGH_DataTree`, tracked via `/components-log`) or **GHPython script** rather than chaining 30+ native list-management nodes.

---

## 4. Composable `/xboost`, `/components-log` & `/xultra` Elastic Cognitive Swarm (Anti-"Multiple-Mouses" Canvas Gate)

Because the Grasshopper canvas and `GH_Document` solver run on **Rhino's single UI thread**, concurrent `g1_*` calls from parallel subagents against the same Rhino slot will interleave wires, trigger mid-wire solver race conditions, or overwrite existing input wires when `replace=true`.

| Chained Skill | Synergy & Execution Handoff |
|:---|:---|
| **`/grasshopper` + `/xboost`** | **Falsifiable Data-Tree & Solver Loop**: Formulate a hypothesis on branch counts/paths (`{A;B}(N)`) before wiring, execute via `solve=false` → `g1_solve_graph`, and verify zero `Warning`/`Error` runtime messages on the canvas. |
| **`/grasshopper` + `/components-log`** | **C# Node Registry Sync**: Whenever authoring or updating custom `.cs` Grasshopper script components, run `/updatelog` (`/components-log`) to keep `components_log.json` and `components_log.md` synchronized. |
| **`/grasshopper` + `/xultra`** | **Anti-"Multiple-Mouses" Canvas Serialization Gate**: Never allow `N > 1` parallel subagents to call `g1_place_*`, `g1_connect*`, `g1_apply_graph`, or `g1_solve_graph` on the same Rhino `slot` simultaneously. Use one of two safe patterns:<br>1. **Offline C# / JSON Subgraph Sharding + Single Canvas Applier (Default)**: Parallel Builders generate self-contained `.cs` script components or declarative `g1_apply_graph` JSON payloads (`sliders`, `components`, `wires`) in isolated workspace files (`Pointer-Not-Payload`); the single Coordinator validates and applies them sequentially via `g1_apply_graph(replace=false, solve=false)` → single `g1_solve_graph`.<br>2. **Isolated Multi-Slot Tournament (`spawn_slot`)**: For `K`-vector parametric exploration, spawn dedicated Rhino instances (`slot_A`, `slot_B`) so each subagent binds exclusively to its own `slot`. |

---

## 5. Verification Checklist

Before concluding any `/grasshopper` task:
- [ ] All component placements and wires use verified `v0.3.0` parameter names (`selector`, `src_id`, `src`, `dst_id`, `dst`, `wires`, `min`, `value`, `max`).
- [ ] Multi-step wiring used `g1_apply_graph` or `solve=false` followed by a single `g1_solve_graph` pass.
- [ ] `g1_get_canvas_graph` confirms **0 `Error`** and **0 unintended `Warning`** runtime messages across all wired components.
- [ ] If custom C# components (`.cs`) were added or modified, `/components-log` is flagged or executed.
