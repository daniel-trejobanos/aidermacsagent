#!/bin/bash

# --- CONFIGURATION ---
MAX_LOOPS=10
MODEL="gemini/gemini-1.5-pro"
TEST_CMD="pytest"  # Adjust for your project (npm test, cargo test, etc.)
# ---------------------

echo "🔥 Waking up Ralph (Safe Mode)..."

# Ensure we start clean
if [[ -n $(git status --porcelain) ]]; then
    echo "❌ Error: Working directory not clean. Commit changes before running Ralph."
    exit 1
fi

for ((i=1; i<=MAX_LOOPS; i++)); do
    echo "------------------------------------------------"
    echo "🔄 Ralph Loop: $i / $MAX_LOOPS"
    echo "------------------------------------------------"

    # 1. SNAPSHOT STATE
    START_COMMIT=$(git rev-parse HEAD)
    echo "📍 Snapshot taken at commit: ${START_COMMIT:0:7}"

    # 2. PREPARE CONTEXT
    PRD_CONTENT=$(cat PRD.json)
    PROGRESS_CONTENT=$(cat progress.txt 2>/dev/null || echo "No progress yet.")

    PROMPT="You are Ralph, an autonomous coding agent.
    
    Current PRD (JSON):
    \`\`\`json
    $PRD_CONTENT
    \`\`\`
    
    History:
    \`\`\`text
    $PROGRESS_CONTENT
    \`\`\`
    
    YOUR MISSION:
    1. Read the PRD. Find the FIRST item where 'status' is 'pending'.
    2. Focus ONLY on that single item.
    3. Implement changes and VERIFY with tests.
    4. If you succeed: Update 'PRD.json' (status='completed') and append to 'progress.txt'.
    5. If you fail to fix the code: Do NOT update the PRD. Append a failure note to 'progress.txt'.
    
    CRITICAL:
    - If no pending work exists, reply with: <promise>COMPLETE</promise>
    - End response with '/exit' to close session.
    "

    # 3. RUN AIDER
    # We allow Aider to try and fix its own errors first.
    aider \
        --read PRD.json \
        --read progress.txt \
        --test-cmd "$TEST_CMD" \
        --auto-commits \
        --yes \
        --message "$PROMPT"

    # 4. THE SAFETY NET CHECK
    echo "🕵️  Verifying system integrity..."
    
    # Run the test command explicitly to verify the final state
    eval "$TEST_CMD"
    TEST_EXIT_CODE=$?

    if [ $TEST_EXIT_CODE -eq 0 ]; then
        echo "✅ Success! Tests passed. Keeping changes."
        
        # Check if complete
        PENDING_COUNT=$(jq '[.requirements[] | select(.status == "pending")] | length' PRD.json)
        if [ "$PENDING_COUNT" -eq "0" ]; then
            echo "🎉 Ralph has finished all tasks!"
            break
        fi
        
    else
        echo "🚨 FAILURE: Tests failed after agent attempt."
        echo "Create rollback..."
        
        # --- THE ROLLBACK ---
        git reset --hard "$START_COMMIT"
        git clean -fd  # Remove any untracked files Aider created
        
        echo "🔙 Rolled back to ${START_COMMIT:0:7}."
        
        # Log the failure so the next loop doesn't try the exact same strategy blindly
        echo "⚠️  Loop $i FAILED. Rolled back changes. Agent failed to satisfy tests." >> progress.txt
    fi

    echo "💤 Ralph is sleeping for 5 seconds..."
    sleep 5
done

echo "🏁 Ralph session ended."
