---
name: status
description: "Check the deployment status of all Harness Factory modules. Shows what is deployed, resource counts, key outputs like org IDs and project IDs, and what can be deployed next. Use when someone asks what is deployed, what is the current state, what has been set up, or wants to see infrastructure status."
allowed-tools:
  - Bash
  - Read
  - Glob
---

# Deployment Status

Check the deployment state across all Harness Factory modules.

$ARGUMENTS

## Steps

1. **List all modules and their status:**
   ```bash
   bash ${CLAUDE_PLUGIN_ROOT}/scripts/list-modules.sh
   ```

2. **For each deployed module, read detailed state:**
   ```bash
   bash ${CLAUDE_PLUGIN_ROOT}/scripts/read-state.sh <module-name>
   ```

3. **Present a summary table:**

   | Module | Status | Resources | Key Outputs |
   |--------|--------|-----------|-------------|
   | harness-platform-setup | Deployed/Not deployed | N | ... |
   | harness-organization | ... | ... | org_id = ... |
   | ... | ... | ... | ... |

4. **Show dependency-aware recommendations:**
   - Which modules can be deployed next (all dependencies satisfied)
   - Which modules are blocked (missing prerequisites)
   - Group by category: Platform, CI, Security, CCM, etc.

5. **If a specific module is mentioned**, show detailed state:
   - Full resource list
   - All output values
   - Last modified timestamp
   - What depends on this module

## Status Legend

- **Deployed** — terraform state exists with resources
- **Configured** — tfvars generated but not yet applied
- **Not deployed** — no configuration or state
