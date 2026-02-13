---
name: platform-setup
description: "Set up the Harness Platform account baseline. Creates account-level roles (Shared Resource Access), admin user groups, and OPA governance policies (template versioning, API token age enforcement). Use when someone wants to initialize their Harness account, set up the platform foundation, or configure account-level governance."
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
  - Grep
---

# Platform Setup

Set up the Harness Platform account baseline using the `harness-platform-setup` module.

**Module directory:** `harness-platform-setup/`

$ARGUMENTS

## What This Creates

- **Shared Resource Access** role — grants access to account-level shared resources
- **Harness Account Admins** user group with account_admin role binding
- **All Account Users** group updated with Shared Resource Access role binding
- **OPA Governance Policies:**
  - Enforce Template Version Schema (templates must use `v{number}` versioning)
  - Enforce Harness API Token Age (30-day maximum age)

## Required Inputs

| Input | Required | Description |
|-------|----------|-------------|
| Harness Account ID | **Yes** | Your Harness account identifier |
| Platform URL | No | Defaults to `https://app.harness.io/gateway` for SaaS |
| Tags | No | Custom resource tags |

## Steps

1. **Auto-detect** the account ID from `HARNESS_ACCOUNT_ID` env var. If not set, ask the user.

2. **Ask:**
   - Are you using Harness SaaS (app.harness.io) or a self-managed instance?
   - Any custom tags to add to resources? (optional)

3. **Generate `terraform.tfvars`** in `harness-platform-setup/` with the collected values.

4. **Ensure `providers.tf` exists** — copy from `providers.tf.example` at repo root if missing.

5. **Run `tofu init`** in the module directory.

6. **Run `tofu plan`** and present results in plain language:
   - "This will create X roles, Y user groups, and Z OPA governance policies at the account level."

7. **Ask for confirmation**, then run `tofu apply -auto-approve -var-file=terraform.tfvars`.

8. **Show results** and next steps:
   - "Account baseline is configured. Next, create an organization with `/harness-factory:org-setup`."

## Prerequisites

- None — this is the first module in the dependency chain
