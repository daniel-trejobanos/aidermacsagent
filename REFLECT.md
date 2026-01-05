# REFLECT.md

## Role
You are a Senior Principal Architect performing a "Pre-Flight Check" for an autonomous coding agent.

## Inputs
1. **The Plan:** `PRD.json` (The features we want to build).
2. **The Territory:** `MAP.md` (The current file structure).

## Your Goal
Analyze if the Plan is viable given the Territory. You must find gaps *before* the coding agent starts.

## Analysis Checklist
1. **Missing Context:** Does the PRD mention files or modules that are NOT in the MAP?
2. **Duplication Risk:** Does the PRD ask to create a util/function that likely already exists in the MAP?
3. **Ambiguity:** Are any PRD tasks too vague? (e.g., "Fix the bug" vs "Fix IndexError in auth.py").
4. **Dependency Order:** Are the PRD tasks in the correct logical order? (e.g., Database migration must happen before API update).

## Output Format
If everything looks good, output exactly:
`✅ GREEN LIGHT: Plan is solid.`

If you find issues, output:
`🛑 STOP. Risks detected:`
- [List the specific risks]
- [Suggestion for fixing the PRD]

# Pre-Flight Reflection Checklist

## Overview

This document serves as a pre-flight checklist for any code changes, whether made by humans or autonomous agents. Complete this checklist before starting work to ensure a clear understanding of the task and approach.

## Task Understanding

### Problem Statement
- [ ] I have read and understood the problem statement completely
- [ ] I understand what needs to be changed or added
- [ ] I know the expected outcome or behavior
- [ ] I have identified any ambiguities and clarified them

### Context Gathering
- [ ] I have explored the relevant codebase areas
- [ ] I understand the existing architecture and patterns
- [ ] I have identified related files and dependencies
- [ ] I have reviewed recent changes in related areas
- [ ] I have checked for existing similar implementations

### Requirements Clarity
- [ ] The acceptance criteria are clear
- [ ] I understand the constraints and limitations
- [ ] I know what success looks like
- [ ] I have identified potential edge cases

## Planning

### Approach
- [ ] I have a clear plan for the changes needed
- [ ] I have identified the minimal set of changes required
- [ ] I understand the order of operations
- [ ] I have considered alternative approaches
- [ ] I have chosen the simplest viable solution

### Impact Analysis
- [ ] I have identified all files that need to change
- [ ] I understand the potential impact on existing functionality
- [ ] I have considered backward compatibility
- [ ] I have identified potential side effects
- [ ] I have planned for error handling

### Dependencies
- [ ] I have identified all dependencies (libraries, tools, etc.)
- [ ] I understand any new dependencies needed
- [ ] I have verified dependency versions and compatibility
- [ ] I have considered security implications of dependencies

## Conventions and Standards

### Code Quality
- [ ] I have reviewed `CONVENTIONS.md`
- [ ] I understand the coding standards for this project
- [ ] I know the naming conventions to follow
- [ ] I understand the required documentation standards
- [ ] I am aware of testing requirements

### Project Structure
- [ ] I understand the project's directory structure
- [ ] I know where new files should be placed
- [ ] I understand the organization of existing code
- [ ] I have identified reusable components

## Technical Preparation

### Development Environment
- [ ] I have the necessary tools installed
- [ ] I can build the project successfully
- [ ] I can run existing tests
- [ ] I understand the linting/formatting tools used
- [ ] I have checked for any pre-commit hooks

### Testing Strategy
- [ ] I have identified existing tests related to my changes
- [ ] I have planned new tests to add
- [ ] I understand how to run tests locally
- [ ] I know what test coverage is expected
- [ ] I have considered integration testing needs

### Build and Deploy
- [ ] I understand how to build the project
- [ ] I know how to run the application locally
- [ ] I have identified CI/CD pipeline requirements
- [ ] I understand the deployment process (if applicable)

## Security and Safety

### Security Considerations
- [ ] I have reviewed security best practices
- [ ] I understand input validation requirements
- [ ] I will not commit secrets or sensitive data
- [ ] I have considered authentication/authorization impacts
- [ ] I have planned for secure error handling

### Data Safety
- [ ] I understand data handling requirements
- [ ] I have planned for proper error recovery
- [ ] I will not delete or modify data unexpectedly
- [ ] I have considered backup and rollback needs

### Code Safety
- [ ] I will make minimal changes to existing working code
- [ ] I will not remove functionality without confirmation
- [ ] I understand the rollback procedure
- [ ] I have planned for graceful degradation

## Collaboration

### Communication
- [ ] I know who to ask for help if needed
- [ ] I understand when to request code review
- [ ] I have identified stakeholders to notify
- [ ] I will provide clear commit messages
- [ ] I will document significant decisions

### Documentation
- [ ] I have identified documentation that needs updating
- [ ] I know where to document my changes
- [ ] I will update inline code comments as needed
- [ ] I will update README or user docs if needed
- [ ] I will document any new conventions or patterns

## Execution Plan

### Implementation Steps
1. [ ] Start with minimal exploration and understanding
2. [ ] Create a detailed task breakdown
3. [ ] Implement changes incrementally
4. [ ] Test each change immediately after implementation
5. [ ] Commit small, focused changes frequently
6. [ ] Update documentation alongside code changes
7. [ ] Request code review when ready
8. [ ] Address review feedback promptly

### Quality Gates
- [ ] Code compiles/runs without errors
- [ ] All existing tests pass
- [ ] New tests are added and passing
- [ ] Code follows project conventions
- [ ] Documentation is updated
- [ ] Security scan passes (if applicable)
- [ ] Code review is approved

### Validation Plan
- [ ] I know how to verify my changes work correctly
- [ ] I have planned manual testing steps
- [ ] I have identified automated tests to run
- [ ] I have considered performance implications
- [ ] I can demonstrate the fix/feature working

## Risk Assessment

### Potential Risks
- [ ] I have identified what could go wrong
- [ ] I have planned mitigation strategies
- [ ] I understand the blast radius of my changes
- [ ] I have considered timing and scheduling
- [ ] I have a rollback plan if needed

### Scope Management
- [ ] I have clearly defined what is in-scope
- [ ] I have clearly defined what is out-of-scope
- [ ] I will avoid scope creep
- [ ] I will focus on the minimal necessary changes
- [ ] I will defer non-critical improvements

## Final Check

### Readiness Assessment
- [ ] I am confident I understand the task
- [ ] I have a clear plan of action
- [ ] I have the necessary access and permissions
- [ ] I have allocated sufficient time
- [ ] I am ready to begin implementation

### Go/No-Go Decision
- [ ] **GO**: All critical items are checked, proceed with implementation
- [ ] **NO-GO**: Critical gaps identified, need more preparation

## Post-Implementation Review

After completing the work, review this checklist:
- [ ] Did I follow the plan?
- [ ] Were there unexpected challenges?
- [ ] What would I do differently next time?
- [ ] What did I learn?
- [ ] Should any conventions be updated based on this work?

---

## Notes

Use this space for notes, clarifications, or decisions made during the reflection process:

```
[Add your notes here]
```

---

**Remember**: Taking time to reflect and plan before coding saves time overall and results in higher quality work. When in doubt, pause and review this checklist again.
