#!/bin/bash

echo "🤔 Reflector is thinking..."

# 1. Update the Map first to ensure it's fresh
./generate_map  # Assumes you have the script from the previous step

# 2. Run Aider in "Ask" mode (Read-Only)
# --read-only: Prevents any code edits.
# --no-auto-commits: Keeps git clean.
aider \
    --read PRD.json \
    --read MAP.md \
    --read PRD.json \
    --read MAP.md \
    --file REFLECT.md \
    --no-auto-commits \
    --message "Read REFLECT.md and perform the analysis on PRD.json and MAP.md. Output ONLY your analysis."
