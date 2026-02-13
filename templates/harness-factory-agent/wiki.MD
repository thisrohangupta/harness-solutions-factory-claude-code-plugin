# Harness Factory Agent

**Version:** 1.0.0
**Name:** Harness Factory Agent

## Overview

An AI-powered agent that provisions and manages your Harness Platform using natural language. Describe what you want — organizations, projects, CI/CD pipelines, security scanning, cloud cost management — and the agent generates and applies the Terraform automatically.

Built on [Claude Code](https://docs.anthropic.com/en/docs/claude-code) with 18 embedded Terraform modules covering the full Harness Platform.

## Key Capabilities

- **Platform Foundation** — Organizations, projects, RBAC, governance policies
- **CI/CD Pipelines** — Stage/step templates, golden pipelines, triggers
- **Security Scanning** — STO scanners (Gitleaks, OSV, OWASP, Semgrep)
- **Cloud Cost Management** — K8s cost visibility, AutoStopping, Cluster Orchestrator
- **Infrastructure** — SCM connectors, container registries, image factories
- **Secrets** — GitHub PAT dispenser, CyberArk Conjur integration

## Required Inputs

| Input              | Type   | Description                        | Default                              |
| ------------------ | ------ | ---------------------------------- | ------------------------------------ |
| `anthropicKey`     | secret | Anthropic API key for Claude       | _Required_                           |
| `harnessAccountId` | string | Harness account ID                 | _Required_                           |
| `harnessApiKey`    | secret | Harness Platform API key           | _Required_                           |
| `harnessEndpoint`  | string | Harness API gateway endpoint       | `https://app.harness.io/gateway`     |
| `prompt`           | string | Natural-language instruction       | _Required_                           |
| `maxTurns`         | string | Maximum number of agentic turns    | `30`                                 |

## Example Prompts

```
Create an organization called "Platform Engineering" with a project called "shared-services"
```

```
Set up CI pipelines with SAST security scanning for my project
```

```
Enable cloud cost management with K8s connectors and AutoStopping rules
```

```
Configure RBAC with admin and developer roles for my organization
```

## Prerequisites

- **Harness Account** — with API key that has admin privileges
- **Anthropic API Key** — for Claude Code access
- **Harness Secrets** — store API keys as Harness secrets before running

## Configuration

- **Platform:** Linux (amd64)
- **Max Turns:** 30 (configurable)
- **Terraform Backend:** Local state within the container

## Troubleshooting

- **Agent fails to start:** Verify both `anthropicKey` and `harnessApiKey` secrets are configured correctly
- **Terraform errors:** Ensure the Harness API key has sufficient permissions for the requested resources
- **Timeout:** Increase `maxTurns` for complex provisioning tasks that require many steps
- **Endpoint issues:** Verify `harnessEndpoint` if using Harness Self-Managed Enterprise Edition

---

**Last Updated:** February 2026
