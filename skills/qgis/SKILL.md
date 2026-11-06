---
name: qgis
description: Geospatial analysis, layer inspection, geoprocessing, cartographic styling, print layouts, and CAD/Grasshopper export via QGIS MCP (/qgis). Use when inspecting, styling, analyzing, or exporting QGIS layers, maps, or projects. Do NOT use for standalone Leaflet/Turf.js web maps or pure Rhino 3D modeling (/rhino).
---

# QGIS Geospatial Intelligence & Automation Workflow (`/qgis`)

This skill enables direct AI agent interaction with active **QGIS Desktop** sessions via the **QGIS MCP Server** (`nkarasiak/qgis-mcp`). It automates GIS data discovery, spatial analysis, PyQGIS execution, print layout generation, and bridges GIS datasets into Rhino/Grasshopper computational engines and web analytics dashboards.

---

## 1. Availability & Readiness Check

Before executing any QGIS operation, perform the following verification steps:

1. **Verify MCP Server Configuration** (Dual-OS Support: macOS & Windows):
   - **Unified Cross-OS Launcher (`mcp_config.json`)**: Uses a dynamic `node -e` resolver that automatically locates `uvx` across Windows (`%USERPROFILE%\.local\bin\uvx.exe`, `%USERPROFILE%\.cargo\bin\uvx.exe`) and macOS/Linux (`~/.local/bin/uvx`, `~/.cargo/bin/uvx`, `/opt/homebrew/bin/uvx`, `/usr/local/bin/uvx`):
     ```json
     "qgis": {
       "command": "node",
       "args": [
         "-e",
         "const os=require('os'),fs=require('fs'),p=require('path'),cp=require('child_process'),h=os.homedir(),w=process.platform==='win32',e=w?'.exe':'',c=[p.join(h,'.local','bin','uvx'+e),p.join(h,'.cargo','bin','uvx'+e),'/opt/homebrew/bin/uvx','/usr/local/bin/uvx'].find(x=>fs.existsSync(x))||('uvx'+e);cp.spawn(c,process.argv.slice(1),{stdio:'inherit'}).on('exit',k=>process.exit(k??0));",
         "--from",
         "https://github.com/nkarasiak/qgis-mcp/archive/refs/heads/main.zip",
         "qgis-mcp-server"
       ]
     }
     ```
   - **Direct Binary Paths** (when configuring single-OS runners):
     - **macOS**: `~/.local/bin/uvx` or `/opt/homebrew/bin/uvx`
     - **Windows**: `%USERPROFILE%/.local/bin/uvx.exe`
   - **CLI Agent MCP Registration**: `<agent-cli> mcp add qgis -- uvx --from git+https://github.com/nkarasiak/qgis-mcp qgis-mcp-server`
   - Drive QGIS only through native MCP tools. Do not wrap `QgisMCPClient` in a terminal `python` blob unless MCP tools are unavailable.
2. **Verify QGIS Desktop & MCP Plugin Server**:
   - Launching QGIS: On macOS, use `open -a QGIS-LTR` or open from `/Applications/QGIS-LTR.app`. On Windows, open via Start Menu or desktop shortcut.
   - Ensure QGIS Desktop (3.28 LTS or newer) is open on the intended active `.qgz` project file (avoid opening archived backup copies).
   - Confirm the **QGIS MCP Plugin** server is started and listening (default port `9876`).
   - Call `list_qgis_instances`, then `ping` / `diagnose` / `get_qgis_info`. If several QGIS windows exist, pass `instance` so writes hit the intended one.
   - If unreachable, prompt the user:
     > *"Please ensure QGIS Desktop is open and click **'Start Server'** in the QGIS MCP Plugin toolbar (listening on `localhost:9876`)."*
   - If the last PyQGIS call SIGSEGV'd: stop immediately. Do not retry a sibling API. Ask the user to relaunch QGIS and click **Start Server**.
3. **Check Project Context & Active CRS**:
   - Query project details using `get_project_info` and `get_layer_crs`.
   - **Planar / Metric Analysis Protocol (Meso & Micro Site Scale)**: Use metric projected coordinate systems (e.g., `EPSG:32647` UTM Zone 47N or the local UTM zone) for buffers, slopes, area calculations, and CAD/Grasshopper export.
   - **Web / Macro GeoJSON Protocol**: Use geographic CRS (`EPSG:4326` WGS84) for web mapping (Leaflet, Mapbox GL, Turf.js).
4. **Token-Budgeted Operations Guardrail (Anti-Bloat Principle)**:
   - **Bounded Scope (Zero Full-Project Dumps)**: Never execute unbounded discovery calls across the canvas root (e.g., avoid calling full unfiltered `get_layers()`, unconstrained root `get_layer_tree()`, or dumping `mapLayers().values()`). Treat the layer tree as an indexed database: use `find_layer(name="...")` or inspect strictly the immediate target group.
   - **Strict Attribute Limits**: When inspecting layer attributes or schemas, ALWAYS set `limit=3` (or `limit=5`) in `get_layer_features`. Large parcel or land-use layers (`10,000+` polygons) will otherwise return tens of megabytes of raw geometry and text, causing immediate token depletion or agent timeout.
   - **No Full XML Dumps**: When reading `.qgz` project files, parse targeted XML tags (`ElementTree`) rather than printing raw uncompressed XML strings into the agent context.

---

## 2. Task Router Matrix & Workflow Modes (Skill Tree Router)

Before executing any operation, identify your **Task Archetype** below. Execute **ONLY** its mandatory checks and skip the rest to maximize speed and prevent token depletion:

| Task Archetype | Primary Focus | Mandatory Checks (Execute) | Skip (Save Tokens) |
|:---|:---|:---|:---|
| **`[CARTOGRAPHY]`** | Styling, thematic maps, legends, palettes | Sibling Probe → Single-Node Invariant (`Nodes: 1`) → Dual-Transparency (Opacity + Fill Alpha) → Symmetrical Naming | Processing CRS conversions, feature math |
| **`[GEOPROCESSING]`** | Buffers, clips, raster calculator, KDE, zonal stats | Metric Planar CRS (`EPSG:32647`) → Non-destructive output file (never overwrite raw data) → Feature count / geometry check | QML symbology, legend hierarchy |
| **`[INSPECTION]`** | Attribute schema, unique values, extents (Read-only) | Token-capped probe (`limit=3`) → CRS check → Bounded scope (target group only) | Styling, screenshots, `save_project` |
| **`[LAYOUT_EXPORT]`** | Print boards, competition plates, A1 layouts | Canvas frame extent → DPI/resolution (300 DPI) → Legend item filtering → Clean PDF/PNG export | Layer tree surgery, geoprocessing |
| **`[CAD_BRIDGE]`** | Geometry handoff for Rhino / Grasshopper / Web | Metric planar CRS (UTM for CAD, `EPSG:4326` for Web) → Normalized attribute payloads → Clean GeoJSON/DXF | QGIS print layouts, canvas styling |

---

### Mode A: Project & Layer Discovery / Spatial QA
1. **Explore Structure (Scope-Bounded)**:
   - Use `find_layer` with exact name or regex to locate specific layers without dumping the full project layer tree.
   - To inspect a group, query only that specific group node rather than the full project tree.
2. **Inspect Attributes & Schemas (Token-Capped)**:
   - Retrieve sample feature records and schema using `get_layer_features(layer_name="...", limit=3)`.
   - Compute field summaries efficiently via `get_field_statistics` and `get_unique_values`.
   - For raster layers, inspect band counts, dimensions, resolution, and no-data values using `get_raster_info`.
3. **Validate Spatial Bounds & CRS**:
   - Verify layer extent with `get_layer_extent` and CRS with `get_layer_crs`.
   - Flag unprojected data, unclosed polygons, or missing coordinate reference systems.
   - Map-click QA: `identify_features`. Frame the layer with `zoom_to_layer` before screenshots.

---

### Mode B: Geoprocessing Automation & Spatial Modeling
1. **Vector Geoprocessing**:
   - Execute native algorithms via `execute_processing` (e.g., `native:buffer`, `native:clip`, `native:dissolve`, `native:intersection`).
   - Execute spatial joins via `spatial_join` or multi-feature updates.
   - Discover available algorithm IDs and parameter schemas via `list_processing_algorithms` and `get_algorithm_help`.
2. **Raster Surface Analysis & Map Algebra**:
   - Execute map algebra using `raster_calculator` (e.g., NDVI, NDBI, slope, hillshade, heat island LST calculations).
   - Extract zonal summaries (mean, min, max, stdDev) across polygons using `zonal_statistics`.
   - Sample point values across raster grids using `sample_raster_values`.
3. **Attribute Calculations**:
   - Compute new fields or update existing columns using `field_calculator` or `add_field` / `evaluate_expression`.

---

### Mode C: Vector/Raster Styling, Selections & Cartography
1. **Feature Selection & Queries**:
   - Select features by attribute or spatial expression using `select_features` (e.g., `"area" > 10000` or `"category" = 'Park'`).
   - Read active selection via `get_selection` and clear when finished using `clear_selection`.
2. **Styling & Symbology** (layer must already be in the layer tree; see §4):
   - Preferred: `save_style_qml` from a known-good sibling, or write a `.qml` on disk, then `apply_style_qml`.
   - `set_layer_style` is allowed only for `single` or `graduated` on an already-tree layer. Categorized styles: `.qml` + `apply_style_qml` only (do not build categories in `execute_code`).
   - Opacity / rename / scale-visibility: `set_layer_property` (do not rebuild the renderer to change alpha).
   - Configure raster rendering using `set_raster_style`.
   - Configure dynamic vector labeling using `set_layer_labeling`.
3. **Layer Tree & Map Themes**:
   - Add layers with `add_vector_layer` / `add_raster_layer` / `create_memory_layer` (default C++ renderer).
   - **Group-First Protocol for Dual (Labeled / No-Label) Layers**: `create_layer_group` first (e.g., `"Administrative Boundaries"`). `duplicate_layer` for the labeled copy. Unlabeled `visible=true`; labeled `visible=false`. Do not `group.clone()` or build groups in `execute_code`.
   - Same-parent draw order: `set_layer_order`. Cross-group moves: §4.2 tree-move protocol only. Do not call `move_layer_to_group` — it clones a node and can empty the project.
   - Style only after the layer is in its final group. Visibility and themes: `set_layer_visibility`, `add_map_theme`, `apply_map_theme`.
   - Non-destructive multi-tool reads/styles: `batch_commands`. Never batch `execute_code`, `remove_layer`, `delete_features`, `set_setting`, or `reload_plugin`.

---

### Mode D: Print Layout & Board Deliverable Export
1. **Layout Composition**:
   - Create or load print layouts using `create_layout` or `list_layouts`.
   - Add map canvas frame using `add_layout_map` and align extent with `set_canvas_extent` or target layer.
   - Add cartographic components: `add_layout_scalebar`, `add_layout_legend`, `add_layout_label` (title block/metadata), and `add_layout_picture` (north arrow, logo).
2. **Atlas Generation**:
   - Configure multi-page atlas series using `configure_atlas`.
   - Export atlas sheets to multi-page PDF or image sequence with `export_atlas`.
3. **High-Res Export**:
   - Export print-ready boards using `export_layout` (`.pdf`, 300 DPI `.png` or `.tif`).

---

### Mode E: Rhino/Grasshopper & Computational Engine Bridge
1. **Filter & Reproject**:
   - Isolate design intervention boundaries, site fences, topography contours, water bodies, or street centerlines.
   - Ensure the layer is reprojected to the project metric CRS (e.g., `EPSG:32647`).
2. **Export Interoperable Vectors**:
   - Export clean vector datasets using `export_layer` (`.geojson`, `.dxf`, or `.gpkg`) into the active workspace's GIS/CAD staging directory.
3. **Attribute Payload Formatting**:
   - Ensure exported GeoJSON features contain normalized weights/attributes needed for Grasshopper MCDA/MOO solvers or spatial simulations.

---

### Mode F: Direct PyQGIS & SQL Script Execution
Last resort. Prefer MCP tools from Modes A–E. `execute_code` is for processing/SQL that no tool covers — never for constructing symbols or renderers, and never for `group.clone()` / strip-last-node tree surgery (see §4).
1. **Direct PyQGIS Scripting**:
   - Run Python code in the live QGIS runtime using `execute_code`.
   - Access `QgsProject.instance()`, `iface.mapCanvas()`, `QgsProcessingFeedback`, etc.
2. **SQL Layer & Database Operations**:
   - Run spatial SQL queries across layers via `execute_sql`.
   - Connect and manage PostgreSQL / PostGIS databases using `list_connections`, `create_postgresql_connection`, and `execute_connection_sql`.

---

### Mode G: Stepped Contour Density Mapping for Axonometrics (Architectural Isopleth Standard)

When rendering density distributions (Parks, Environmental Plumes, Noise dBA, Demographics) for 3D exploded axonometric plates:

1. **Academic Rigor & Zero-Bias Invariant (Strict Prohibition on Fake Weighting)**:
   - **Never Inject Arbitrary Multipliers**: Never artificially weight spatial points to force a study site into a pre-determined visual peak.
   - **Scale-Appropriate Bandwidth Selection**: Always select KDE search radius (bandwidth `h`) based on physical phenomena at the active scale (e.g., macro atmospheric transport across `3,500m–4,000m` for citywide plumes, vs. `500m–1,000m` for pedestrian walkability).
   - **Dual Spatial Reality Preservation**: Keep Point Density (KDE continuous physical intensity per km²) distinct from Administrative Aggregation (Choropleth total municipal volume per district polygon).
2. **Metric Projected KDE (`EPSG:32647` / Local UTM)**:
   - Execute `qgis:heatmapkerneldensityestimation` in metric units (Radius `3,500m–4,000m` for macro scale, Pixel `60m–100m`, Quartic kernel).
3. **Empirical Percentile Reclassification (`native:reclassifybytable`)**:
   - Reclassify into 4–5 discrete integer tiers `[1..5]` based on empirical distribution percentiles (e.g., P50, P75, P90, P95). Set background/void threshold to `0` (transparent).
4. **Vector Polygonization (`gdal:polygonize`)**:
   - Polygonize the reclassified raster to guarantee **strictly 1 clean outer contour border per tier** with zero internal sub-lines.
5. **Geometric Curve Smoothing (`native:smoothgeometry`)**:
   - Run 4 smoothing iterations (`offset=0.25`) to convert pixel step edges into clean architectural vector curves.
6. **Unclipped Organic Extent**:
   - Do not clip to municipal boundaries; allow the soft contour curves to extend smoothly into surrounding space for clean 3D axonometric plate layering.

---

## 3. Universal Cartographic & Spatial Integrity Protocol (Lean 4-Step Lifecycle)

```
┌─────────────────────────────────────────────────────────────────────────┐
│ 1. TARGETED SIBLING PROBE (Scope: 1 Sibling in Destination Group)       │
│    • Probe ONLY the direct sibling layer in the destination group.      │
│    • Extract 4 parameters: Naming format, Stroke style, Dual            │
│      Transparency (Opacity + Fill Alpha), and Categorization field.     │
│    • Zero project-wide dumps: Never inspect unrelated groups.           │
└────────────────────────────────────┬────────────────────────────────────┘
                                     │
┌────────────────────────────────────▼────────────────────────────────────┐
│ 2. CLEAN INSERTION & SINGLE-NODE INVARIANT (Scope: Target Group)        │
│    • Group-First: Target parent group must exist before insertion.      │
│    • Invariant Check: Exactly 1 legend node per layer.                  │
│      (Verify len([c for c in group if c.layerId() == id]) == 1).        │
│    • Naming Symmetry: Strictly follow sibling naming template:          │
│      "{Prefix} — {Jurisdiction} ({Year})".                              │
│    • Geographic Order: Primary jurisdiction on top, secondary below.    │
└────────────────────────────────────┬────────────────────────────────────┘
                                     │
┌────────────────────────────────────▼────────────────────────────────────┐
│ 3. DUAL-LEVEL TRANSPARENCY & CARTOGRAPHIC PARITY                        │
│    • Global Layer Opacity: layer.opacity() (e.g. 1.0 or 0.85).          │
│    • Symbol Fill Alpha: color="r,g,b,alpha" in QML (e.g. 220 for ~86%). │
│    • Stroke Parity: Matching border color, width (mm), and pen style.   │
│    • Semantic Palette: Matching RGB/Hex for identical land use classes. │
└────────────────────────────────────┬────────────────────────────────────┘
                                     │
┌────────────────────────────────────▼────────────────────────────────────┐
│ 4. LEAN VERIFICATION & INTEGRITY GUARD (Final Step)                     │
│    • Run Lean 1-Line Probe Script (Under 30 tokens of output).          │
│    • Visual QA: Capture 1 targeted canvas screenshot.                   │
│    • Layer Count Safety: Verify len(proj.mapLayers()) before save.      │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.1 Detailed Verification Checklist & Rules of Thumb

1. **Dual-Transparency & Opacity Invariants**:
   - **Presentation & Axonometric Layers (Mandatory 100% Solid)**: All boundary plates, territorial polygons, and presentation thematic layers **MUST have 100% solid opacity (`layer.opacity() == 1.0` and symbol fill `alpha == 255`)**.
   - **Internal GIS Reference / Working Overlays**:
     - **Global Layer Opacity** (`layer.opacity()`): Controls overall rendering rasterization (`0.0` = invisible, `1.0` = full). Set via `set_layer_property(property="opacity", value=1.0)`.
     - **Symbol Fill Alpha** (`color="r,g,b,alpha"` in QML / symbol): Controls polygon fill transparency (e.g., `alpha="220"` ≈ 86% fill opacity over satellite orthomosaics).
     - **Stroke Alpha**: Keep solid (`alpha="255"`) so polygon parcel boundaries stay crisp.
2. **Single-Node Invariant (Zero Duplicate Legend Entries)**:
   - Ensure there is exactly 1 tree node in the legend: `len([c for c in group.children() if c.layerId() == target_layer.id()]) == 1`.
3. **Strict Naming Symmetry Template**:
   - Multi-jurisdiction layers must share identical prefix, naming order, and year notation: `{Prefix} — {Jurisdiction} ({Year})`.
4. **Dual (Labeled / No-Label) Layer Pairs**:
   - Base Layer (`visible=true`): Styled without labels.
   - Labeled Copy (`visible=false`): Duplicate layer styled with labels enabled.

### 3.2 Lean One-Shot Verification Script (Token-Optimized QA)

```python
# Lean Layer QA Probe — outputs 1 line (< 30 tokens)
proj = QgsProject.instance()
layer = proj.mapLayersByName("<Layer Name>")[0]
nodes = [n for n in proj.layerTreeRoot().findLayers() if n.layerId() == layer.id()]
rend = layer.renderer()
sym = rend.symbol() if hasattr(rend, "symbol") else rend.symbols(QgsRenderContext())[0]
sl = sym.symbolLayer(0)

print(f"Layer: {layer.name()} | Nodes: {len(nodes)} | CRS: {layer.crs().authid()} | "
      f"Count: {layer.featureCount()} | Opacity: {layer.opacity():.2f} | "
      f"FillAlpha: {sym.color().alpha()} | Stroke: {sl.strokeColor().name()}:{sl.strokeWidth():.2f}mm")
```

---

## 4. Safety & Best Practice Rules

> [!IMPORTANT]
> **Deep PyQGIS Protocols Disclosed**: Detailed SIP crash mechanics, cross-group layer moves, and broken datasource recovery steps are disclosed in [`references/tree_surgery_protocol.md`](references/tree_surgery_protocol.md).

1. **SIP Symbol Clone Crash Invariant (QGIS 3.28–3.40)**:
   - Python-constructed symbols hold stale C++ pointers. Any later C++ `clone()` or serialization SIGSEGVs (`sipQgsFillSymbol::clone`).
   - Sequence: MCP-add layer → move to group → style via `.qml` + `apply_style_qml` on disk. **NEVER** construct `QgsFillSymbol` or `QgsCategorizedSymbolRenderer` from scratch in `execute_code`.
2. **Layer-Tree Surgery (Zero-Layer Wipe Prevention)**:
   - Removing a layer's last legend node wipes it from the project. MCP `move_layer_to_group` clones nodes and can empty projects.
   - Always disable the bridge before cross-group moves: `proj.layerTreeRegistryBridge().setEnabled(False)` → add to dest → remove old node → re-enable bridge.
   - Verify `len(proj.mapLayers()) > 0` before calling `save_project`.
3. **Broken Datasource Recovery**:
   - If layers show `isValid() == False`, restore relative file links on disk and call `reloadData()` rather than altering layer IDs.
4. **Non-Destructive Processing**:
   - Never mutate original raw input datasets in-place. Always write processing results to new GeoPackages (`.gpkg`), GeoJSON files, or memory layers (`create_memory_layer`).
5. **Transactional Editing**:
   - Bracket direct edits with `start_editing` and `commit_edits` (or `rollback_edits` on error).
6. **Strict Cross-Platform Relative Path Standard**:
   - Never commit or serialize machine-specific absolute paths into `.qgz` project files.

---

## 5. Composable `/xboost`, `/xpublish` & `/xultra` Elastic Cognitive Swarm (Anti-"Multiple-Mouses" QGIS Gate)

Because `QgsProject.instance()`, `QgsLayerTreeRegistryBridge`, and the `iface.mapCanvas()` renderer run on a **single main Qt GUI thread** inside each QGIS instance (and SIP pointers can segfault under concurrent mutation), parallel subagents must never issue concurrent live MCP mutations against the same `instance`.

| Chained Skill | Synergy & Execution Handoff |
|:---|:---|
| **`/qgis` + `/xboost`** | **Falsifiable Spatial & Cartographic Loop**: Formulate CRS/feature-count/symbology invariants first, run the Lean 1-Line QA Probe (§3.2), and verify `len(proj.mapLayers())` before saving. |
| **`/qgis` + `/xpublish`** | **Plugin Packaging Handoff**: When authoring or testing a custom PyQGIS plugin inside QGIS, hand off to `/xpublish` (`--platform qgis`, alias `/xpublish-qgis`) for deterministic Qt6/QGIS 4 lint auditing (`check_qt6.py`) and single-root `.zip` release packaging (`package_qgis.py`). |
| **`/qgis` + `/xultra`** | **Anti-"Multiple-Mouses" QGIS Serialization Gate**: Never allow `N > 1` parallel subagents to call `execute_code`, `add_*_layer`, `apply_style_qml`, or layer-tree moves on the same QGIS `instance` simultaneously. Use one of two safe patterns:<br>1. **Offline GeoPackage / `.qml` Sharding + Serialized Bridge Insertion (Default)**: Parallel Builders run offline spatial scripts (`geopandas`, `shapely`, `pyproj`, `gdal`) or author `.qml` style XML files in isolated disk paths (`Pointer-Not-Payload`); the single Coordinator then attaches the finished `.gpkg`/`.geojson` layers and `.qml` files sequentially to the live `QgsProject.instance()` while guarding `layerTreeRegistryBridge()`.<br>2. **Multi-Instance Window Isolation (`instance`)**: If `list_qgis_instances` reports multiple open QGIS windows on distinct `.qgz` copies, bind each subagent to its own dedicated `instance` ID. |
