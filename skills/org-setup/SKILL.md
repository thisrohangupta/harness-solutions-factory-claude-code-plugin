---
name: org-setup
description: "Create a new Harness Organization with roles, user groups, resource groups, environments, and governance policies. Use when someone wants to create a new org, set up an organization, or provision organizational structure in Harness."
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
  - Grep
---

# Organization Setup

Create a Harness Organization using the `harness-organization` module.

**Module directory:** `harness-organization/`

$ARGUMENTS

## What This Creates

- A new Harness **Organization**
- Organization-level **custom roles** (from `templates/roles/*.yaml` — 26+ permission sets)
- Organization-level **user groups** (from `templates/groups/*.yaml` — with SSO mapping support)
- Organization-level **resource groups** (permission scoping)
- Organization-level **environments** (Dev, Test, Prod)
- **OPA policies** and **policy sets** for governance

## Required Inputs

| Input | Required | Description |
|-------|----------|-------------|
| Organization Name | **Yes** | Name for the new organization |
| Harness Account ID | **Yes** | Auto-detected from env var |
| Organization ID | No | Custom identifier (auto-generated from name if omitted — spaces/dashes become underscores) |
| Description | No | Defaults to "Harness Organization managed by Solutions Factory" |
| Tags | No | Custom resource tags |

## Steps

1. **Auto-detect** account ID from `HARNESS_ACCOUNT_ID` env var.

2. **Ask the user for:**
   - Organization name (required)
   - Custom identifier? (explain: auto-generated from name, spaces become underscores)
   - Description? (optional)
   - Custom tags? (optional)

3. **Generate `terraform.tfvars`** in `harness-organization/`.

4. **Ensure `providers.tf` exists** in the module directory.

5. **Run `tofu init`**, then **`tofu plan`**.

6. **Present the plan** in plain language:
   - "This will create organization '{name}' with X roles, Y user groups, and Z governance policies."

7. **On confirmation**, run `tofu apply`.

8. **Capture outputs:**
   - `organization_identifier` — save for downstream modules
   - `organization_url` — show to user

9. **Show next steps:**
   - "Organization '{name}' created (ID: {id}). View it at: {url}"
   - "Next: create a project with `/harness-factory:project-setup`"

## Prerequisites

- `harness-platform-setup` is recommended but not strictly required
