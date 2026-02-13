IMAGE_NAME  := harness/factory-agent
VERSION     := $(shell python3 -c "import json; print(json.load(open('.claude-plugin/plugin.json'))['version'])")
TAG         := $(IMAGE_NAME):$(VERSION)

.PHONY: docker-build docker-push docker-run docker-shell

## Build the container image
docker-build:
	docker build -t $(TAG) -t $(IMAGE_NAME):latest .

## Push the container image to the registry
docker-push: docker-build
	docker push $(TAG)
	docker push $(IMAGE_NAME):latest

## Run the agent locally with a prompt (requires ANTHROPIC_API_KEY + Harness env vars)
## Usage: make docker-run PROMPT="Create an org called Platform Engineering"
docker-run:
	@test -n "$(PROMPT)" || (echo "ERROR: PROMPT is required. Usage: make docker-run PROMPT=\"your prompt\"" && exit 1)
	docker run --rm \
		-e PLUGIN_PROMPT="$(PROMPT)" \
		-e PLUGIN_ANTHROPIC_API_KEY="$${ANTHROPIC_API_KEY}" \
		-e PLUGIN_HARNESS_ACCOUNT_ID="$${HARNESS_ACCOUNT_ID}" \
		-e PLUGIN_HARNESS_API_KEY="$${HARNESS_PLATFORM_API_KEY}" \
		-e PLUGIN_HARNESS_ENDPOINT="$${HARNESS_ENDPOINT:-https://app.harness.io/gateway}" \
		-e PLUGIN_MAX_TURNS="$${MAX_TURNS:-30}" \
		$(TAG)

## Open an interactive shell in the container for debugging
docker-shell:
	docker run --rm -it \
		-e ANTHROPIC_API_KEY="$${ANTHROPIC_API_KEY}" \
		-e HARNESS_ACCOUNT_ID="$${HARNESS_ACCOUNT_ID}" \
		-e HARNESS_PLATFORM_API_KEY="$${HARNESS_PLATFORM_API_KEY}" \
		-e HARNESS_ENDPOINT="$${HARNESS_ENDPOINT:-https://app.harness.io/gateway}" \
		--entrypoint /bin/bash \
		$(TAG)
