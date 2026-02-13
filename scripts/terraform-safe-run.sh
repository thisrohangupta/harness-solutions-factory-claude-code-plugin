#!/usr/bin/env bash
# PreToolUse hook for Bash commands
# Validates terraform/tofu commands are safe
# Reads hook input JSON from stdin
set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; data=json.load(sys.stdin); print(data.get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")

if [ -z "$COMMAND" ]; then
    exit 0
fi

# Block direct state manipulation
if echo "$COMMAND" | grep -qE '(tofu|terraform)\s+state\s+(rm|mv|push)'; then
    echo "BLOCKED: Direct state manipulation is not allowed through the plugin. Use the appropriate skill to manage resources." >&2
    exit 2
fi

# Block force-unlock
if echo "$COMMAND" | grep -qE '(tofu|terraform)\s+force-unlock'; then
    echo "BLOCKED: force-unlock is not allowed through the plugin." >&2
    exit 2
fi

exit 0
