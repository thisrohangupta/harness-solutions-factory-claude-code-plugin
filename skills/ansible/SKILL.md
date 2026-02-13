---
name: ansible
description: "Set up Ansible step group templates for running Ansible playbooks in CI, Deployment, and IACM pipelines. Use when someone wants Ansible integration, playbook execution, configuration management, or Ansible templates in Harness."
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
  - Grep
---

# Ansible Step Group Templates

Set up Ansible execution templates using the `ansible-step-group-template` module.

**Module directory:** `ansible-step-group-template/`

$ARGUMENTS

## What This Creates

- **Ansible step group templates** for each specified stage type:
  - Deployment — run Ansible in CD pipelines
  - CI — run Ansible in CI pipelines
  - IACM — run Ansible in Infrastructure as Code pipelines
- Configurable Docker image for Ansible execution (default: `alpine/ansible`)
- Support for Harness Code Repository playbook storage

## Inputs

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| Template Name | No | "Execute Ansible" | Display name for templates |
| Template Version | No | "1.0" | Version label |
| Stage Types | No | Deployment, CI, IACM | Which pipeline types get templates |
| Harness Code | No | false | Use Harness Code for playbooks? |
| Docker Image | No | alpine/ansible | Ansible execution image |
| K8s Connector | No | skipped | For self-hosted runners |

## Conversation Flow

1. "Which pipeline types need Ansible support?"
   - Deployment pipelines (CD)
   - CI pipelines
   - IACM pipelines
   - All three (default)

2. "Will you store Ansible playbooks in Harness Code Repository?"

3. "Any custom Ansible image?" (most users: use the default)

4. "Self-hosted K8s or Harness Cloud?" (determines kubernetes_connector)

5. Most defaults are sensible — keep it simple unless the user asks for customization.

6. Generate tfvars, init, plan, confirm, apply.

## Prerequisites

- None (can deploy at any level)
