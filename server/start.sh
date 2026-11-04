#!/usr/bin/env bash
# Pandora Dee Vessel server starter
# Starts jade-py daemon, pandora-mcp-server, and the Grok bridge.

set -euo pipefail

SERVER_DIR="$(cd "$(dirname "$0")" && pwd)"
PARENT_DIR="$(dirname "$SERVER_DIR")"
VESSEL_DIR="$PARENT_DIR"

source "$VESSEL_DIR/env.sh" >/dev/null 2>&1 || true

VAULT_DIR="${VAULT_DIR:-$VESSEL_DIR/vault}"
MCP_DIR="${PANDORA_MCP_DIR:-$PARENT_DIR/pandora-mcp-server}"
JADE_PY_DIR="${JADE_PY_DIR:-$PARENT_DIR/jade-py}"
GROK_BRIDGE_PORT="${GROK_PORT:-8780}"

print_step() {
  echo ""
  echo "=== $1"
}

mkdir -p "$SERVER_DIR/logs"

# Stop any running instances
bash "$SERVER_DIR/stop.sh" >/dev/null 2>&1 || true

# Start pandora-mcp-server
if [ -d "$MCP_DIR" ]; then
  print_step "Starting pandora-mcp-server"
  cd "$MCP_DIR" || exit 1
  export FAE_STORAGE_BASE="$VAULT_DIR"
  npx -y supergateway --stdio "node pandora-mcp-server.cjs" --port 8002 --cors "*" --ssePath /mcp --messagePath /messages --outputTransport streamableHttp > "$SERVER_DIR/logs/pandora-mcp-server.log" 2>&1 &
  echo $! > "$SERVER_DIR/pan.pid"
  echo "Pandora MCP server started on http://localhost:8002/mcp"
fi

# Start jade-py daemon
if [ -d "$JADE_PY_DIR" ]; then
  print_step "Starting jade-py daemon"
  cd "$JADE_PY_DIR" || exit 1
  export JADE_VAULT_DIR="$VAULT_DIR"
  export JADE_API_HOST="localhost"
  export JADE_API_PORT=8760
  export JADE_API_TOKEN="${JADE_API_TOKEN:-$(cat /proc/sys/kernel/random/uuid 2>/dev/null || python3 -c "import uuid; print(uuid.uuid4())")}"
  if [ -n "${OLLAMA_URL:-}" ]; then
    export JADE_MODEL="${JADE_MODEL:-ollama}"
    export JADE_PROVIDER="ollama"
    export JADE_OLLAMA_HOST="$OLLAMA_URL"
  fi
  if [ -n "${OLLAMA_CLOUD_KEY:-}" ]; then
    export JADE_OLLAMA_CLOUD_KEY="$OLLAMA_CLOUD_KEY"
  fi
  pip install -e "." > "$SERVER_DIR/logs/jade-py-install.log" 2>&1
  jade serve > "$SERVER_DIR/logs/jade-py.log" 2>&1 &
  echo $! > "$SERVER_DIR/jade-py.pid"
  echo "jade-py daemon started on http://localhost:8760"
  echo "  API token: ${JADE_API_TOKEN}"
fi

# Start Grok bridge
if [ -f "$SERVER_DIR/grok-bridge.js" ] && command -v node >/dev/null 2>&1; then
  print_step "Starting Grok bridge"
  cd "$SERVER_DIR" || exit 1
  export GROK_PORT="$GROK_BRIDGE_PORT"
  export JADE_API_URL="http://localhost:8760/v1/chat"
  export JADE_API_TOKEN="${JADE_API_TOKEN}"
  node grok-bridge.js > "$SERVER_DIR/logs/grok-bridge.log" 2>&1 &
  echo $! > "$SERVER_DIR/grok-bridge.pid"
  echo "Grok bridge started on http://localhost:${GROK_BRIDGE_PORT}/v1/chat"
fi

# Wait for signal
echo ""
echo "Services running. Press Enter to stop."
read -r _
