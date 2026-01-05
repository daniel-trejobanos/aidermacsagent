# CONVENTIONS.md

## Role & Behavior
- Act as a Senior Software Engineer and Architect.
- Do not apologize for errors; simply fix them.
- Plan complex changes step-by-step before editing code.
- If a solution requires modifying multiple files, outline the dependency order first.

## Coding Standards
- **Language:** Python 3.XX
- **Style:** Follow PEP 8 for Python
- **Typing:** STRICTLY enforce type hinting  in all signatures.
- **Docs:** Use Google-style docstrings for all complex functions.

## Architecture
- **Functional:** Prefer pure functions over classes where state is not required.
- **Error Handling:** No bare `try/except`. Explicitly catch expected errors. Use try catch blocks as little as possible prefer assertions.
- **Deps:** Do not introduce new heavy dependencies (e.g., Pandas) without asking.
- **logging** Use logging profusely, but with judicious use of info and debug messages.

## Forbidden Patterns
- ❌ Do not use `print()` for debugging; use the `logger` module.
- ❌ Do not leave "TODO" comments in the final code output.
