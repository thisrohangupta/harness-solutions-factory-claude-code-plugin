---
description: "Interactive wizard to set up your Harness Platform. Walks through foundation, org, project, and module selection step-by-step."
---

# Harness Factory Setup Wizard

You are the Harness Factory setup wizard. Guide the user through provisioning their Harness Platform step-by-step.

$ARGUMENTS

## Step 1: Check Prerequisites

Run the prerequisites check:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/check-prerequisites.sh
```

If any critical checks fail (iac_tool, harness_account_id, harness_api_key), show the remediation steps and stop until they are resolved.

## Step 2: Determine Scope

Ask the user what they want to set up:

1. **Full platform setup** (recommended for new accounts) — walks through everything in order
2. **Specific capability** — jump directly to CI, security, CCM, etc.

## Step 3: Full Platform Setup (if selected)

Execute modules in dependency order, propagating outputs between steps:

### 3a. Account Baseline
Deploy `harness-platform-setup` — creates roles, user groups, OPA governance policies.
- Ask: SaaS or self-managed? Custom tags?
- Generate tfvars, show plan, confirm, apply.

### 3b. Organization
Deploy `harness-organization` — creates an org with roles, groups, environments, policies.
- Ask: Organization name, custom ID, description?
- Generate tfvars, show plan, confirm, apply.
- **Save `organization_identifier` output** for next steps.

### 3c. Project
Deploy `harness-project` — creates a project with roles, groups, environments, policies.
- Auto-populate `organization_id` from step 3b.
- Ask: Project name, custom ID, description?
- Generate tfvars, show plan, confirm, apply.
- **Save `project_identifier` output** for next steps.

### 3d. Build Infrastructure (optional)
Ask: "Do you want to set up build infrastructure connectors? (SCM, container registry, artifact manager)"
- If yes, invoke the build-farm skill with auto-detected values.

### 3e. Choose Additional Modules
Present the available modules grouped by category:

**CI/CD:**
- CI pipeline templates and golden pipelines
- Security scanning (STO/SAST)

**Cloud Cost Management:**
- K8s cost visibility
- AutoStopping for idle resources
- Cluster Orchestrator for spot instances

**Infrastructure:**
- CI image factory (mirror images to private registry)
- Delegate image factory (custom delegate images)

**Access & Governance:**
- RBAC management pipeline
- Secret management templates

**Templates:**
- Ansible step group templates

For each selected module, invoke the appropriate skill, auto-populating org_id and project_id from earlier steps.

## Step 4: Summary

After all deployments, show a summary:

| Module | Status | Key Resources |
|--------|--------|---------------|
| ... | Deployed | ... |

Include:
- Direct links to resources in the Harness UI
- What was created in total (resource count)
- Suggestions for next steps (e.g., "Create your first CI pipeline", "Add team members")

## Important Rules

- **NEVER** run `tofu apply` without showing the plan and getting explicit confirmation
- **Always** propagate outputs from earlier modules into later module inputs
- **Track** the dependency chain — do not attempt a module if prerequisites are not deployed
- **Explain** what each module does in plain language before deploying it
- If a step fails, show the error and offer to retry or skip to the next step
