#!/usr/bin/env bash
# List all Terraform modules and their deployment status
# Outputs JSON array of modules with status
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

MODULES=(
    "harness-platform-setup"
    "harness-organization"
    "harness-project"
    "central-build-farm-setup"
    "ci-module-primer"
    "ci-golden-pipeline"
    "ci-sto-hcr-standard"
    "sto-sast-primer"
    "ccm-k8s-connectors"
    "ccm-auto-k8s-connectors"
    "ccm-autostop-primer"
    "ccm-cluster-orchestrator-deployment"
    "rbac-manager"
    "harness-ci-image-factory"
    "delegate-image-factory"
    "secret_manager_github_pat"
    "secret-manager-cyberark-conjur"
    "ansible-step-group-template"
)

echo "["
FIRST=true
for module in "${MODULES[@]}"; do
    MODULE_DIR="$REPO_ROOT/$module"
    if [ "$FIRST" = true ]; then
        FIRST=false
    else
        echo ","
    fi

    HAS_STATE=false
    HAS_TFVARS=false
    HAS_PROVIDER=false

    [ -f "$MODULE_DIR/terraform.tfstate" ] && HAS_STATE=true
    [ -f "$MODULE_DIR/terraform.tfvars" ] && HAS_TFVARS=true
    [ -f "$MODULE_DIR/providers.tf" ] && HAS_PROVIDER=true

    STATUS="not_deployed"
    [ "$HAS_STATE" = true ] && STATUS="deployed"
    [ "$HAS_TFVARS" = true ] && [ "$HAS_STATE" = false ] && STATUS="configured"

    echo -n "  {\"name\": \"$module\", \"status\": \"$STATUS\", \"has_state\": $HAS_STATE, \"has_tfvars\": $HAS_TFVARS, \"has_provider\": $HAS_PROVIDER}"
done
echo ""
echo "]"
