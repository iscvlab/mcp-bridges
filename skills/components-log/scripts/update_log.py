import json
import os
import re
import sys

sys.dont_write_bytecode = True
if sys.stdout and hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")


def get_layer_from_path(filepath):
    normalized = filepath.replace("\\", "/")
    match = re.search(r"/L(\d+)_", normalized)
    if match:
        return f"L{match.group(1)}"
    base = os.path.basename(normalized)
    match = re.search(r"^L(\d+)_", base)
    if match:
        return f"L{match.group(1)}"
    prefix_match = re.match(r"^([A-Za-z0-9]+)_", base)
    if prefix_match:
        return prefix_match.group(1)
    parent = os.path.basename(os.path.dirname(normalized))
    return parent if parent else "General"


def infer_access(type_str, comment_access=""):
    low_acc = comment_access.lower()
    if "tree" in low_acc or "datatree" in low_acc or "gh_structure" in low_acc:
        return "Tree"
    if "list" in low_acc:
        return "List"
    if "item" in low_acc:
        return "Item"
    if type_str.startswith(("DataTree<", "GH_Structure<", "IGH_Structure")):
        return "Tree"
    list_prefixes = ("List<", "IList<", "IEnumerable<")
    if type_str.startswith(list_prefixes) or type_str.endswith("[]"):
        return "List"
    return "Item"


def parse_runscript_params(content):
    match = re.search(r"void\s+RunScript\s*\((.*?)\)\s*\{", content, re.DOTALL)
    if not match:
        match = re.search(r"void\s+RunScript\s*\((.*?)\)", content, re.DOTALL)
        if not match:
            return [], []

    params_str = match.group(1)
    params = []
    current = []
    bracket_depth = 0
    for char in params_str:
        if char == "<":
            bracket_depth += 1
        elif char == ">":
            bracket_depth -= 1

        if char == "," and bracket_depth == 0:
            params.append("".join(current).strip())
            current = []
        else:
            current.append(char)
    if current:
        params.append("".join(current).strip())

    inputs = []
    outputs = []
    for p in params:
        p_clean = p.split("=")[0].strip()
        if not p_clean:
            continue
        parts = p_clean.split()
        if "ref" in parts:
            ref_idx = parts.index("ref")
            p_type = parts[ref_idx + 1]
            p_name = parts[ref_idx + 2]
            outputs.append({"name": p_name, "type": p_type})
        elif "out" in parts:
            out_idx = parts.index("out")
            p_type = parts[out_idx + 1]
            p_name = parts[out_idx + 2]
            outputs.append({"name": p_name, "type": p_type})
        else:
            p_name = parts[-1]
            p_type = " ".join(parts[:-1])
            inputs.append({"name": p_name, "type": p_type})

    return inputs, outputs


def parse_header_comment(content):
    match = re.search(r"/\*(.*?)\*/", content, re.DOTALL)
    if not match:
        return None, [], []

    comment = match.group(1)
    lines = comment.split("\n")

    title = ""
    for line in lines:
        cleaned = line.strip().replace("=", "").strip()
        if (
            cleaned
            and not cleaned.startswith("*")
            and not cleaned.startswith("INPUTS:")
            and not cleaned.startswith("OUTPUTS:")
        ):
            title = cleaned
            break

    inputs_section = []
    outputs_section = []
    current_section = None

    for line in lines:
        upper_line = line.strip().upper()
        if "INPUTS:" in upper_line:
            current_section = "INPUTS"
            continue
        elif "OUTPUTS:" in upper_line:
            current_section = "OUTPUTS"
            continue
        elif line.strip().startswith("======="):
            continue

        if current_section == "INPUTS":
            inputs_section.append(line)
        elif current_section == "OUTPUTS":
            outputs_section.append(line)

    def parse_params(lines_list):
        parsed = []
        curr_param = None
        num_pat = r"^\d+\.\s*(\w+)(?:\s*\(([^)]+)\))?(?:\s*\[([^\]]+)\])?"
        for line in lines_list:
            stripped = line.strip()
            num_match = re.match(num_pat, stripped)
            if num_match:
                if curr_param:
                    parsed.append(curr_param)
                name = num_match.group(1)
                p_type = num_match.group(2) or ""
                modifier = num_match.group(3) or ""
                curr_param = {
                    "name": name,
                    "type": p_type,
                    "modifier": modifier,
                    "description": "",
                    "access": "",
                    "default": "",
                }
            elif curr_param:
                desc_match = re.match(
                    r"^-\s*Description:\s*(.*)", stripped, re.IGNORECASE
                )
                if desc_match:
                    curr_param["description"] = desc_match.group(1).strip()
                    continue
                access_match = re.match(
                    r"^-\s*Access:\s*(.*)", stripped, re.IGNORECASE
                )
                if access_match:
                    curr_param["access"] = access_match.group(1).strip()
                    continue
                default_match = re.match(
                    r"^-\s*Default:\s*(.*)", stripped, re.IGNORECASE
                )
                if default_match:
                    curr_param["default"] = default_match.group(1).strip()
                    continue
                if stripped.startswith("-") or stripped == "":
                    continue
                if curr_param["description"]:
                    curr_param["description"] += " " + stripped
        if curr_param:
            parsed.append(curr_param)
        return parsed

    inputs = parse_params(inputs_section)
    outputs = parse_params(outputs_section)
    return title, inputs, outputs


def merge_parameters(run_in, run_out, com_in, com_out):
    inputs = []
    for ri in run_in:
        name = ri["name"]
        matching_ci = next((ci for ci in com_in if ci["name"] == name), None)

        p_type = ri["type"]
        comment_acc = matching_ci["access"] if matching_ci else ""
        if matching_ci and matching_ci["type"]:
            p_type = matching_ci["type"]
        access = infer_access(ri["type"], comment_acc)
        required = "Y"
        default_val = "-"
        description = ""

        if matching_ci:
            mod_low = matching_ci["modifier"].lower()
            if "optional" in mod_low or matching_ci["default"]:
                required = "N"
            if matching_ci["default"]:
                default_val = matching_ci["default"]
            description = matching_ci["description"]

        inputs.append(
            {
                "name": name,
                "type": p_type,
                "access": access,
                "required": required,
                "default": default_val,
                "description": description,
            }
        )

    outputs = []
    for ro in run_out:
        name = ro["name"]
        matching_co = next((co for co in com_out if co["name"] == name), None)

        p_type = ro["type"]
        if p_type == "object" and matching_co and matching_co["type"]:
            p_type = matching_co["type"]

        description = matching_co["description"] if matching_co else ""

        outputs.append(
            {"name": name, "type": p_type, "description": description}
        )

    return inputs, outputs


def generate_markdown(db):
    default_layer_labels = {
        "L1": "L1: Attribute & Ingestion Components",
        "L2": "L2: Primary Simulation Components",
        "L3": "L3: Environmental & Comfort Components",
        "L4": "L4: Evaluation & Scoring Components",
        "L5": "L5: Multi-Criteria Synthesis Components",
        "L6": "L6: Reporting & Visualization Components",
        "L7": "L7: Integration & Export Components",
        "General": "General Components",
    }

    lines = [
        "# Grasshopper Components Registry Log",
        "",
        "This log is the single source of truth for component signatures and "
        "definitions, optimized for token-efficiency.",
        "",
        "## Component Directory Summary",
        "",
        "| Group | Component | Relative Path | Description |",
        "|---|---|---|---|",
    ]

    sorted_layers = sorted(db.keys())
    for layer in sorted_layers:
        for comp_name, data in sorted(db[layer].items()):
            desc = data.get("description", "")
            summary_desc = desc.split(".")[0] if desc else ""
            rel_path = data.get("filepath", "")
            lines.append(
                f"| {layer} | {comp_name} | `{rel_path}` | {summary_desc} |"
            )

    lines.append("")

    for layer in sorted_layers:
        heading = default_layer_labels.get(layer, f"Group: {layer}")
        lines.extend(["---", "", f"## {heading}", ""])

        for comp_name, data in sorted(db[layer].items()):
            lines.extend(
                [
                    f"### {comp_name}",
                    f"- **Path**: `{data['filepath']}`",
                    f"- **Description**: {data['description']}",
                    "",
                    "#### Inputs",
                    "| Name | Type | Access | Req | Default | Description |",
                    "|---|---|---|---|---|---|",
                ]
            )
            for inp in data["inputs"]:
                lines.append(
                    f"| {inp['name']} | `{inp['type']}` | {inp['access']} | "
                    f"{inp['required']} | `{inp['default']}` | "
                    f"{inp['description']} |"
                )
            lines.extend(
                [
                    "",
                    "#### Outputs",
                    "| Name | Type | Description |",
                    "|---|---|---|",
                ]
            )
            for outp in data["outputs"]:
                lines.append(
                    f"| {outp['name']} | `{outp['type']}` | "
                    f"{outp['description']} |"
                )
            lines.append("")

    return "\n".join(lines)


def main():
    if len(sys.argv) < 3:
        msg = "Usage: python update_log.py <workspace_dir> <filepath>"
        print(msg, file=sys.stderr)
        sys.exit(1)

    workspace_dir = os.path.abspath(sys.argv[1])
    filepath = os.path.abspath(sys.argv[2])

    if not os.path.exists(filepath):
        print(f"Error: file not found: {filepath}", file=sys.stderr)
        sys.exit(1)

    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    layer = get_layer_from_path(filepath)
    comp_name = os.path.splitext(os.path.basename(filepath))[0]

    run_in, run_out = parse_runscript_params(content)
    title, com_in, com_out = parse_header_comment(content)

    if not run_in and not run_out:
        msg = f"Error: Could not parse RunScript signature in {filepath}"
        print(msg, file=sys.stderr)
        sys.exit(1)

    inputs, outputs = merge_parameters(run_in, run_out, com_in, com_out)

    db_path = os.path.join(workspace_dir, "components_log.json")
    db = {}
    if os.path.exists(db_path):
        try:
            with open(db_path, "r", encoding="utf-8") as f:
                db = json.load(f)
        except Exception as e:
            print(
                f"Warning: Failed to load components_log.json, resetting: {e}",
                file=sys.stderr,
            )

    if layer not in db:
        db[layer] = {}

    rel_path = os.path.relpath(filepath, workspace_dir).replace("\\", "/")

    db[layer][comp_name] = {
        "filepath": rel_path,
        "description": title or comp_name,
        "inputs": inputs,
        "outputs": outputs,
    }

    with open(db_path, "w", encoding="utf-8") as f:
        json.dump(db, f, indent=2)

    md_content = generate_markdown(db)
    md_path = os.path.join(workspace_dir, "components_log.md")
    with open(md_path, "w", encoding="utf-8") as f:
        f.write(md_content)

    print(f"Successfully updated log for {comp_name} ({layer})")


if __name__ == "__main__":
    main()
