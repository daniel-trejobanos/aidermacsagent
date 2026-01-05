#!/usr/bin/env python3
"""
Code Map Generator

This script generates a comprehensive map of the codebase structure,
including files, directories, and code statistics. It helps autonomous
agents and developers understand the project layout quickly.
"""

import os
import sys
import json
import argparse
from pathlib import Path
from typing import Dict, List, Set, Optional
from collections import defaultdict
from datetime import datetime


class CodebaseMapper:
    """Generate a structured map of a codebase."""
    
    # File extensions to include in the map
    CODE_EXTENSIONS = {
        '.py', '.js', '.ts', '.jsx', '.tsx', '.java', '.c', '.cpp', '.h',
        '.hpp', '.cs', '.go', '.rs', '.rb', '.php', '.swift', '.kt', '.scala',
        '.sh', '.bash', '.zsh', '.fish', '.ps1', '.cmd', '.bat'
    }
    
    CONFIG_EXTENSIONS = {
        '.json', '.yaml', '.yml', '.toml', '.ini', '.cfg', '.conf', '.xml'
    }
    
    DOC_EXTENSIONS = {
        '.md', '.rst', '.txt', '.adoc', '.tex'
    }
    
    # Directories to exclude
    EXCLUDED_DIRS = {
        '.git', '.svn', '.hg', 'node_modules', '__pycache__', '.pytest_cache',
        'venv', 'env', '.env', 'dist', 'build', 'target', '.idea', '.vscode',
        '.vs', 'bin', 'obj', 'vendor', 'coverage', '.nyc_output', 'out'
    }
    
    def __init__(self, root_path: Path, max_depth: int = 10):
        """Initialize the mapper.
        
        Args:
            root_path: Root directory to map
            max_depth: Maximum directory depth to traverse
        """
        self.root_path = Path(root_path).resolve()
        self.max_depth = max_depth
        self.file_stats = defaultdict(int)
        self.dir_structure = {}
        
    def is_excluded(self, path: Path) -> bool:
        """Check if a path should be excluded from mapping.
        
        Args:
            path: Path to check
            
        Returns:
            True if path should be excluded
        """
        # Check if any parent directory is in excluded list
        for part in path.parts:
            if part in self.EXCLUDED_DIRS:
                return True
        return False
    
    def get_file_category(self, file_path: Path) -> str:
        """Categorize a file based on its extension.
        
        Args:
            file_path: Path to the file
            
        Returns:
            Category string: 'code', 'config', 'docs', or 'other'
        """
        ext = file_path.suffix.lower()
        if ext in self.CODE_EXTENSIONS:
            return 'code'
        elif ext in self.CONFIG_EXTENSIONS:
            return 'config'
        elif ext in self.DOC_EXTENSIONS:
            return 'docs'
        else:
            return 'other'
    
    def count_lines(self, file_path: Path) -> Optional[int]:
        """Count lines in a text file.
        
        Args:
            file_path: Path to the file
            
        Returns:
            Number of lines or None if file cannot be read
        """
        try:
            with open(file_path, 'r', encoding='utf-8', errors='replace') as f:
                return sum(1 for _ in f)
        except Exception:
            return None
    
    def scan_directory(self, directory: Path, depth: int = 0) -> Dict:
        """Recursively scan a directory and build a structure map.
        
        Args:
            directory: Directory to scan
            depth: Current recursion depth
            
        Returns:
            Dictionary representing directory structure
        """
        if depth > self.max_depth or self.is_excluded(directory):
            return {}
        
        result = {
            'type': 'directory',
            'name': directory.name,
            'path': str(directory.relative_to(self.root_path)),
            'children': []
        }
        
        try:
            entries = list(directory.iterdir())
            entries.sort(key=lambda x: (not x.is_dir(), x.name))
        except PermissionError:
            result['error'] = 'Permission denied'
            return result
        
        for entry in entries:
            if self.is_excluded(entry):
                continue
                
            if entry.is_file():
                category = self.get_file_category(entry)
                self.file_stats[category] += 1
                
                file_info = {
                    'type': 'file',
                    'name': entry.name,
                    'path': str(entry.relative_to(self.root_path)),
                    'category': category,
                    'size': entry.stat().st_size
                }
                
                # Add line count for text files
                if category in ['code', 'config', 'docs']:
                    lines = self.count_lines(entry)
                    if lines is not None:
                        file_info['lines'] = lines
                
                result['children'].append(file_info)
                
            elif entry.is_dir():
                subdir = self.scan_directory(entry, depth + 1)
                if subdir:  # Only add non-empty results
                    result['children'].append(subdir)
        
        return result
    
    def generate_map(self) -> Dict:
        """Generate the complete codebase map.
        
        Returns:
            Dictionary containing the complete map structure
        """
        print(f"Scanning codebase at: {self.root_path}")
        
        structure = self.scan_directory(self.root_path)
        
        # Calculate statistics
        total_files = sum(self.file_stats.values())
        
        codebase_map = {
            'metadata': {
                'generated_at': datetime.now().isoformat(),
                'root_path': str(self.root_path),
                'total_files': total_files,
                'file_breakdown': dict(self.file_stats)
            },
            'structure': structure
        }
        
        return codebase_map
    
    def print_summary(self, codebase_map: Dict):
        """Print a summary of the codebase map.
        
        Args:
            codebase_map: The generated map dictionary
        """
        metadata = codebase_map['metadata']
        print("\n" + "="*60)
        print("CODEBASE MAP SUMMARY")
        print("="*60)
        print(f"Root Path: {metadata['root_path']}")
        print(f"Generated: {metadata['generated_at']}")
        print(f"\nTotal Files: {metadata['total_files']}")
        print("\nFile Breakdown:")
        for category, count in sorted(metadata['file_breakdown'].items()):
            print(f"  {category.capitalize()}: {count}")
        print("="*60 + "\n")


def main():
    """Main entry point for the map generator."""
    parser = argparse.ArgumentParser(
        description='Generate a comprehensive map of a codebase'
    )
    parser.add_argument(
        'path',
        nargs='?',
        default='.',
        help='Root path to scan (default: current directory)'
    )
    parser.add_argument(
        '-o', '--output',
        help='Output file path (default: stdout)',
        default=None
    )
    parser.add_argument(
        '-d', '--max-depth',
        type=int,
        default=10,
        help='Maximum directory depth to traverse (default: 10)'
    )
    parser.add_argument(
        '--pretty',
        action='store_true',
        help='Pretty-print JSON output'
    )
    parser.add_argument(
        '--summary-only',
        action='store_true',
        help='Print only the summary, not the full map'
    )
    
    args = parser.parse_args()
    
    # Validate path
    root_path = Path(args.path)
    if not root_path.exists():
        print(f"Error: Path does not exist: {root_path}", file=sys.stderr)
        sys.exit(1)
    
    if not root_path.is_dir():
        print(f"Error: Path is not a directory: {root_path}", file=sys.stderr)
        sys.exit(1)
    
    # Generate the map
    mapper = CodebaseMapper(root_path, max_depth=args.max_depth)
    codebase_map = mapper.generate_map()
    
    # Print summary
    mapper.print_summary(codebase_map)
    
    # Output the map
    if not args.summary_only:
        json_output = json.dumps(
            codebase_map,
            indent=2 if args.pretty else None
        )
        
        if args.output:
            output_path = Path(args.output)
            output_path.parent.mkdir(parents=True, exist_ok=True)
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write(json_output)
            print(f"Map written to: {output_path}")
        else:
            print(json_output)


if __name__ == '__main__':
    main()
