---
name: security-scanning
description: "Set up security scanning with STO (Security Test Orchestration). Deploy SAST scanning templates for Gitleaks (secret detection), OSV (dependency vulnerabilities), OWASP Dependency Check, and Semgrep (code patterns). Optionally includes Harness Code Repository integration. Use when someone wants security scanning, STO, SAST, SCA, vulnerability scanning, DevSecOps, or code security."
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
  - Grep
---

# Security Scanning

Set up security scanning using `sto-sast-primer` and optionally `ci-sto-hcr-standard`.

**Module directories:**
- `sto-sast-primer/` — SAST/SCA scanning templates
- `ci-sto-hcr-standard/` — CI + STO with Harness Code Repository

$ARGUMENTS

## What These Create

### sto-sast-primer
- **Pipeline templates** for security scanning (standard + HCR variants)
- **Stage templates** for STO execution
- **Step group templates** for each scanner:
  - Gitleaks — secret detection in code
  - OSV — open-source vulnerability database scanning
  - OWASP Dependency Check — dependency analysis
  - Semgrep — static code analysis patterns
- **STO Config Manager** for global exclusions (optional)
- **Harness Code Repository** for exclusion config storage (optional)

### ci-sto-hcr-standard
- Complete **CI + STO pipeline** with Harness Code Repository
- **Repository** with branch protection rules
- **Webhook triggers** for Push, PR, and Main events
- **Input sets** for pipeline execution

## Resource Requirements

Default resource allocations per scanner (important for K8s capacity planning):

| Scanner | CPU | Memory |
|---------|-----|--------|
| Gitleaks | 0.4 | 600Mi |
| OSV | 1 | 2Gi |
| OWASP | 2 | 6Gi |
| Semgrep | 2 | 4Gi |

## Conversation Flow

1. **Auto-detect org/project** from upstream state.

2. "Where should scanning templates be deployed?" → org/project or account level

3. "Which scanners do you want?" (default: all four)
   - Gitleaks — finds hardcoded secrets
   - OSV — checks dependencies against vulnerability databases
   - OWASP — comprehensive dependency analysis
   - Semgrep — finds code anti-patterns and security issues

4. "Will scans run on Harness Cloud or self-hosted Kubernetes?"
   - Self-hosted → ask for kubernetes_connector
   - Harness Cloud → set to "skipped"

5. "Do you need custom scanner images or resource limits?" (most users: no)

6. "Do you want the STO global exclusions config manager?" (recommended: yes)

7. Generate tfvars for `sto-sast-primer`, deploy.

8. "Do you also want the full CI + STO + Harness Code Repository pipeline?" → `ci-sto-hcr-standard`

## Prerequisites

- None strictly required (can deploy at account level)
- Organization/project recommended for proper scoping
