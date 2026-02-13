FROM node:20-bookworm-slim

# Prevent interactive prompts during package install
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    bash \
    curl \
    python3 \
    jq \
    ca-certificates \
    gnupg \
  && rm -rf /var/lib/apt/lists/*

# Install OpenTofu
RUN curl -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh \
  && chmod +x install-opentofu.sh \
  && ./install-opentofu.sh --install-method deb \
  && rm install-opentofu.sh \
  && tofu --version

# Install Claude Code CLI
ENV DISABLE_AUTOUPDATER=1
RUN npm install -g @anthropic-ai/claude-code \
  && claude --version

# Copy plugin into the container
WORKDIR /plugin
COPY . /plugin/

# Make entrypoint executable
RUN chmod +x /plugin/scripts/entrypoint.sh

ENTRYPOINT ["/plugin/scripts/entrypoint.sh"]
