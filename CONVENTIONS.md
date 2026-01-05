# Coding Conventions

## Overview

This document defines the coding conventions and rules for the AiderMacsAgent project. All contributors and automated agents must follow these conventions to maintain code quality and consistency.

## General Principles

1. **Simplicity First**: Prefer simple, readable solutions over complex ones
2. **Consistency**: Follow established patterns in the codebase
3. **Documentation**: Document complex logic and public interfaces
4. **Testing**: Write tests for new features and bug fixes
5. **Security**: Never commit secrets or sensitive data

## File Organization

### Directory Structure
```
/
├── PRD.json           # Project requirements and task list
├── CONVENTIONS.md     # This file - coding rules
├── REFLECT.md         # Pre-flight checklist
├── README.md          # Project documentation
├── generate_map.py    # Codebase mapping tool
├── ralph.sh           # Autonomous loop script
└── reflect.sh         # Planning and reflection script
```

## Shell Scripts

### Naming Conventions
- Use lowercase with underscores for variables: `file_name`, `task_count`
- Use descriptive function names: `generate_codebase_map()`, `run_reflection_check()`
- Prefix internal functions with underscore: `_internal_helper()`

### Best Practices
- Always use `#!/bin/bash` shebang
- Use `set -e` to exit on errors
- Use `set -u` to treat unset variables as errors
- Quote variables to prevent word splitting: `"$variable"`
- Use `$()` instead of backticks for command substitution
- Add error handling for critical operations
- Include helpful comments for complex logic

### Example
```bash
#!/bin/bash
set -e
set -u

# Function to process a file
process_file() {
    local file_path="$1"
    if [[ ! -f "$file_path" ]]; then
        echo "Error: File not found: $file_path" >&2
        return 1
    fi
    # Process the file
    echo "Processing: $file_path"
}
```

## Python Code

### Style Guide
- Follow PEP 8 style guide
- Use 4 spaces for indentation
- Maximum line length: 88 characters (Black formatter default)
- Use type hints for function signatures
- Use docstrings for modules, classes, and functions

### Naming Conventions
- Classes: `PascalCase` (e.g., `CodeMapper`, `TaskManager`)
- Functions/methods: `snake_case` (e.g., `generate_map`, `parse_file`)
- Constants: `UPPER_SNAKE_CASE` (e.g., `MAX_DEPTH`, `DEFAULT_PATH`)
- Private methods: prefix with underscore (e.g., `_internal_method`)

### Best Practices
- Use `pathlib.Path` for file path operations
- Handle exceptions appropriately
- Use context managers for file operations
- Prefer list comprehensions for simple transformations
- Use f-strings for string formatting

### Example
```python
from pathlib import Path
from typing import List, Dict

class CodebaseMapper:
    """Generate a map of the codebase structure."""
    
    def __init__(self, root_path: Path):
        self.root_path = root_path
    
    def generate_map(self) -> Dict[str, List[str]]:
        """Generate a map of all files in the codebase.
        
        Returns:
            Dictionary mapping directories to their files.
        """
        result = {}
        # Implementation here
        return result
```

## Markdown Documentation

### Structure
- Use clear, hierarchical headings (H1, H2, H3)
- Include a table of contents for long documents
- Use code blocks with language specification
- Use bullet points or numbered lists for clarity
- Add examples where appropriate

### Content Guidelines
- Write in clear, concise language
- Use active voice
- Keep paragraphs short and focused
- Include practical examples
- Update documentation when code changes

## JSON Files

### Formatting
- Use 2 spaces for indentation
- Keep structure flat when possible
- Use descriptive key names
- Include comments where JSON5 is supported
- Validate JSON syntax before committing

### Best Practices
- Use consistent property naming (camelCase or snake_case)
- Group related properties together
- Include version information
- Document schema for complex structures

## Git Workflow

### Commit Messages
- Use present tense: "Add feature" not "Added feature"
- First line: brief summary (50 chars or less)
- Blank line, then detailed description if needed
- Reference issue numbers when applicable

### Branch Naming
- Feature branches: `feature/description`
- Bug fixes: `fix/description`
- Documentation: `docs/description`
- Automated agent work: `copilot/description`

## Error Handling

### General Rules
- Always handle expected errors gracefully
- Provide meaningful error messages
- Log errors appropriately
- Don't silence errors without good reason
- Include context in error messages

### Shell Scripts
```bash
if ! command_that_might_fail; then
    echo "Error: Command failed with context" >&2
    exit 1
fi
```

### Python
```python
try:
    risky_operation()
except SpecificError as e:
    logger.error(f"Operation failed: {e}")
    raise
```

## Security

### Secrets Management
- Never commit secrets, API keys, or passwords
- Use environment variables for sensitive data
- Add sensitive files to `.gitignore`
- Use secret management tools when available

### Input Validation
- Validate all external input
- Sanitize file paths
- Check file permissions before operations
- Avoid shell injection vulnerabilities

## Testing

### Test Organization
- Keep tests close to the code they test
- Use descriptive test names
- Test edge cases and error conditions
- Keep tests independent and isolated

### Coverage
- Aim for high test coverage
- Focus on critical paths first
- Test public interfaces thoroughly
- Include integration tests for workflows

## Code Review

### What to Check
- Code follows conventions in this document
- Tests are included and pass
- Documentation is updated
- No security vulnerabilities introduced
- Changes are minimal and focused
- Error handling is appropriate

### Review Process
- Be constructive and respectful
- Explain reasoning for suggestions
- Approve when standards are met
- Request changes when necessary

## Automation

### Autonomous Agents
- Follow all conventions above
- Make minimal, focused changes
- Run tests before committing
- Update documentation as needed
- Request human review for major changes

### CI/CD
- Run linters on all changes
- Execute test suite automatically
- Check for security vulnerabilities
- Validate documentation builds
- Enforce convention compliance
