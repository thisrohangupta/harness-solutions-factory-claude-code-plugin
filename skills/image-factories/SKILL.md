---
name: image-factories
description: "Set up image factory pipelines. CI Image Factory migrates Harness CI step images to your private container registry. Delegate Image Factory builds custom delegate images with additional tools. Use when someone wants image migration, image factory, custom delegates, private registry mirroring, or container image management."
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
  - Grep
---

# Image Factories

Set up image factory pipelines for managing container images.

**Module directories:**
- `harness-ci-image-factory/` — migrate Harness CI images to your registry
- `delegate-image-factory/` — build custom delegate images

$ARGUMENTS

## Module Options

### CI Image Factory (harness-ci-image-factory)
Creates a pipeline that mirrors Harness CI step images to your private container registry. Useful for air-gapped environments or registry compliance requirements.
- Supports modules: CI, IDP, IACM
- Configurable concurrency for parallel migration
- Optional scheduled trigger (daily by default)
- **Key inputs:** target registry, registry credentials, modules to mirror, schedule

### Delegate Image Factory (delegate-image-factory)
Creates a pipeline and Harness Code Repository for building custom delegate images with additional tooling.
- Optional STO container image scanning
- Optional SBOM generation
- **Key inputs:** registry connector, K8s connector, API key secret, scan/SBOM preferences

## Conversation Flow

1. "Which image factory do you need?"
   - CI Image Factory — mirror Harness images to your registry
   - Delegate Image Factory — build custom delegate images
   - Both

2. **For CI Image Factory:**
   - "Where should migrated images be stored?" → `customer_image_target_repository`
   - "Which Harness modules need image mirroring?" → CI, IDP, IACM (default: CI only)
   - "Should the migration run on a schedule?" → cron expression (default: daily at 2am)
   - "How many images should migrate in parallel?" → `max_concurrency` (default: 5)

3. **For Delegate Image Factory:**
   - "What container registry will store delegate images?" → registry connector details
   - "Should we scan the delegate image for vulnerabilities?" → `include_image_test_scan`
   - "Generate an SBOM for the image?" → `include_image_sbom`

4. Deploy in order. Show pipeline URLs for triggering.

## Prerequisites

- Organization and project must exist
- Container registry credentials must be configured in Harness
- For Delegate Image Factory: Kubernetes connector and Harness API key secret required
