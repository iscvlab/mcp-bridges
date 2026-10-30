import os
import re
import subprocess
import sys

sys.dont_write_bytecode = True
if sys.stdout and hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")


def find_latest_components(workspace_dir):
    cs_files = []
    skip_dirs = {
        "TestCompile",
        ".git",
        ".agents",
        ".gemini",
        ".grok",
        ".claude",
        "node_modules",
        "bin",
        "obj",
    }
    for root, dirs, files in os.walk(workspace_dir):
        dirs[:] = [d for d in dirs if d not in skip_dirs]
        for file in files:
            if file.endswith(".cs") and "backup" not in file.lower():
                filepath = os.path.join(root, file)
                cs_files.append(filepath)

    groups = {}
    for filepath in cs_files:
        filename = os.path.splitext(os.path.basename(filepath))[0]

        with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
            if "RunScript" not in content:
                continue

        match = re.match(r"^([A-Za-z0-9_-]+?)_[vV](\d+)$", filename)
        if match:
            base_name = match.group(1)
            version = int(match.group(2))
        else:
            base_name = filename
            version = 0

        if base_name not in groups:
            groups[base_name] = []
        groups[base_name].append((version, filepath))

    latest_files = []
    for base_name, files_list in groups.items():
        files_list.sort(key=lambda x: x[0], reverse=True)
        latest_files.append(files_list[0][1])

    return latest_files


def main():
    if len(sys.argv) < 2:
        print("Usage: python batch_update.py <workspace_dir>", file=sys.stderr)
        sys.exit(1)

    workspace_dir = os.path.abspath(sys.argv[1])
    script_dir = os.path.dirname(os.path.abspath(__file__))
    update_script = os.path.join(script_dir, "update_log.py")
    if not os.path.exists(update_script):
        update_script = os.path.join(
            workspace_dir,
            ".agents",
            "skills",
            "components-log",
            "scripts",
            "update_log.py",
        )

    if not os.path.exists(update_script):
        msg = f"Error: update_log.py not found at {update_script}"
        print(msg, file=sys.stderr)
        sys.exit(1)

    latest_files = find_latest_components(workspace_dir)
    print(f"Found {len(latest_files)} latest components to update.")

    success_count = 0
    for filepath in sorted(latest_files):
        print(f"Processing: {os.path.basename(filepath)}...")
        result = subprocess.run(
            [sys.executable, update_script, workspace_dir, filepath],
            capture_output=True,
            text=True,
            encoding="utf-8",
        )
        if result.returncode == 0:
            print(f"  {result.stdout.strip()}")
            success_count += 1
        else:
            print(f"  FAILED: {os.path.basename(filepath)}")
            print(f"  Error: {result.stderr.strip()}")

    print(
        f"\nBatch processing complete. Successfully updated "
        f"{success_count}/{len(latest_files)} components."
    )


if __name__ == "__main__":
    main()
