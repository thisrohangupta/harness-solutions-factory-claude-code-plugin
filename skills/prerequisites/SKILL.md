---
name: prerequisites
description: "Check that all prerequisites are met for using Harness Factory. Verifies OpenTofu/Terraform installation, Harness environment variables (account ID, API key, endpoint), provider template availability, and repository structure. Use when someone wants to check readiness, verify setup, troubleshoot, or see if they can start using Harness Factory."
allowed-tools:
  - Bash
  - Read
  - Glob
---

# Prerequisites Check

Verify the environment is ready for Harness Factory operations.

$ARGUMENTS

## Checks Performed

Run the prerequisites check script and present results clearly:

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/check-prerequisites.sh
```

## Present Results

Show each check with a clear pass/fail indicator:

| Check | Status | Details |
|-------|--------|---------|
| IaC Tool | PASS/FAIL | OpenTofu v1.x.x or Terraform v1.x.x |
| Harness Account ID | PASS/FAIL | HARNESS_ACCOUNT_ID env var |
| Harness API Key | PASS/FAIL | HARNESS_PLATFORM_API_KEY env var |
| Harness Endpoint | PASS/WARN | HARNESS_ENDPOINT (defaults to SaaS if unset) |
| Repository Modules | PASS | N modules found |
| Provider Template | PASS/FAIL | providers.tf.example exists |

## Remediation

For each failing check, provide the exact fix:

- **IaC Tool missing:** `brew install opentofu` (macOS) or see https://opentofu.org/docs/intro/install/
- **Account ID missing:** `export HARNESS_ACCOUNT_ID=your_account_id` — find it at Harness > Account Settings
- **API Key missing:** `export HARNESS_PLATFORM_API_KEY=your_key` — generate at Harness > Account Settings > API Keys
- **Endpoint missing:** `export HARNESS_ENDPOINT=https://app.harness.io/gateway` — or your self-hosted URL
