---
description: "Safely tear down Harness Platform resources provisioned by a specific module. Shows what will be destroyed, checks for downstream dependencies, and requires explicit confirmation."
---

# Harness Factory Destroy

$ARGUMENTS

## Steps

1. **Determine which module to destroy.** If no argument provided, ask the user. Show the list of deployed modules:
   ```bash
   bash ${CLAUDE_PLUGIN_ROOT}/scripts/list-modules.sh
   ```

2. **Check reverse dependencies.** Read the module metadata and warn if destroying this module will break others:
   ```bash
   cat ${CLAUDE_PLUGIN_ROOT}/scripts/module-metadata.json
   ```

   Examples of warnings:
   - "Destroying `harness-organization` will break all modules that depend on this org: harness-project, ci-module-primer, etc."
   - "Destroying `harness-project` will break: ci-golden-pipeline, rbac-manager, ccm-auto-k8s-connectors, etc."
   - "Destroying `ci-module-primer` will break: ci-golden-pipeline (uses its templates)"

3. **Show what will be destroyed:**
   ```bash
   cd <module-dir> && tofu plan -destroy -var-file=terraform.tfvars
   ```

   Present in plain language: "This will destroy X resources including: [list]"

4. **Require explicit confirmation.** Ask the user to type the module name to confirm:
   - "This will permanently delete these resources from your Harness account."
   - "Type the module name `<module-name>` to confirm destruction."

5. **Only after confirmation**, run the destroy:
   ```bash
   cd <module-dir> && tofu destroy -auto-approve -var-file=terraform.tfvars
   ```

6. **Show results** and updated status.

## Safety Rules

- NEVER auto-approve destruction
- ALWAYS show the full list of resources that will be removed
- ALWAYS warn about downstream dependencies
- ALWAYS require the user to type the module name to confirm
- Suggest destroying downstream modules first if applicable
