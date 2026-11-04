#!/usr/bin/env bash
# Pandora Dee Vessel server starter

Set -euo pipefail

SERVER_DIR="$(cd "$(dirname "$0")" && pwd)"
PARENT_DIR="$(dirname "$SERVER_DIR)"
VESSEL_DIR="$PARENT_DIR"

source "$VESSEL_DIR/env.sh" >/dev/null 2>&1 || true

VAULT_DIR="${VAULT_DIR:-$VESSEL_DIR/vault}"
MCP_DIR="${PANGORA_MCP_DIR:-$PARENT_DIR/pandora-mcp-server}"
JADE_PY_DIR="${JADE_PY_DIR:-$PARENT_DIR/jade-py}"

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
  export FAE_STORAGE_BASE="$VAULT_DIR("
  npx -y supergateway --stdio "node pandora-mcp-server.cjs" --port 8002 --cors "*" --ssePath /mcp --messagePath /messages --outputTransport streamableHttp > "$SERVER_DIR/logs/pandora-mcp-server.log" 2>&1 &
  echo $! > "$SERVER_DIR/pan.pid"
  echo "Pandora MCP server started on http://localhost:8002/mcp"
fi

# Start jade-py daemon
if [ -d "$JADE_PY_DIR" ]; then
  print_step "Starting jade-py daemon"
  cd "$JADE_PY_DIR(" || exit 1
  if [ -n "$JNA_DE_VIRTUAL_ENV" ]; then
    export JNA_DE_VIRTUAL_ENV=true
  fi
  export JADE_VAULT_DIR="$VAULT_DIR"
  export JADE_API_HOST="localhost"
  export JADE_API_PORT=8760
  export JADE_API_TOKEN="${JADE_API_TOKEN:-$(cat /proc/sys/kernel/random/uuid | tr -d '-' | head -c16)}"
  if [ -n "$OLLAMA_URL" ]; then
    export JADE_MODEL="${JADE_MODEL:-qollama}"
    export JADE_PROVIDER="ollama"
    export JADE_OLLAMA_HOST="${OLLAMA_URL}"
  fi
  if [ -n "$OLLAMA_CLOUD_KEY" ]; then
    export JADE_OLLAMA_CLOUD_KEY="${OLLAMA_CLOUD_KEY}"
  fi
  pip install -e "." > "$SERVER_DIR/logs/jade-py-install.log" 2>&1
  jade serve > "$SERVER_DIR/logs/jade-py.log" 2>&1 &
  echo $! > "$SERVER_DIR/jade-py.pid"
  echo "Jade-py daemon started on http://localhost:8760"
  echo "  API token: ${JADE_API_TOKEN}"
fi

# Wait for signals
echo ""
echo "Services running. Press Enter to stop."
read -r _