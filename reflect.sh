#!/bin/bash
# reflect.sh - The Planner Script
#
# This script implements the reflection and planning phase for autonomous coding.
# It checks the pre-flight checklist, analyzes the current state, and plans next steps.

set -e
set -u

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REFLECT_MD="${SCRIPT_DIR}/REFLECT.md"
PRD_JSON="${SCRIPT_DIR}/PRD.json"
CONVENTIONS_MD="${SCRIPT_DIR}/CONVENTIONS.md"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $*"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $*"
}

print_error() {
    echo -e "${RED}[✗]${NC} $*"
}

print_header() {
    echo ""
    echo "=========================================="
    echo "  $*"
    echo "=========================================="
    echo ""
}

# Check if required files exist
check_required_files() {
    print_info "Checking required files..."
    local missing=0
    
    local required_files=(
        "$REFLECT_MD"
        "$PRD_JSON"
        "$CONVENTIONS_MD"
    )
    
    for file in "${required_files[@]}"; do
        if [[ -f "$file" ]]; then
            print_success "Found: $(basename "$file")"
        else
            print_error "Missing: $(basename "$file")"
            missing=$((missing + 1))
        fi
    done
    
    if [[ $missing -gt 0 ]]; then
        print_warning "$missing required files are missing"
        return 1
    fi
    
    print_success "All required files present"
    return 0
}

# Analyze current repository state
analyze_repo_state() {
    print_info "Analyzing repository state..."
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository"
        return 1
    fi
    
    # Show current branch
    local branch=$(git branch --show-current)
    print_info "Current branch: $branch"
    
    # Check for uncommitted changes
    if git diff --quiet && git diff --cached --quiet; then
        print_success "Working directory is clean"
    else
        print_warning "Uncommitted changes detected:"
        git status --short | head -10
    fi
    
    # Count files by type
    print_info "Repository statistics:"
    
    if command -v find &> /dev/null; then
        local py_files=$(find . -name "*.py" -not -path "*/.*" 2>/dev/null | wc -l)
        local sh_files=$(find . -name "*.sh" -not -path "*/.*" 2>/dev/null | wc -l)
        local md_files=$(find . -name "*.md" -not -path "*/.*" 2>/dev/null | wc -l)
        local json_files=$(find . -name "*.json" -not -path "*/.*" 2>/dev/null | wc -l)
        
        echo "  Python files: $py_files"
        echo "  Shell scripts: $sh_files"
        echo "  Markdown docs: $md_files"
        echo "  JSON files: $json_files"
    fi
    
    return 0
}

# Check pre-flight checklist items
check_preflight() {
    print_info "Reviewing pre-flight checklist..."
    
    if [[ ! -f "$REFLECT_MD" ]]; then
        print_error "REFLECT.md not found"
        return 1
    fi
    
    # Count checklist items
    local total_items=$(grep -c "^- \[" "$REFLECT_MD" || true)
    print_info "Total checklist items: $total_items"
    
    print_success "Pre-flight checklist available for review"
    return 0
}

# Review conventions
review_conventions() {
    print_info "Reviewing coding conventions..."
    
    if [[ ! -f "$CONVENTIONS_MD" ]]; then
        print_error "CONVENTIONS.md not found"
        return 1
    fi
    
    # Extract key conventions
    print_info "Key conventions to remember:"
    echo "  - Follow PEP 8 for Python code"
    echo "  - Use shellcheck for shell scripts"
    echo "  - Never commit secrets"
    echo "  - Make minimal, focused changes"
    echo "  - Write clear commit messages"
    
    print_success "Conventions reviewed"
    return 0
}

# Parse and display tasks from PRD.json
show_tasks() {
    print_info "Loading tasks from PRD.json..."
    
    if [[ ! -f "$PRD_JSON" ]]; then
        print_error "PRD.json not found"
        return 1
    fi
    
    # Check if jq is available for JSON parsing
    if command -v jq &> /dev/null; then
        print_info "Project: $(jq -r '.project.name // "Unknown"' "$PRD_JSON")"
        print_info "Version: $(jq -r '.project.version // "Unknown"' "$PRD_JSON")"
        
        echo ""
        print_info "Tasks:"
        jq -r '.tasks[] | "  [\(.status)] \(.id): \(.title)"' "$PRD_JSON" 2>/dev/null || true
    else
        print_warning "jq not available, cannot parse JSON tasks"
        print_info "Install jq for better task parsing: apt-get install jq / brew install jq"
    fi
    
    return 0
}

# Suggest next actions
suggest_next_actions() {
    print_info "Analyzing next actions..."
    
    echo ""
    echo "Suggested next steps:"
    echo "  1. Review REFLECT.md checklist items"
    echo "  2. Ensure all pre-flight checks are complete"
    echo "  3. Review CONVENTIONS.md for coding standards"
    echo "  4. Identify the next task from PRD.json"
    echo "  5. Make minimal, focused changes"
    echo "  6. Test changes thoroughly"
    echo "  7. Commit with clear messages"
    
    return 0
}

# Generate reflection summary
generate_summary() {
    print_info "Generating reflection summary..."
    
    local summary_file="${SCRIPT_DIR}/logs/reflection_$(date '+%Y%m%d_%H%M%S').txt"
    mkdir -p "${SCRIPT_DIR}/logs"
    
    {
        echo "REFLECTION SUMMARY"
        echo "Generated: $(date)"
        echo ""
        echo "Repository: $(git remote get-url origin 2>/dev/null || echo 'Unknown')"
        echo "Branch: $(git branch --show-current 2>/dev/null || echo 'Unknown')"
        echo "Commit: $(git rev-parse --short HEAD 2>/dev/null || echo 'Unknown')"
        echo ""
        echo "Status: Ready for next iteration"
    } > "$summary_file"
    
    print_success "Summary saved to: $summary_file"
    return 0
}

# Validate environment
validate_environment() {
    print_info "Validating environment..."
    
    local warnings=0
    
    # Check for essential tools
    local tools=("git" "python3" "bash")
    
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            print_success "$tool is available"
        else
            print_warning "$tool is not available"
            warnings=$((warnings + 1))
        fi
    done
    
    # Check for optional but recommended tools
    local optional_tools=("jq" "shellcheck" "pylint")
    
    for tool in "${optional_tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            print_success "$tool is available (optional)"
        else
            print_info "$tool is not available (optional, but recommended)"
        fi
    done
    
    if [[ $warnings -gt 0 ]]; then
        print_warning "Some essential tools are missing"
    else
        print_success "Environment validation passed"
    fi
    
    return 0
}

# Main reflection process
main() {
    print_header "Reflection & Planning Phase"
    
    local exit_code=0
    
    # Run all checks
    check_required_files || exit_code=1
    echo ""
    
    validate_environment || exit_code=1
    echo ""
    
    analyze_repo_state || exit_code=1
    echo ""
    
    check_preflight || exit_code=1
    echo ""
    
    review_conventions || exit_code=1
    echo ""
    
    show_tasks || exit_code=1
    echo ""
    
    suggest_next_actions
    echo ""
    
    generate_summary
    
    print_header "Reflection Complete"
    
    if [[ $exit_code -eq 0 ]]; then
        print_success "All reflection checks passed!"
        echo ""
        echo "You are ready to proceed with implementation."
    else
        print_warning "Some reflection checks had warnings."
        echo ""
        echo "Review the warnings above before proceeding."
    fi
    
    return $exit_code
}

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
