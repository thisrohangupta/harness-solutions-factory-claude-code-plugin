#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────
# Harness Factory Agent — Container Entrypoint
# Maps Harness CI PLUGIN_* env vars to Claude Code CLI flags.
# ─────────────────────────────────────────────

# Harness CI plugin convention: inputs arrive as PLUGIN_<NAME> env vars
PROMPT="${PLUGIN_PROMPT:-}"
MAX_TURNS="${PLUGIN_MAX_TURNS:-30}"

# Harness Platform credentials (passed through to Terraform provider)
export HARNESS_ACCOUNT_ID="${PLUGIN_HARNESS_ACCOUNT_ID:-${HARNESS_ACCOUNT_ID:-}}"
export HARNESS_PLATFORM_API_KEY="${PLUGIN_HARNESS_API_KEY:-${HARNESS_PLATFORM_API_KEY:-}}"
export HARNESS_ENDPOINT="${PLUGIN_HARNESS_ENDPOINT:-${HARNESS_ENDPOINT:-https://app.harness.io/gateway}}"

# Anthropic API key
export ANTHROPIC_API_KEY="${PLUGIN_ANTHROPIC_API_KEY:-${ANTHROPIC_API_KEY:-}}"

# ── Validate required inputs ──────────────────
if [ -z "$PROMPT" ]; then
  echo "ERROR: PLUGIN_PROMPT is required. Provide the natural-language instruction for the agent." >&2
  exit 1
fi

if [ -z "$ANTHROPIC_API_KEY" ]; then
  echo "ERROR: ANTHROPIC_API_KEY (or PLUGIN_ANTHROPIC_API_KEY) is required." >&2
  exit 1
fi

if [ -z "$HARNESS_ACCOUNT_ID" ]; then
  echo "ERROR: HARNESS_ACCOUNT_ID (or PLUGIN_HARNESS_ACCOUNT_ID) is required." >&2
  exit 1
fi

if [ -z "$HARNESS_PLATFORM_API_KEY" ]; then
  echo "ERROR: HARNESS_PLATFORM_API_KEY (or PLUGIN_HARNESS_API_KEY) is required." >&2
  exit 1
fi

# ── Run Claude Code ───────────────────────────
echo "==> Harness Factory Agent"
echo "    Prompt:     ${PROMPT:0:120}..."
echo "    Max turns:  $MAX_TURNS"
echo "    Endpoint:   $HARNESS_ENDPOINT"
echo ""

exec claude -p "$PROMPT" \
  --allowedTools "Bash,Read,Write,Edit,Glob,Grep" \
  --max-turns "$MAX_TURNS" \
  --dangerously-skip-permissions
