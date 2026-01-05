#!/usr/bin/env python3
import subprocess
import os

def get_git_files():
    """Returns a list of files tracked by git."""
    try:
        # Get list of files respecting .gitignore
        result = subprocess.run(
            ['git', 'ls-files'],
            capture_output=True, text=True, check=True
        )
        return result.stdout.strip().split('\n')
    except subprocess.CalledProcessError:
        print("Error: Not a git repository or git command failed.")
        return []
    except FileNotFoundError:
        print("Error: 'git' command not found.")
        return []

def generate_tree(files):
    """Generates a tree-like string structure from a list of file paths."""
    tree = {}
    for path in files:
        parts = path.split('/')
        current = tree
        for part in parts:
            current = current.setdefault(part, {})

    def print_tree(node, prefix=''):
        lines = []
        keys = sorted(node.keys())
        for i, key in enumerate(keys):
            is_last = (i == len(keys) - 1)
            connector = '└── ' if is_last else '├── '
            lines.append(f"{prefix}{connector}{key}")
            
            # Recurse if there are children (directories)
            # Note: Empty dict means it's a file, non-empty means directory
            if node[key]: 
                extension = '    ' if is_last else '│   '
                lines.extend(print_tree(node[key], prefix + extension))
        return lines

    if not tree:
        return ""
    return "\n".join(print_tree(tree))

def main():
    files = get_git_files()
    if not files:
        return

    tree_output = generate_tree(files)
    
    # We use explicit string concatenation for the fence block 
    # to avoid confusing tools that read this script.
    fence = "```"
    
    content = f"""# Repository Map
This file represents the complete file structure of the project.
Use this to understand file locations and architecture.

## File Tree
{fence}text
{tree_output}
{fence}
"""
    
    try:
        with open('MAP.md', 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"✅ MAP.md generated with {len(files)} files mapped.")
    except IOError as e:
        print(f"Error writing MAP.md: {e}")

if __name__ == "__main__":
    main()
