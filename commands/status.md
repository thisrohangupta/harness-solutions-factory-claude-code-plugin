---
description: "Show the current state of your Harness Platform provisioning. Displays which modules are deployed, resource counts, key outputs, and what can be deployed next."
---

# Harness Factory Status

$ARGUMENTS

Check the deployment state across all Terraform modules in this repository.

## Steps

1. **List all modules:**
   ```bash
   bash ${CLAUDE_PLUGIN_ROOT}/scripts/list-modules.sh
   ```

2. **For each deployed module**, read detailed state:
   ```bash
   bash ${CLAUDE_PLUGIN_ROOT}/scripts/read-state.sh <module-name>
   ```

3. **Present a summary table:**

   | Module | Category | Status | Resources | Key Outputs |
   |--------|----------|--------|-----------|-------------|
   | harness-platform-setup | Platform | ... | ... | ... |
   | harness-organization | Platform | ... | ... | org_id = ... |
   | harness-project | Platform | ... | ... | project_id = ... |
   | central-build-farm-setup | Infrastructure | ... | ... | ... |
   | ci-module-primer | CI | ... | ... | ... |
   | ... | ... | ... | ... | ... |

4. **Show what can be deployed next** based on the dependency graph:
   - List modules whose dependencies are all satisfied
   - Flag any modules that are blocked

5. **If a specific module is mentioned** in the arguments, show detailed state:
   - Full resource list
   - All output values with descriptions
   - Last modified timestamp
   - Upstream dependencies (what it needs)
   - Downstream dependents (what needs it)

## Category Groupings

- **Platform Foundation:** harness-platform-setup, harness-organization, harness-project, rbac-manager
- **Build Infrastructure:** central-build-farm-setup, harness-ci-image-factory, delegate-image-factory
- **Continuous Integration:** ci-module-primer, ci-golden-pipeline
- **Security:** sto-sast-primer, ci-sto-hcr-standard
- **Cloud Cost Management:** ccm-k8s-connectors, ccm-auto-k8s-connectors, ccm-autostop-primer, ccm-cluster-orchestrator-deployment
- **Secret Management:** secret_manager_github_pat, secret-manager-cyberark-conjur
- **Templates:** ansible-step-group-template
