#!/usr/bin/env python3
"""
convert.py — Convert between JSON and YAML project files.
Detects format from file extension and converts to the other.

Usage: python convert.py input.json [output.yaml]
       python convert.py input.yaml [output.json]
       (omit output to be prompted for filename)
"""
import json
import sys
import os
import yaml

def main():
    if len(sys.argv) < 2:
        print("Usage: convert.py input.json|yaml [output]")
        sys.exit(1)

    input_path = sys.argv[1]
    ext = os.path.splitext(input_path)[1].lower()

    if ext not in ('.json', '.yaml', '.yml'):
        print(f"Error: unrecognized extension '{ext}' — expected .json or .yaml")
        sys.exit(1)

    # Load input
    with open(input_path, encoding='utf-8') as f:
        if ext == '.json':
            data = json.load(f)
            target_ext = '.yaml'
            target_desc = 'YAML'
        else:
            data = yaml.safe_load(f)
            target_ext = '.json'
            target_desc = 'JSON'

    # Determine output path
    if len(sys.argv) >= 3:
        output_path = sys.argv[2]
    else:
        default = os.path.splitext(input_path)[0] + target_ext
        output_path = input(f"Output filename [{default}]: ").strip()
        if not output_path:
            output_path = default

    # Safety check — don't silently overwrite input
    if os.path.abspath(output_path) == os.path.abspath(input_path):
        print("Error: output and input are the same file.")
        sys.exit(1)

    if os.path.exists(output_path):
        confirm = input(f"'{output_path}' already exists. Overwrite? [y/N]: ").strip().lower()
        if confirm != 'y':
            print("Aborted.")
            sys.exit(0)

    # Write output
    with open(output_path, 'w', encoding='utf-8') as f:
        if target_desc == 'YAML':
            yaml.dump(data, f, allow_unicode=True, sort_keys=False,
                      default_flow_style=False, width=80)
        else:
            json.dump(data, f, indent=2, ensure_ascii=False)
            f.write('\n')

    print(f"Written: {output_path}  ({target_desc})")

if __name__ == '__main__':
    main()
