---
name: secret-management
description: "Set up secret management templates. Includes GitHub PAT secret manager for dynamic token generation via GitHub Apps, and CyberArk Conjur integration for vault secrets. Use when someone wants to configure secrets, GitHub PAT dispenser, CyberArk, Conjur, or secret management."
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
  - Grep
---

# Secret Management

Set up secret management templates.

**Module directories:**
- `secret_manager_github_pat/` — GitHub PAT dispenser via GitHub Apps
- `secret-manager-cyberark-conjur/` — CyberArk Conjur integration

$ARGUMENTS

## Module Options

### GitHub PAT Secret Manager (secret_manager_github_pat)
Creates a step template that generates temporary GitHub Personal Access Tokens via GitHub Apps. Enables commit/push operations in CI pipelines without long-lived tokens.
- **Inputs:** organization_id (optional), project_id (optional), github_api_url, template_version
- **Level:** Account, org, or project

### CyberArk Conjur (secret-manager-cyberark-conjur)
Creates a step template for retrieving secrets from CyberArk Conjur vault.
- **Inputs:** organization_id (optional), project_id (optional), template_name, template_version
- **Level:** Account, org, or project

## Conversation Flow

1. "Which secret manager do you need?"
   - GitHub PAT dispenser — for CI pipelines that need to push code
   - CyberArk Conjur — for enterprise vault integration
   - Both

2. "Where should the template be deployed?" (account / org / project level)

3. For GitHub PAT: "What's your GitHub API URL?" (default: api.github.com)

4. For CyberArk Conjur: "What should the template be named?" (default: "CyberArk Conjur")

5. Generate tfvars, init, plan, confirm, apply for each selected module.

## Prerequisites

- None strictly required (can deploy at any level)
