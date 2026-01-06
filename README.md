# AiderMacsAgent

An autonomous coding agent system that provides an alternative to Claude Code using GitHub Copilot and Google Gemini APIs.

## Overview

AiderMacsAgent is a framework for autonomous software development that leverages AI coding assistants to automate iterative development workflows. It combines planning, execution, reflection, and quality assurance into a cohesive system.

## Features

- **Autonomous Coding Loop**: Automated workflow for iterative code generation and refinement
- **Multi-AI Support**: Integrates with GitHub Copilot and Google Gemini via Aider
- **Code Mapping**: Generates comprehensive maps of codebase structure
- **Pre-Flight Checks**: Ensures quality and adherence to conventions before changes
- **Convention Enforcement**: Maintains code quality through documented standards
- **Reflection System**: Plans and validates work before and after execution

## Project Structure

```
aidermacsagent/
├── PRD.json           # Project Requirements & Task List
├── CONVENTIONS.md     # Coding Standards & Rules
├── REFLECT.md         # Pre-Flight Checklist
├── README.md          # This file
├── MAP.md             # Codebase Map visualization
├── generate_map.py    # Codebase Map Generator
├── ralph.sh           # Autonomous Loop Script
├── reflect.sh         # Planning & Reflection Script
├── progress.txt       # Autonomous loop progress log
└── logs/              # Generated logs and outputs
```

## Quick Start

### Prerequisites

- **Required**:
  - Bash (4.0+)
  - Python 3.8+
  - Git
  - **Aider**: The core AI coding assistant tool

- **Optional** (but recommended):
  - `jq` - JSON parsing in shell scripts
  - `shellcheck` - Shell script linting
  - `pylint` or `ruff` - Python linting

### Installation

1. Clone the repository:
```bash
git clone https://github.com/daniel-trejobanos/aidermacsagent.git
cd aidermacsagent
```

2. Make scripts executable:
```bash
chmod +x ralph.sh reflect.sh generate_map.py
```

3. Install Aider (Required):
```bash
pip install aider-chat
```

4. Install optional dependencies (Ubuntu/Debian):
```bash
sudo apt-get install jq shellcheck python3-pip
pip3 install pylint
```

Or on macOS:
```bash
brew install jq shellcheck
pip3 install pylint
```

### Basic Usage

#### 1. Run Reflection/Planning

Before starting any work, run the reflection script to understand the current state:

```bash
./reflect.sh
```

This will:
- Check that all required files are present
- Analyze the repository state
- Review the pre-flight checklist
- Display current tasks
- Suggest next actions

#### 2. Generate Codebase Map

Create a comprehensive map of your codebase:

```bash
./generate_map.py
```

The map will be saved to `MAP.md`.

#### 3. Run Autonomous Loop

Execute the autonomous coding loop:

```bash
./ralph.sh
```

This will:
- Run reflection phase
- Generate codebase map
- Load and execute tasks
- Verify changes
- Check conventions
- Iterate until complete

You can customize the loop with environment variables:
```bash
MAX_LOOPS=5 ./ralph.sh
```

## Core Components

### PRD.json - The Task List

JSON file containing:
- Project metadata (name, version, description)
- Goals and objectives
- Task list with status tracking
- Features and components
- Milestones and deliverables

### CONVENTIONS.md - The Rules

Comprehensive coding standards covering:
- General principles
- Language-specific conventions (Python, Shell, etc.)
- Documentation standards
- Security requirements
- Testing guidelines
- Code review checklist

### REFLECT.md - The Pre-Flight Check

A detailed checklist covering:
- Task understanding and requirements
- Planning and approach
- Impact analysis
- Conventions and standards
- Technical preparation
- Security considerations
- Risk assessment

### generate_map.py - The Map Generator

Python script that:
- Scans the codebase directory structure
- Categorizes files (code, config, docs, other)
- Counts lines of code
- Generates JSON map with statistics
- Excludes common build/dependency directories

### ralph.sh - The Autonomous Loop

Main automation script that:
- Orchestrates the entire workflow
- Runs reflection and planning
- Executes coding tasks
- Verifies changes
- Enforces conventions
- Iterates until tasks complete

### reflect.sh - The Planner Script

Planning and reflection script that:
- Validates environment setup
- Checks required files
- Analyzes repository state
- Reviews conventions
- Displays current tasks
- Suggests next actions
- Generates reflection summaries

## Workflow

The typical autonomous workflow follows these steps:

1. **Reflection Phase** (`reflect.sh`)
   - Understand current state
   - Review tasks and priorities
   - Check pre-flight items
   - Plan approach

2. **Mapping Phase** (`generate_map.py`)
   - Scan codebase structure
   - Identify relevant files
   - Understand architecture

3. **Execution Phase** (AI Agent)
   - Load next task
   - Generate/modify code
   - Follow conventions
   - Make minimal changes

4. **Verification Phase**
   - Run tests
   - Check for errors
   - Validate changes
   - Ensure conventions followed

5. **Iteration**
   - Commit changes
   - Update task status
   - Move to next task
   - Repeat until complete

## Configuration

### Environment Variables

- `MAX_LOOPS`: Maximum number of autonomous loop iterations (default: 2)
- `TEST_CMD`: Command to run tests (default: "pytest")

### Customization

Edit `PRD.json` to:
- Add new tasks
- Update project goals
- Track milestones
- Define features

Edit `CONVENTIONS.md` to:
- Add project-specific rules
- Define new conventions
- Update best practices

## AI Integration

AiderMacsAgent is designed to work with various AI coding assistants via Aider:

### Configuration

Ensure you have your API keys set up for Aider:

```bash
export OPENAI_API_KEY=sk-...
# or
export ANTHROPIC_API_KEY=sk-...
# or other supported providers
```

## Development

### Running Tests

```bash
# Test the map generator
./generate_map.py

# Test reflection script
./reflect.sh

# Test autonomous loop (dry run)
MAX_LOOPS=1 ./ralph.sh
```

### Linting

```bash
# Lint Python code
pylint generate_map.py

# Lint shell scripts
shellcheck ralph.sh reflect.sh
```

### Adding New Tasks

1. Edit `PRD.json`
2. Add task with unique ID, title, description
3. Set status to "pending"
4. Set priority (high/medium/low)
5. Run `./reflect.sh` to see updated task list

## Best Practices

1. **Always run reflection first**: Use `./reflect.sh` before starting work
2. **Review REFLECT.md**: Check off items as you complete them
3. **Follow conventions**: Read `CONVENTIONS.md` thoroughly
4. **Make minimal changes**: Focus on one task at a time
5. **Test frequently**: Verify changes work as expected
6. **Document as you go**: Update docs alongside code
7. **Commit often**: Small, focused commits are better

## Contributing

1. Read `CONVENTIONS.md` thoroughly
2. Review `REFLECT.md` checklist
3. Make minimal, focused changes
4. Follow existing code style
5. Add/update tests as needed
6. Update documentation
7. Submit pull request

## License

MIT License

## Support

For issues, questions, or contributions:
- GitHub Issues: https://github.com/daniel-trejobanos/aidermacsagent/issues
- Documentation: This README and files in the repository

---

**Version**: 0.1.0
**Status**: Active Development
