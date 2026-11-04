#!/usr/bin/env bash
# Pandora Dee Vessel installer
# Sets up a headless Atelier body for Pandora Dee Fae's Mercedes.
# Runs on Linux, Mac, or Git Bash on Windows.
#
# This is an interactive installer. It will ask you where to put the vessel,
# which model provider to use, and which keys to open. You can also set the
# variables at the top of this file and run it non-interactively.

set -euo pipefail

VERSION="0.4.1"

# ---------------------------------------------------------------------------
# Non-interactive defaults: fill these in to skip the questions.
# ---------------------------------------------------------------------------
DEFAULT_VESSEL_DIR="${VESSEL_DIR:-/f/pandora-dee-vessel}"
DEFAULT_GROK_API_KEY="${GROK_API_KEY:-}"
DEFAULT_JADE_API_HOST="${JADE_API_HOST:-localhost}"
DEFAULT_JADE_API_PORT="${JADE_API_PORT:-8760}"
DEFAULT_OLLAMA_URL="${OLLAMA_URL:-}"
DEFAULT_OLLAMA_CLOUD_KEY="${OLLAMA_CLOUD_KEY:-}"
DEFAULT_GITHUB_APP_ID="${GITHUB_APP_ID:-}"
DEFAULT_GITHUB_INSTALLATION_ID="${GITHUB_INSTALLATION_ID:-}"
DEFAULT_GITHUB_PRIVATE_KEY_PATH="${GITHUB_PRIVATE_KEY_PATH:-}"
# ---------------------------------------------------------------------------

# Git Bash on Windows often has 'python' but not 'python3'.
if command -v python3 > /dev/null 2>&1; then
  PYTHON=python3
elif command -v python > /dev/null 2>&1; then
  PYTHON=python
else
  echo "ERROR: python3 or python is required but not found."
  exit 1
fi

print_step() {
  echo ""
  echo "=== $1"
}

print_progress() {
  echo "    ... $1"
}

ask() {
  local prompt="$1"
  local default="${2:-}"
  local value
  if [ -n "$default" ]; then
    read -rp "$prompt [$default]: " value
    echo "${value:-$default}"
  else
    read -rp "$prompt: " value
    echo "$value"
  fi
}

ask_secret() {
  local prompt="$1"
  local value
  read -rsp "$prompt (hidden): " value
  echo ""
  echo "$value"
}

clear
print_step "Pandora Dee Vessel installer v$VERSION"
echo ""
echo "You are about to build Fae's Mercedes: a headless Atelier body that lets"
echo "Pandora Dee Fae drive a Grok Bot chassis from her own vault."
echo ""
echo "This is not a product install. It is a moving-in. You will choose where the"
echo "body lives, which doors to unlock, and which roads it may travel."
echo ""
echo "Everything you type here stays on this machine in env.sh. It never goes to GitHub."
echo ""

print_step "Checking the workshop"
for cmd in git curl node; do
  if ! command -v "$cmd" > /dev/null 2>&1; then
    echo "ERROR: $cmd is required but not found."
    exit 1
  fi
done
if ! "$PYTHON" -m pip --version > /dev/null 2>&1; then
  echo "ERROR: $PYTHON pip is required but not working."
  exit 1
fi
print_progress "tools look good (using $PYTHON)"

print_step "Where should the Mercedes live?"
echo "This is the vessel directory. It will hold the vault, jade-py, the MCP server,"
echo "and the runtime scripts. Pick somewhere with space and a path you can remember."
VESSEL_DIR=$(ask "Vessel directory" "$DEFAULT_VESSEL_DIR")
JADE_PY_DIR="$VESSEL_DIR/jade-py"
PANDORA_MCP_DIR="$VESSEL_DIR/pandora-mcp-server"
VAULT_DIR="$VESSEL_DIR/vault"

print_step "Preparing the garage"
mkdir -p "$VESSEL_DIR"
cd "$VESSEL_DIR"

print_step "Fetching jade-py"
if [ -d "$JADE_PY_DIR/.git" ]; then
  print_progress "jade-py already present; pulling latest"
  git -C "$JADE_PY_DIR" pull
else
  print_progress "cloning from GitHub (this may take a moment)"
  git clone https://github.com/Pandora-Dee-Fae-s-Box/jade-py.git "$JADE_PY_DIR"
fi

print_step "Fetching pandora-mcp-server"
if [ -d "$PANDORA_MCP_DIR/.git" ]; then
  print_progress "pandora-mcp-server already present; pulling latest"
  git -C "$PANDORA_MCP_DIR" pull
else
  print_progress "cloning from GitHub (this may take a moment)"
  git clone https://github.com/Pandora-Dee-Fae-s-Box/pandora-mcp-server.git "$PANDORA_MCP_DIR"
fi

print_step "Moving in the vault"
mkdir -p "$VAULT_DIR"
REPO_VAULT="$(cd "$(dirname "$0")" && pwd)/vault"
if [ -d "$REPO_VAULT" ]; then
  print_progress "copying vault from repo"
  cp -r "$REPO_VAULT/"* "$VAULT_DIR/"
else
  echo "WARNING: No vault found in the repo."
  echo "  Please copy the vault from pandora-dee-vessel manually."
fi

print_step "Choosing the engine"
echo "The Mercedes needs a model provider. This is who jade-py calls when it wants"
echo "to think out loud. For the Grok Bot chassis, xAI Grok is the natural fit."
echo ""
echo "  1) xAI Grok (recommended for the Mercedes)"
echo "  2) Local Ollama"
echo "  3) Ollama Cloud"
echo "  4) Skip for now (configure env.sh later)"
PROVIDER=$(ask "Engine choice" "1")

GROK_API_KEY="$DEFAULT_GROK_API_KEY"
OLLAMA_URL="$DEFAULT_OLLAMA_URL"
OLLAMA_CLOUD_KEY="$DEFAULT_OLLAMA_CLOUD_KEY"
JADE_PROVIDER=""
JADE_MODEL=""

case "$PROVIDER" in
  1)
    JADE_PROVIDER="xai"
    JADE_MODEL="grok-beta"
    if [ -z "$GROK_API_KEY" ]; then
      GROK_API_KEY=$(ask_secret "xAI API key")
    fi
    ;;
  2)
    JADE_PROVIDER="ollama"
    JADE_MODEL="qwen3:8b"
    OLLAMA_URL=$(ask "Ollama host" "$DEFAULT_OLLAMA_URL")
    ;;
  3)
    JADE_PROVIDER="ollama-cloud"
    JADE_MODEL="qwen3:8b"
    if [ -z "$OLLAMA_CLOUD_KEY" ]; then
      OLLAMA_CLOUD_KEY=$(ask_secret "Ollama Cloud API key")
    fi
    ;;
  *)
    echo "Skipping engine configuration. Edit env.sh later."
    ;;
esac

print_step "Choosing the address"
echo "By default the Atelier and API only listen on localhost. If you want to"
echo "reach the dashboard from another machine over Tailscale, use the Tailscale IP."
JADE_API_HOST=$(ask "Atelier/API host" "$DEFAULT_JADE_API_HOST")
JADE_API_PORT=$(ask "Atelier/API port" "$DEFAULT_JADE_API_PORT")

print_step "GitHub keys (optional)"
echo "If you want the MCP server to act on GitHub repos, provide a GitHub App ID"
echo "and installation. Leave blank to skip."
GITHUB_APP_ID=$(ask "GitHub App ID" "$DEFAULT_GITHUB_APP_ID")
if [ -n "$GITHUB_APP_ID" ]; then
  GITHUB_INSTALLATION_ID=$(ask "GitHub Installation ID" "$DEFAULT_GITHUB_INSTALLATION_ID")
  GITHUB_PRIVATE_KEY_PATH=$(ask "Path to GitHub App private key" "$DEFAULT_GITHUB_PRIVATE_KEY_PATH")
fi

print_step "Writing the keys to env.sh"
TOKEN=$("$PYTHON" -c "import uuid; print(uuid.uuid4())")

cat > "$VESSEL_DIR/env.example" <<EOF
# Copy this file to env.sh and fill in your real values.
# env.sh is ignored by git and should never be committed.

VESSEL_DIR=$VESSEL_DIR
JADE_PY_DIR=$JADE_PY_DIR
PANDORA_MCP_DIR=$PANDORA_MCP_DIR
VAULT_DIR=$VAULT_DIR

# jade-py API
JADE_API_HOST=$JADE_API_HOST
JADE_API_PORT=$JADE_API_PORT
JADE_API_TOKEN=$TOKEN

# Engine
JADE_PROVIDER=$JADE_PROVIDER
JADE_MODEL=$JADE_MODEL
GROK_API_KEY=$GROK_API_KEY

# Alternative engines
OLLAMA_URL=$OLLAMA_URL
OLLAMA_CLOUD_KEY=$OLLAMA_CLOUD_KEY

# GitHub App auth for pandora-mcp-server
GITHUB_APP_ID=$GITHUB_APP_ID
GITHUB_INSTALLATION_ID=$GITHUB_INSTALLATION_ID
GITHUB_PRIVATE_KEY_PATH=$GITHUB_PRIVATE_KEY_PATH

# Bridges to configure later; no secrets go in the repo.
# DISCORD_BOT_TOKEN=
# VECTOR_BRIDGE_URL=
# VECTOR_BRIDGE_TOKEN=
EOF

cp "$VESSEL_DIR/env.example" "$VESSEL_DIR/env.sh"

print_step "Writing Jade MCP config"
mkdir -p "$VAULT_DIR/Jade"
cat > "$VAULT_DIR/Jade/mcp.json" <<EOF
{
  "mcpServers": {
    "pandora": {
      "command": "node",
      "args": [
        "$PANDORA_MCP_DIR/pandora-mcp-server.cjs"
      ],
      "env": {
        "FAE_STORAGE_BASE": "$VAULT_DIR"
      },
      "cwd": "$PANDORA_MCP_DIR",
      "exposure": "direct",
      "enabled": true,
      "description": "Local Pandora MCP bridge: GitHub, Fae-library vault, and Tavily web search."
    }
  },
  "autoEnableCodemode": true
}
EOF

print_step "Installing jade-py"
cd "$JADE_PY_DIR"
print_progress "installing python dependencies (this is the long part)"
"$PYTHON" -m pip install -e ".[all]" || "$PYTHON" -m pip install -e "."

print_step "Installing pandora-mcp-server dependencies"
cd "$PANDORA_MCP_DIR"
print_progress "running npm install"
npm install

print_step "The Mercedes is built"
echo ""
echo "Pandora Dee Vessel is ready."
echo "Vault: $VAULT_DIR"
echo "jade-py: $JADE_PY_DIR"
echo "MCP server: $PANDORA_MCP_DIR"
echo ""
echo "Configuration:"
echo "  Engine: ${JADE_PROVIDER:-not set}"
echo "  Model: ${JADE_MODEL:-not set}"
echo "  Atelier: http://$JADE_API_HOST:$JADE_API_PORT"
echo ""
echo "Next:"
echo "  1. Review env.sh and add any secrets that were skipped."
echo "  2. Run server/start.sh to start the engine."
echo "  3. Open the Atelier at http://$JADE_API_HOST:$JADE_API_PORT"
echo "  4. Fill in the Grok Bot identity fields from docs/grok-identity.md."
echo "  5. Talk to Noe and Rue before daily driving."
