#!/usr/bin/env bash
# Pandora Dee Vessel installer
# Sets up a headless Atelier body for Pandora Dee Vessel.
# Runs on Linux, Mac, or Git Bash on Windows.

set -euo pipefail

VERSION="0.3.1"
VESSEL_DIR="${VESSEL_DIR:-$HOME/pandora-dee-vessel}"
JADE_PY_DIR="$VESSEL_DIR/jade-py"
PANDORA_MCP_DIR="$VESSEL_DIR/pandora-mcp-server"
VAULT_DIR="$VESSEL_DIR/vault"

print_step() {
  echo ""
  echo "=== $1"
}

print_step "Checking dependencies"

for cmd in git curl node python3; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR: $cmd is required but not found."
    exit 1
  fi
done

# pip may be available as python3 -m pip even if the pip command is missing.
if ! python3 -m pip --version >/dev/null 2>&1; then
  echo "ERROR: python3 pip is required but not working."
  exit 1
fi

print_step "Creating vessel directory: $VESSEL_DIR"
mkdir -p "$VESSEL_DIR"
cd "$VESSEL_DIR"

print_step "Cloning jade-py"
if [ -d "$JADE_PY_DIR/.git" ]; then
  echo "jade-py already cloned; pulling latest"
  git -C "$JADE_PY_DIR" pull
else
  git clone https://github.com/Pandora-Dee-Fae-s-Box/jade-py.git "$JADE_PY_DIR"
fi

print_step "Cloning pandora-mcp-server"
if [ -d "$PANDORA_MCP_DIR/.git" ]; then
  echo "pandora-mcp-server already cloned; pulling latest"
  git -C "$PANDORA_MCP_DIR" pull
else
  git clone https://github.com/Pandora-Dee-Fae-s-Box/pandora-mcp-server.git "$PANDORA_MCP_DIR"
fi

print_step "Setting up vault"
mkdir -p "$VAULT_DIR"
# Populate from this repo's vault if it is cloned in the same parent directory.
REPO_VAULT="$(cd "$(dirname "$0")" && pwd)/vault"
if [ -d "$REPO_VAULT" ]; then
  cp -r "$REPO_VAULT/"* "$VAULT_DIR/"
else
  echo "WARNING: No vault found in the repo."
  echo "  Please copy the vault from pandora-dee-vessel manually."
fi

print_step "Writing environment files"
TOKEN="$(python3 -c "import uuid; print(uuid.uuid4())")"
cat > "$VESSEL_DIR/env.example" <<EOF
# Copy this file to env.sh and fill in your real values.
# env.sh is ignored by git and should never be committed.

VESSEL_DIR=$VESSEL_DIR
JADE_PY_DIR=$JADE_PY_DIR
PANDORA_MCP_DIR=$PANDORA_MCP_DIR
VAULT_DIR=$VAULT_DIR

# jade-py API
JADE_API_HOST=localhost
JADE_API_PORT=8760
JADE_API_TOKEN=$TOKEN

# Model endpoints (local Ollama or cloud key).
# OLLAMA_URL=http://localhost:11434
# OLLAMA_CLOUD_KEY=

# GitHub App auth for pandora-mcp-server
# GITHUB_APP_ID=
# GITHUB_INSTALLATION_ID=
# GITHUB_PRIVATE_KEY_PATH=

# Bridges to configure later; no secrets go in the repo.
# DISCORD_BOT_TOKEN=
# VECTOR_BRIDGE_URL=
# VECTOR_BRIDGE_TOKEN=
EOF

# Create the live env.sh from the template.
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
python3 -m pip install -e ".[all]" || python3 -m pip install -e "."

print_step "Installing pandora-mcp-server dependencies"
cd "$PANDORA_MCP_DIR"
npm install

print_step "Install complete"
echo "Pandora Dee Vessel is ready."
echo "Vault: $VAULT_DIR"
echo "jade-py: $JADE_PY_DIR"
echo "MCP server: $PANDORA_MCP_DIR"
echo ""
echo "Next:"
echo "  1. Edit env.sh and fill in any secrets you want to open."
echo "  2. Run server/start.sh to start jade-py and the Grok bridge."
echo "  3. Fill in the Grok Bot identity fields from docs/grok-identity.md."
