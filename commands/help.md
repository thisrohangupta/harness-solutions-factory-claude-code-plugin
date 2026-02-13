---
description: "Show all available Harness Factory commands, skills, and usage information."
disable-model-invocation: true
---

# Harness Factory Help

Display the following reference information:

## Commands

| Command | Description |
|---------|-------------|
| `/harness-factory:setup` | Interactive wizard — guides you through full platform provisioning |
| `/harness-factory:status` | Show what is currently deployed across all modules |
| `/harness-factory:destroy` | Safely tear down provisioned resources with confirmation |
| `/harness-factory:help` | This help message |

## Skills (auto-invoked or use directly)

### Platform Foundation
| Skill | Trigger Phrases | What It Does |
|-------|----------------|--------------|
| `/harness-factory:platform-setup` | "set up account", "platform baseline" | Account-level roles, user groups, OPA governance policies |
| `/harness-factory:org-setup` | "create organization", "new org" | Create a Harness Organization with RBAC and governance |
| `/harness-factory:project-setup` | "create project", "new project" | Create a Project within an organization |
| `/harness-factory:rbac` | "RBAC", "roles", "permissions" | RBAC management automation pipeline |

### CI/CD
| Skill | Trigger Phrases | What It Does |
|-------|----------------|--------------|
| `/harness-factory:ci-pipelines` | "CI pipelines", "continuous integration" | CI templates + golden pipelines with triggers |
| `/harness-factory:security-scanning` | "security scanning", "STO", "SAST" | STO scanners (Gitleaks, OSV, OWASP, Semgrep) |

### Infrastructure
| Skill | Trigger Phrases | What It Does |
|-------|----------------|--------------|
| `/harness-factory:build-farm` | "build farm", "connectors" | SCM, container registry, artifact manager connectors |
| `/harness-factory:image-factories` | "image factory", "image migration" | CI image mirroring + custom delegate image pipelines |

### Cloud Cost Management
| Skill | Trigger Phrases | What It Does |
|-------|----------------|--------------|
| `/harness-factory:ccm-finops` | "cloud cost", "CCM", "FinOps" | K8s cost visibility, AutoStopping, Cluster Orchestrator |

### Secret Management & Templates
| Skill | Trigger Phrases | What It Does |
|-------|----------------|--------------|
| `/harness-factory:secret-management` | "secrets", "GitHub PAT", "CyberArk" | GitHub PAT dispenser + CyberArk Conjur templates |
| `/harness-factory:ansible` | "ansible", "playbook" | Ansible step group templates for CI/CD/IACM |

### Utilities
| Skill | Trigger Phrases | What It Does |
|-------|----------------|--------------|
| `/harness-factory:prerequisites` | "check prerequisites", "am I ready" | Verify environment setup (tofu, env vars, etc.) |
| `/harness-factory:status` | "what's deployed", "show state" | Inspect terraform state across all modules |

## Getting Started

1. **First time?** Run `/harness-factory:prerequisites` to check your environment
2. **New account?** Run `/harness-factory:setup` for the guided wizard
3. **Know what you need?** Use a specific skill directly (e.g., `/harness-factory:ci-pipelines`)
4. **Check progress?** Run `/harness-factory:status` anytime

## Prerequisites

- OpenTofu or Terraform installed (`brew install opentofu`)
- Environment variables set:
  ```bash
  export HARNESS_ACCOUNT_ID=your_account_id
  export HARNESS_PLATFORM_API_KEY=your_api_key
  export HARNESS_ENDPOINT=https://app.harness.io/gateway  # optional, defaults to SaaS
  ```

## Module Dependency Order

```
harness-platform-setup (account baseline)
    └→ harness-organization (create org)
        └→ harness-project (create project)
            ├→ ci-module-primer → ci-golden-pipeline
            ├→ sto-sast-primer / ci-sto-hcr-standard
            ├→ ccm-auto-k8s-connectors / ccm-autostop-primer
            ├→ rbac-manager
            ├→ harness-ci-image-factory / delegate-image-factory
            └→ secret managers / ansible templates

central-build-farm-setup (independent, account-level)
ccm-k8s-connectors (independent, account-level)
ccm-cluster-orchestrator-deployment (independent)
```
