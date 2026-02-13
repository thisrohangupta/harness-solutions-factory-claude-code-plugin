---
name: project-setup
description: "Create a new Harness Project within an existing organization. Provisions the project with roles, user groups, resource groups, environments, and governance. Use when someone wants to create a project, set up a new project, or add a project to an organization."
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
  - Grep
---

# Project Setup

Create a Harness Project using the `harness-project` module.

**Module directory:** `harness-project/`

$ARGUMENTS

## What This Creates

- A new Harness **Project** within the specified organization
- Project-level **custom roles**, **user groups**, **resource groups**
- Project-level **environments** (Dev, Test, Prod)
- **OPA policies** and **policy sets**

## Required Inputs

| Input | Required | Description |
|-------|----------|-------------|
| Organization ID | **Yes** | Existing org — auto-detected from harness-organization state |
| Project Name | **Yes** | Name for the new project |
| Harness Account ID | **Yes** | Auto-detected from env var |
| Project ID | No | Custom identifier (auto-generated from name) |
| Description | No | Defaults to "Harness Project managed by Solutions Factory" |
| Tags | No | Custom resource tags |

## Steps

1. **Check if organization exists** by reading `harness-organization/` terraform state:
   ```bash
   cd harness-organization && tofu output -json 2>/dev/null
   ```
   If not deployed, warn: "An organization must exist first. Run `/harness-factory:org-setup`."

2. **Auto-populate `organization_id`** from the harness-organization output.

3. **Ask the user for:**
   - Project name (required)
   - Custom identifier? (optional)
   - Description? (optional)

4. **Generate `terraform.tfvars`**, **init**, **plan**, **confirm**, **apply**.

5. **Capture outputs:**
   - `project_identifier` — save for downstream modules
   - `project_url` — show to user

6. **Suggest next steps** based on what the user might want:
   - CI pipelines: `/harness-factory:ci-pipelines`
   - Security scanning: `/harness-factory:security-scanning`
   - Build infrastructure: `/harness-factory:build-farm`

## Prerequisites

- `harness-organization` must be deployed (provides `organization_id`)
