#!/usr/bin/env python3
"""
json2yaml.py — Convert a project JSON file to YAML for human review.
Usage: python json2yaml.py project.json [output.yaml]
       (omit output file to print to stdout)
"""
import json
import sys
import yaml

def main():
    if len(sys.argv) < 2:
        print("Usage: json2yaml.py project.json [output.yaml]")
        sys.exit(1)

    with open(sys.argv[1]) as f:
        data = json.load(f)

    output = yaml.dump(data, allow_unicode=True, sort_keys=False,
                       default_flow_style=False, width=80)

    if len(sys.argv) >= 3:
        with open(sys.argv[2], 'w', encoding='utf-8') as f:
            f.write(output)
        print(f"Written: {sys.argv[2]}")
    else:
        print(output)

if __name__ == '__main__':
    main()
