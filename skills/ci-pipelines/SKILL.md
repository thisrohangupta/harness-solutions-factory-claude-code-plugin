---
name: ci-pipelines
description: "Set up CI pipeline templates and golden pipelines. Creates reusable CI stage templates, step group templates (build, lint, scan, supply chain security), and optionally pre-built pipelines for specific repositories with webhook triggers. Use when someone wants to set up CI, continuous integration, build pipelines, or CI templates."
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
  - Grep
---

# CI Pipelines

Set up CI using `ci-module-primer` and optionally `ci-golden-pipeline`.

**Module directories:**
- `ci-module-primer/` — reusable CI templates
- `ci-golden-pipeline/` — pre-built pipeline for a specific repo

$ARGUMENTS

## What These Create

### ci-module-primer (templates)
- **CI Stage Template** — complete CI workflow stage
- **Step Group Templates:**
  - Code Smells & Linting (static analysis, secrets scanning)
  - Build & Scan Container Image (Docker build, scan, push)
  - Supply Chain Security (SBOM generation, SLSA provenance, signing)
- Supports both Harness Cloud and self-hosted Kubernetes execution

### ci-golden-pipeline (per-repo pipeline)
- Pre-built CI **pipeline** for a specific repository
- **Webhook triggers** for automatic execution (GitHub, Bitbucket, or Harness Code)
- **Input sets** with default branch configurations
- Uses templates created by ci-module-primer

## Conversation Flow

### For ci-module-primer:

1. **Auto-detect org/project** from upstream state:
   ```bash
   cd harness-organization && tofu output -json 2>/dev/null
   cd harness-project && tofu output -json 2>/dev/null
   ```

2. "Where should CI templates be deployed?" → `organization_id`, `project_id` (can be account-level if both null)

3. "Will your CI pipelines run on self-hosted Kubernetes or Harness Cloud?"
   - Self-hosted → ask for `kubernetes_connector` and `kubernetes_namespace`
   - Harness Cloud → set `kubernetes_connector = "skipped"`

4. "Do you want Harness Code Repository support?" → `should_support_hcr` (default: true)

5. Generate tfvars, init, plan, confirm, apply.

### For ci-golden-pipeline (optional):

After deploying ci-module-primer, ask:

6. "Do you want to create a CI pipeline for a specific repository now?"

7. If yes, gather:
   - Pipeline name
   - Repository path (e.g., `org/repo-name`)
   - Webhook type: GitHub, Bitbucket, or Harness Code
   - Branch patterns (optional — for trigger configuration)
   - Template location (auto-detect from ci-module-primer output)

8. Generate tfvars, deploy.

## Prerequisites

- Organization and project recommended (but can deploy at account level)
- `central-build-farm-setup` recommended for connector references
- `ci-module-primer` must be deployed before `ci-golden-pipeline`
