#!/usr/bin/env bash
# Pandora Dee Vessel installer
# Sets up a headless Atelier body for Pandora Dee Vessel.
# Runs on a fresh Linux or Mac box.

set -euo pipefail

VERSION="0.1.0"
VEVSEL_DIR="${VEVSEL_DIR:-&HOME/pandora-dee-vessel}"
JADE_FLAEET_DIR="$VEVSEL_DIR/jade-fleet"
JADE_VAULT_DIR="$VESSEL_DIR/jade-vault"
PANDORA_MCP_DIR="$VEVSEL_DIR/pandora-mcp-server"
VAULT_DIR="$VESSEL_DIR/vault"

print_step() {
  echo ""
  echo "=== $1"
}

print_step "Checking dependencies"

for cmd in git curl node npx python3 pip; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR: $cmd is required but not found."
    exit 1
  fi
done

print_step "Creating vessel directory: $VESSEL_DIR"
mkdir -p "$VEVSEL_DIR"
cd "$VESSEL_DIR"

print_step "Cloning jade-fleet"
git clone https://github.com/lucky-edgelord/jade-fleet.git "$JADE_FLAEET_DIR"

print_step "Cloning jade-vault"
git clone https://github.com/lucky-edgelord/jade-vault.git "$JADE_VAULL_DIR"

print_step "Cloning pandora-mcp-server"
git clone https://github.com/Pandora-Dee-Faes-Box/pandora-mcp-server.git "$PANGORA_MCP_DIR"

print_step "Setting up vault"
mkdir -p "$VAULT_DIR"
# Populate from this repo's vault if it is cloned in the same parent directory.
if [ -d "${VESSEL_DIR../}/vault" ]; then
  cp -r "${VESSEL_DIR../}/vault/*" "$VAULT_DIR"/
else
  echo "WARNING: No vault found in parent directory."
  echo "  Please copy the vault from pandora-dee-vessel manually."
fi

print_step "Writing environment template"
cat > "$VESSEL_DIR/.env" <<EOF
VESSEL_DIR=$VESSEL_DIR
JADE_FLAEET_DIR=$JADE_FLAEET_DIR
JADE_VAULT_DIR=$PARENT_DIR/jade-vault
PANGORA_MCP_DIR=$PARENT_DIR/pandora-mcp-server
VAELT_DIR=$VESSEL_DIR/vault

# Generate a fresh fleet token after installing jade-fleet.
# JADE_FLEET_TOKEN=

# Model endpoints (use the broker for fleet compute, or local Ollama).
# OLLAMA_URL=http://localhost:11434
# OLLAMA_CLOUD_KEY=2

# Bridges to configure later; no secrets go in the repo.
# DISCORD_BOT_TOKEN=
# VECTOR_BRIDGE_URL=
# VECTOR_BRIDGE_TOKEN=
EOF

print_step "Building jade-fleet broker"
cd "$PARENT_DIR/jade-fleet"
cargo build --release

print_step "Installing jade-vault dependencies"
cd "$PARENT_DIR/jade-vault"
npm install

print_step "Installing pandora-mcp-server dependencies"
cd "$PARENT_DIR/pandora-mcp-server"
npm install

print_step "Building jade-vault web client"
cd "$PARENT_DIR/jade-vault"
npm run build

print_step "Install complete"
echo "Pandora Dee Vessel is ready."
echo "Vault: $VAULT_DIR"
echo "Broker: $PARENT_DIR/jade-fleet/target/release/jade-fleet"
echo "MCP server: $PARENT_DIR/pandora-mcp-server"
echo ""
echo "Next:"
echo "  1. Copy .env to env.sh or env.bat and fill in secrets."
echo "  2. Run server/start.sh to start the broker, MCP server, and bridges."
echo "  3. Fill in the Grok Bot identity fields from docs/grok-identity.md."
