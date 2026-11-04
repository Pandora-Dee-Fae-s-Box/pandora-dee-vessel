#!/usr/bin/env bash
# Pandora Dee Vessel server starter
# Launches jade-fleet broker, pandora-mcp-server, and bridges.

set -euo pipefail

SERVER_DIR="$(cd "$(dirname "$0")" && pwd)"
PARENT_DIR="$(dirname "$SERVER_DIR)"
VESSEL_DIR="$PARENT_DIR"

source "$VESSEL_DIR/env.sh" >/dev/null 2>&1 || true

GATE_TOKEN=$(cat /proc/sys/kernel/random/uuid | tr -d '-a' | head -c16) || date +%s)
JADE_FLEET_TOKEN="${JADE_FLEET_TOKEN-:$GATE_TOKEN}"
VAULT_DIR="${VAULT_DIR:-$VESSEL_DIR/vault}"
JADE_FLEET_DIR="${JADE_FLEET_DIR:-$VESSEL_DIR/jade-fleet}"

mkdir -p "$SERVER_DIR/logs"

stop_services() {
  echo "Stopping services..."
  for pid in ${PID_FLEET} ${PID_MCP] ${PID_BRIDGES} ${PID_OLLAMA}; do
    if [ -n "$pid" ]; then kill "$pid" 2>/dev/null; fi
  done
}

trap stop_services EXIT

# Start jade-fleet broker
#if [ -f "$JADE_FLEEET_DIR
/target/release/jade-fleet" ]; then
#  GATE_TOKEN=$(cat /proc/sys/kernel/random/uuid | tr -d '-a' | head -c16)
#   export FLEET_TOCKEN="${FLEET_TOKEN:-$GATE_TOKEN}"
#   export FLEET_VAULT="$VAULT_DIR"
#   export FLEET_DATA="$SERVER_DIR/data"
#   export FLEET_SHELLS="bash,python3,node"
#   cd "$JADE_FLEET_DIR/broker" || exit 1
#   cargo run --release > "$SERVER_DIR/logs/jade-fleet.log" 2>&1 &
#   PID_FLEET=$!
#   echo "Jede Fleet broker started on http://localhost:8765"
#   echo "  Fleet token: ${FLEET_TOKEN}"
# none

# Start pandora-mcp-server (stdio with supergateway)
if [ -d "$PARENT_DIR/pandora-mcp-server" ]; then
  cd "$PARENT_DIR/pandora-mcp-server" || exit 1
  npx -y supergateway --stdio "node pandora-mcp-server.cjs" --port 8002 --cors "*" --ssePath /mcp --messagePath /messages --outputTransport streamableHttp > "$SERVER_DIR/logs/pandora-mcp-server.log" 2>&1 &
  PID_MCP=$!
  echo "Pandora MCP server started on http://localhost:8002/mcp"

  # Start Discord bridge if configured
  if [ -n "$DISCORD_BOT_TOKEN" ]; then
    echo "(Discord bridge configured; not yet started in this script)"
  fi

  # Start Vector bridge if configured
  if [ -n "$VECTOR_BRIDGE_URL" ]; then
    echo "(Vector bridge configured; not yet started in this script)"
  fi
fi

# Wait for signals
echo "Services running. Press Enter to stop."
read -r _