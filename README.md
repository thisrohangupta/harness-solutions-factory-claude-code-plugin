# Harness Factory — Claude Code Plugin

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) plugin that provisions and manages your Harness Platform using natural language. Describe what you want — organizations, projects, CI/CD pipelines, security scanning, cloud cost management — and the plugin generates and applies the Terraform.

Built and maintained by **Harness Solutions Engineering**.

---

## Prerequisites

### 1. Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

Requires **v1.0.33+**. Check with `claude --version`.

### 2. Install OpenTofu (or Terraform)

```bash
# macOS
brew install opentofu

# Other platforms: https://opentofu.org/docs/intro/install/
```

### 3. Set Harness environment variables

```bash
export HARNESS_ACCOUNT_ID=your_account_id
export HARNESS_PLATFORM_API_KEY=your_api_key

# Optional — defaults to Harness SaaS
export HARNESS_ENDPOINT=https://app.harness.io/gateway
```

Find your Account ID at **Harness > Account Settings**. Generate an API key at **Account Settings > API Keys**.

---

## Quick Start

### 1. Clone the repo

```bash
git clone <repo-url>
cd harness-solutions-factory-claude-code-plugin
```

### 2. Launch Claude Code with the plugin

```bash
claude --plugin-dir .
```

### 3. Check your environment

```
/harness-factory:prerequisites
```

### 4. Start provisioning

```
/harness-factory:setup
```

This launches an interactive wizard that walks you through the full platform setup. Or, if you know what you need, jump straight to a specific capability:

```
Set up a new organization called "Platform Engineering"
```

```
Create CI pipelines for my project
```

```
Enable security scanning with SAST
```

---

## Commands

Slash commands you invoke directly:

| Command | Description |
|---------|-------------|
| `/harness-factory:setup` | Interactive wizard — full platform provisioning |
| `/harness-factory:status` | Show what's deployed across all modules |
| `/harness-factory:destroy` | Tear down provisioned resources (with confirmation) |
| `/harness-factory:help` | Show all available commands and skills |
| `/harness-factory:prerequisites` | Verify environment readiness |

## Skills

Skills are auto-invoked based on what you ask for, or can be called directly:

### Platform Foundation

| Skill | What It Does |
|-------|--------------|
| `platform-setup` | Account-level roles, user groups, OPA governance policies |
| `org-setup` | Create a Harness Organization with RBAC and governance |
| `project-setup` | Create a Project within an organization |
| `rbac` | RBAC management automation pipeline |

### CI/CD & Security

| Skill | What It Does |
|-------|--------------|
| `ci-pipelines` | CI stage/step templates + golden pipelines with triggers |
| `security-scanning` | STO scanners — Gitleaks, OSV, OWASP, Semgrep |

### Infrastructure

| Skill | What It Does |
|-------|--------------|
| `build-farm` | SCM, container registry, artifact manager connectors |
| `image-factories` | CI image mirroring + custom delegate image pipelines |

### Cloud Cost Management

| Skill | What It Does |
|-------|--------------|
| `ccm-finops` | K8s cost visibility, AutoStopping, Cluster Orchestrator |

### Secrets & Templates

| Skill | What It Does |
|-------|--------------|
| `secret-management` | GitHub PAT dispenser + CyberArk Conjur integration |
| `ansible` | Ansible step group templates for CI/CD/IACM stages |

---

## Module Dependency Order

Modules are deployed in dependency order. The plugin handles this automatically, but here's the graph for reference:

```
harness-platform-setup (account baseline)
    └── harness-organization (create org)
        └── harness-project (create project)
            ├── ci-module-primer → ci-golden-pipeline
            ├── sto-sast-primer / ci-sto-hcr-standard
            ├── ccm-auto-k8s-connectors / ccm-autostop-primer
            ├── rbac-manager
            ├── harness-ci-image-factory / delegate-image-factory
            └── secret managers / ansible templates

central-build-farm-setup (independent, account-level)
ccm-k8s-connectors (independent, account-level)
ccm-cluster-orchestrator-deployment (independent)
```

---

## Terraform Modules

This repo includes 18 Terraform modules, each managing a specific Harness capability:

| Module | Category | Level |
|--------|----------|-------|
| `harness-platform-setup` | Platform | Account |
| `harness-organization` | Platform | Account |
| `harness-project` | Platform | Organization |
| `central-build-farm-setup` | Infrastructure | Account |
| `ci-module-primer` | CI | Org/Project |
| `ci-golden-pipeline` | CI | Project |
| `ci-sto-hcr-standard` | CI + Security | Project |
| `sto-sast-primer` | Security | Any |
| `ccm-k8s-connectors` | Cloud Cost | Account |
| `ccm-auto-k8s-connectors` | Cloud Cost | Project |
| `ccm-autostop-primer` | Cloud Cost | Project |
| `ccm-cluster-orchestrator-deployment` | Cloud Cost | Any |
| `rbac-manager` | Platform | Project |
| `harness-ci-image-factory` | Infrastructure | Project |
| `delegate-image-factory` | Infrastructure | Project |
| `secret_manager_github_pat` | Secrets | Any |
| `secret-manager-cyberark-conjur` | Secrets | Any |
| `ansible-step-group-template` | Templates | Any |

---

## Safety

The plugin enforces guardrails to prevent accidental damage:

- **Plan before apply** — every `tofu apply` shows the plan and requires explicit confirmation
- **Dependency awareness** — destroying a module warns about downstream impact
- **State protection** — direct `tofu state rm/mv/push` and `force-unlock` commands are blocked by a pre-execution hook
- **Destroy confirmation** — you must type the module name to confirm destruction

---

## Repo Structure

```
.
├── .claude-plugin/
│   └── plugin.json            # Plugin manifest
├── agents/                    # Agent definitions
├── commands/                  # Slash commands (setup, status, destroy, help)
├── hooks/
│   └── hooks.json             # Pre-execution safety hooks
├── scripts/                   # Helper scripts used by skills
├── skills/                    # 13 auto-invocable skills
├── providers.tf.example       # Harness provider template
├── harness-platform-setup/    # ┐
├── harness-organization/      # │
├── harness-project/           # │ 18 Terraform modules
├── ci-module-primer/          # │
├── ...                        # ┘
└── .gitignore
```

---

## License

See [LICENSE](LICENSE).
