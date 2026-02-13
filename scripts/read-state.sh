#!/usr/bin/env bash
# Read terraform state for a module and output formatted summary
# Usage: read-state.sh <module-dir>
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MODULE_DIR="$REPO_ROOT/${1:-}"

if [ ! -d "$MODULE_DIR" ]; then
    echo "{\"error\": \"Module directory not found: $1\"}"
    exit 1
fi

cd "$MODULE_DIR"

# Determine IaC tool
IAC_CMD="tofu"
command -v tofu &>/dev/null || IAC_CMD="terraform"

# Check if state exists
if [ ! -f "terraform.tfstate" ] && [ ! -d ".terraform" ]; then
    echo "{\"status\": \"not_deployed\", \"module\": \"$1\"}"
    exit 0
fi

# Try to read state
RESOURCE_LIST=$($IAC_CMD state list 2>/dev/null || echo "")
if [ -z "$RESOURCE_LIST" ]; then
    echo "{\"status\": \"empty\", \"module\": \"$1\", \"resource_count\": 0, \"resources\": [], \"outputs\": {}}"
    exit 0
fi

RESOURCE_COUNT=$(echo "$RESOURCE_LIST" | wc -l | tr -d ' ')

# Try to read outputs
OUTPUTS=$($IAC_CMD output -json 2>/dev/null || echo "{}")

# Format resources as JSON array
RESOURCES_JSON=$(echo "$RESOURCE_LIST" | python3 -c "import sys,json; print(json.dumps([l.strip() for l in sys.stdin if l.strip()]))" 2>/dev/null || echo "[]")

echo "{"
echo "  \"status\": \"deployed\","
echo "  \"module\": \"$1\","
echo "  \"resource_count\": $RESOURCE_COUNT,"
echo "  \"resources\": $RESOURCES_JSON,"
echo "  \"outputs\": $OUTPUTS"
echo "}"
