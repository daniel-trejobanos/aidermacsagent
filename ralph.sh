#!/bin/bash
# ralph.sh - The Autonomous Loop
# 
# This script implements the main autonomous coding loop for AiderMacsAgent.
# It continuously executes coding tasks using AI agents (Copilot/Gemini),
# performs reflection, and iterates until tasks are complete.

set -e
set -u

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/logs"
MAX_ITERATIONS="${MAX_ITERATIONS:-10}"
SLEEP_BETWEEN_ITERATIONS="${SLEEP_BETWEEN_ITERATIONS:-5}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $*"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

# Initialize logging directory
init_logging() {
    mkdir -p "$LOG_DIR"
    local log_file="${LOG_DIR}/ralph_$(date '+%Y%m%d_%H%M%S').log"
    exec 1> >(tee -a "$log_file")
    exec 2>&1
    log_info "Logging initialized: $log_file"
}

# Load task list from PRD.json
load_tasks() {
    if [[ ! -f "${SCRIPT_DIR}/PRD.json" ]]; then
        log_error "PRD.json not found"
        return 1
    fi
    
    log_info "Loading tasks from PRD.json"
    # This would typically parse JSON and extract tasks
    # For now, we'll just verify the file exists
    return 0
}

# Generate codebase map
generate_codebase_map() {
    log_info "Generating codebase map..."
    
    if [[ ! -f "${SCRIPT_DIR}/generate_map.py" ]]; then
        log_warning "generate_map.py not found, skipping map generation"
        return 1
    fi
    
    if command -v python3 &> /dev/null; then
        python3 "${SCRIPT_DIR}/generate_map.py" \
            --output "${LOG_DIR}/codebase_map.json" \
            --pretty \
            "$SCRIPT_DIR"
        log_success "Codebase map generated"
    else
        log_warning "Python3 not found, skipping map generation"
        return 1
    fi
}

# Run reflection/planning phase
run_reflection() {
    log_info "Running reflection phase..."
    
    if [[ -f "${SCRIPT_DIR}/reflect.sh" ]]; then
        bash "${SCRIPT_DIR}/reflect.sh"
        local status=$?
        if [[ $status -eq 0 ]]; then
            log_success "Reflection phase completed"
        else
            log_warning "Reflection phase completed with warnings"
        fi
        return $status
    else
        log_warning "reflect.sh not found, skipping reflection"
        return 1
    fi
}

# Check if conventions are being followed
check_conventions() {
    log_info "Checking code conventions..."
    
    # Check if CONVENTIONS.md exists
    if [[ ! -f "${SCRIPT_DIR}/CONVENTIONS.md" ]]; then
        log_warning "CONVENTIONS.md not found"
        return 1
    fi
    
    # Run basic checks
    local errors=0
    
    # Check for uncommitted secrets (basic check)
    # Note: This is a simple pattern check. For production use, consider
    # dedicated tools like gitleaks or truffleHog for more accurate detection
    if git grep -i "api[_-]key\|password\|secret" 2>/dev/null | grep -v "CONVENTIONS.md" | grep -q .; then
        log_error "Potential secrets found in code!"
        errors=$((errors + 1))
    fi
    
    # Check shell scripts for proper shebang
    for script in "${SCRIPT_DIR}"/*.sh; do
        if [[ -f "$script" ]] && ! head -n1 "$script" | grep -q "^#!"; then
            log_warning "Script missing shebang: $script"
        fi
    done
    
    if [[ $errors -eq 0 ]]; then
        log_success "Convention checks passed"
        return 0
    else
        log_error "Convention checks failed with $errors errors"
        return 1
    fi
}

# Execute a coding task (placeholder for AI agent integration)
execute_task() {
    local task_id="$1"
    log_info "Executing task: $task_id"
    
    # This is where you would integrate with:
    # - GitHub Copilot API
    # - Google Gemini API
    # - Other AI coding assistants
    
    # For now, this is a placeholder
    log_info "Task execution would happen here"
    sleep 2
    
    log_success "Task execution completed: $task_id"
    return 0
}

# Verify changes made
verify_changes() {
    log_info "Verifying changes..."
    
    # Check git status
    if git status --porcelain | grep -q .; then
        log_info "Changes detected:"
        git status --short
    else
        log_info "No changes detected"
    fi
    
    # Run tests if they exist
    if [[ -f "package.json" ]] && command -v npm &> /dev/null; then
        if npm run test 2>/dev/null; then
            log_success "Tests passed"
        else
            log_warning "Tests failed or not available"
        fi
    fi
    
    return 0
}

# Main autonomous loop
autonomous_loop() {
    local iteration=0
    local tasks_remaining=true
    
    log_info "Starting autonomous loop (max iterations: $MAX_ITERATIONS)"
    
    while [[ $iteration -lt $MAX_ITERATIONS ]] && [[ "$tasks_remaining" == "true" ]]; do
        iteration=$((iteration + 1))
        log_info "=== Iteration $iteration/$MAX_ITERATIONS ==="
        
        # Phase 1: Reflection and Planning
        if run_reflection; then
            log_info "Reflection phase successful"
        fi
        
        # Phase 2: Generate Codebase Map
        generate_codebase_map
        
        # Phase 3: Load and Execute Tasks
        if load_tasks; then
            # Execute next task (simplified for now)
            execute_task "TASK-NEXT"
        fi
        
        # Phase 4: Verify Changes
        verify_changes
        
        # Phase 5: Check Conventions
        check_conventions
        
        # Check if more tasks remain
        # This would typically query PRD.json for incomplete tasks
        if [[ $iteration -ge 3 ]]; then
            tasks_remaining=false
            log_info "No more tasks remaining"
        fi
        
        # Sleep between iterations
        if [[ "$tasks_remaining" == "true" ]] && [[ $iteration -lt $MAX_ITERATIONS ]]; then
            log_info "Sleeping for ${SLEEP_BETWEEN_ITERATIONS}s before next iteration..."
            sleep "$SLEEP_BETWEEN_ITERATIONS"
        fi
    done
    
    log_info "Autonomous loop completed after $iteration iterations"
}

# Cleanup function
cleanup() {
    log_info "Cleaning up..."
    # Add any cleanup tasks here
}

# Signal handlers
trap cleanup EXIT
trap 'log_error "Script interrupted"; exit 130' INT TERM

# Main function
main() {
    echo "=========================================="
    echo "  AiderMacsAgent - Autonomous Loop"
    echo "=========================================="
    echo ""
    
    init_logging
    
    log_info "Script directory: $SCRIPT_DIR"
    log_info "Log directory: $LOG_DIR"
    
    # Run the autonomous loop
    autonomous_loop
    
    log_success "Ralph autonomous loop finished successfully"
}

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
