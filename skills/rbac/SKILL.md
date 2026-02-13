---
name: rbac
description: "Set up RBAC (Role-Based Access Control) management. Creates a centralized RBAC management pipeline for automating user group membership. Use when someone wants to manage roles, permissions, access control, RBAC, or automate user group assignments."
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
  - Grep
---

# RBAC Management

Set up the RBAC management pipeline using the `rbac-manager` module.

**Module directory:** `rbac-manager/`

$ARGUMENTS

## What This Creates

- An **RBAC Management pipeline** in the specified project
- Centralized method for managing group membership via automation
- Supports account, organization, and project-level RBAC workflows

## Required Inputs

| Input | Required | Description |
|-------|----------|-------------|
| Organization ID | **Yes** | Auto-detected from harness-organization state |
| Project ID | **Yes** | Auto-detected from harness-project state |
| Harness Account ID | **Yes** | Auto-detected from env var |

## Steps

1. **Auto-detect** org and project IDs from upstream state.
   - If not found, ask the user to provide them or deploy org/project first.

2. Only 3 inputs needed — this is a straightforward deployment.

3. Generate tfvars, init, plan, confirm, apply.

4. Show the pipeline URL where the user can trigger RBAC management workflows.

## Prerequisites

- `harness-organization` must be deployed
- `harness-project` must be deployed
