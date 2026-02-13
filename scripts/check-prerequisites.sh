#!/usr/bin/env bash
# Check prerequisites for Harness Factory
# Outputs JSON with pass/fail/warn status for each check
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "{"
echo "  \"prerequisites\": {"

# Check 1: OpenTofu or Terraform
if command -v tofu &>/dev/null; then
    VERSION=$(tofu version 2>/dev/null | head -1)
    echo "    \"iac_tool\": {\"status\": \"pass\", \"tool\": \"tofu\", \"version\": \"$VERSION\"},"
elif command -v terraform &>/dev/null; then
    VERSION=$(terraform version 2>/dev/null | head -1)
    echo "    \"iac_tool\": {\"status\": \"pass\", \"tool\": \"terraform\", \"version\": \"$VERSION\", \"note\": \"This repo defaults to OpenTofu. Consider installing it: https://opentofu.org/docs/intro/install/\"},"
else
    echo "    \"iac_tool\": {\"status\": \"fail\", \"message\": \"Neither tofu nor terraform found. Install OpenTofu: https://opentofu.org/docs/intro/install/\"},"
fi

# Check 2: HARNESS_ACCOUNT_ID
if [ -n "${HARNESS_ACCOUNT_ID:-}" ]; then
    MASKED="${HARNESS_ACCOUNT_ID:0:6}..."
    echo "    \"harness_account_id\": {\"status\": \"pass\", \"value\": \"$MASKED\"},"
else
    echo "    \"harness_account_id\": {\"status\": \"fail\", \"message\": \"HARNESS_ACCOUNT_ID not set. Export it: export HARNESS_ACCOUNT_ID=your_account_id\"},"
fi

# Check 3: HARNESS_PLATFORM_API_KEY
if [ -n "${HARNESS_PLATFORM_API_KEY:-}" ]; then
    MASKED="****${HARNESS_PLATFORM_API_KEY: -4}"
    echo "    \"harness_api_key\": {\"status\": \"pass\", \"value\": \"$MASKED\"},"
else
    echo "    \"harness_api_key\": {\"status\": \"fail\", \"message\": \"HARNESS_PLATFORM_API_KEY not set. Generate one at: Harness > Account Settings > API Keys\"},"
fi

# Check 4: HARNESS_ENDPOINT
if [ -n "${HARNESS_ENDPOINT:-}" ]; then
    echo "    \"harness_endpoint\": {\"status\": \"pass\", \"value\": \"${HARNESS_ENDPOINT}\"},"
else
    echo "    \"harness_endpoint\": {\"status\": \"warn\", \"message\": \"HARNESS_ENDPOINT not set. Will default to https://app.harness.io/gateway\"},"
fi

# Check 5: Repository structure
MODULE_COUNT=0
for dir in "$REPO_ROOT"/*/; do
    [ -f "$dir/variables.tf" ] && MODULE_COUNT=$((MODULE_COUNT + 1))
done
echo "    \"repo_modules\": {\"status\": \"pass\", \"count\": $MODULE_COUNT},"

# Check 6: providers.tf.example exists
if [ -f "$REPO_ROOT/providers.tf.example" ]; then
    echo "    \"provider_template\": {\"status\": \"pass\", \"path\": \"providers.tf.example\"}"
else
    echo "    \"provider_template\": {\"status\": \"fail\", \"message\": \"providers.tf.example not found at repo root\"}"
fi

echo "  }"
echo "}"
