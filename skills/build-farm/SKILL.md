---
name: build-farm
description: "Set up the Central Build Farm with connectors for source code managers (GitHub, GitLab, Bitbucket), container registries (Docker Hub, AWS ECR, GCP Artifact Registry, Azure ACR), and artifact managers (Nexus, Artifactory, Helm). Use when someone wants to configure build infrastructure, set up connectors, or prepare CI build runners."
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
  - Grep
---

# Build Farm Setup

Configure the Central Build Farm using the `central-build-farm-setup` module.

**Module directory:** `central-build-farm-setup/`

$ARGUMENTS

## What This Creates

- **Kubernetes connector** for build infrastructure (if self-hosted)
- **Source Code Manager connector** (GitHub, GitLab, or Bitbucket)
- **Container Registry connector** (Docker Hub, AWS ECR, GCP GAR, or Azure ACR)
- **Artifact Manager connector** (Nexus, Artifactory, OCI Helm, or HTTP Helm)
- Both self-hosted and Harness Cloud variants of connectors based on infrastructure type

## Conversation Flow

This module has many configuration options. Guide the user through these decisions one at a time:

### 1. Build Infrastructure
"Will your builds run on your own Kubernetes cluster, Harness Cloud, or both?"
→ Maps to `build_infrastructure_type`: `internal` / `cloud` / `both`

### 2. Source Code Manager
"Where is your source code hosted?"
- GitHub → `source_code_manager_type = "github"`
- GitLab → `source_code_manager_type = "gitlab"`
- Bitbucket → `source_code_manager_type = "bitbucket"`

Then ask:
- "What's the URL?" (default: https://github.com for GitHub)
- "Give me a repo to validate the connection" (e.g., `org/repo`)

### 3. Container Registry
"What container registry do you use?"
- Docker Hub → `container_registry_type = "docker"`, then ask provider (DockerHub/Harbor/Quay/Other)
- AWS ECR → `container_registry_type = "aws"`, ask for region and role ARN
- GCP Artifact Registry → `container_registry_type = "gcp"`, ask for workload identity
- Azure ACR → `container_registry_type = "azure"`, ask for subscription/app ID

### 4. Artifact Manager (optional)
"Do you use an artifact manager like Nexus or Artifactory?"
- If yes: gather type, URL, auth type
- If no: skip (set to "skipped")

### 5. Delegate Selectors
"What delegate selectors should be used?" (default: `["build-farm"]`)

## After Gathering

1. Generate `terraform.tfvars` with all collected values
2. Run init → plan → show summary → confirm → apply
3. **Show created connector IDs** in the output — these are needed by CI modules:
   - `build_farm_connector`
   - `build_farm_container_registry`
   - `build_farm_source_code_manager`
   - `build_farm_artifact_manager`

## Prerequisites

- None (account-level module)
- Connector credential secrets should exist in Harness before running
