---
name: ccm-finops
description: "Set up Cloud Cost Management (CCM) and FinOps capabilities. Includes Kubernetes connectors for cost visibility, automatic K8s connector discovery, AutoStopping for idle resources, and Cluster Orchestrator for spot instance optimization. Use when someone wants cloud cost management, CCM, FinOps, cost optimization, autostop, spot instances, or cluster orchestrator."
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
  - Grep
---

# CCM / FinOps Setup

Set up Cloud Cost Management using one or more CCM modules.

**Module directories:**
- `ccm-k8s-connectors/` — manual K8s + CCM connector pair
- `ccm-auto-k8s-connectors/` — auto-discovery pipeline for K8s clusters
- `ccm-autostop-primer/` — AutoStopping templates and pipeline
- `ccm-cluster-orchestrator-deployment/` — Cluster Orchestrator for spot optimization

$ARGUMENTS

## Module Options

### 1. K8s Cost Visibility (ccm-k8s-connectors)
Creates a Kubernetes connector + Cloud Cost connector pair for a single cluster. Best for manually registering individual clusters.
- **Inputs:** delegate_name, cluster_name, enable_optimization
- **Level:** Account

### 2. Auto K8s Discovery (ccm-auto-k8s-connectors)
Creates a pipeline that automatically discovers and registers all K8s clusters via delegates. Runs on a cron schedule. Best for environments with many clusters.
- **Inputs:** org_id, project_id, kubernetes_connector, docker_connector, API key secret, cron schedule
- **Level:** Project
- **Dependencies:** harness-project

### 3. AutoStopping (ccm-autostop-primer)
Creates templates and a pipeline for applying auto-stop rules to idle K8s services. Automatically shuts down dev/test workloads when not in use.
- **Inputs:** org_id, project_id, kubernetes_connector, API key secret
- **Level:** Project
- **Dependencies:** harness-project

### 4. Cluster Orchestrator (ccm-cluster-orchestrator-deployment)
Deploys the Cluster Orchestrator service for spot instance optimization on production clusters. Reduces compute costs by leveraging spot/preemptible instances.
- **Inputs:** org_id (optional), project_id (optional), docker_connector
- **Level:** Any

## Conversation Flow

1. "What CCM capabilities do you need?"
   - **Cost visibility** for K8s clusters → module 1 or 2
   - **AutoStopping** idle dev/test resources → module 3
   - **Spot instance optimization** for production → module 4

2. For each selected module, gather the required inputs conversationally.

3. Deploy modules in order based on dependencies.

4. After deployment, explain what was set up and how to use it:
   - For auto-discovery: "A pipeline will run daily at {time} to find new K8s clusters"
   - For AutoStopping: "Apply auto-stop rules to namespaces via the deployed pipeline"
   - For Cluster Orchestrator: "Deploy the orchestrator Helm chart to your clusters"

## Prerequisites

- For modules 2 and 3: organization and project must exist
- For auto-discovery: existing K8s and Docker connectors needed
- For AutoStopping: Harness API key secret reference needed
