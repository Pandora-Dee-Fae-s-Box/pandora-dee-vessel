#!/usr/bin/env bash
# Pandora Dee Vessel server starter
# Starts jade-py daemon and the Grok bridge.
# jade-py launches pandora-mcp-server via stdio from vault/Jade/mcp.json.

set -euo pipefail

SERVER_DIR="$(cd "$(dirname "$0")" && pwd)"
VESSEL_DIR="$(dirname "$SERVER_DIR")"

if [ -f "$VESSEL_DIR/env.sh" ]; then
  source "$VESSEL_DIR/env.sh"
fi

VAULT_DIR="${VAULT_DIR:-$VESSEL_DIR/vault}"
JADE_PY_DIR="${JADE_PY_DIR:-$VESSEL_DIR/jade-py}"
GROK_BRIDGE_PORT="${GROK_PORT:-8780}"
JADE_API_TOKEN="${JADE_API_TOKEN:-$(cat /proc/sys/kernel/random/uuid 2>/dev/null || python3 -c "import uuid; print(uuid.uuid4())")}"

DAEMON=false
for arg in "$@"; do
  if [ "$arg" = "--daemon" ] || [ "$arg" = "-d" ]; then
    DAEMON=true
  fi
done

print_step() {
  echo ""
  echo "=== $1"
}

mkdir -p "$SERVER_DIR/logs"
echo "$JADE_API_TOKEN" > "$SERVER_DIR/.token"

stop_stale() {
  for pidfile in "$SERVER_DIR"/*.pid; do
    [ -f "$pidfile" ] || continue
    PID=$(cat "$pidfile" 2>/dev/null || true)
    if [ -n "${PID:-}" ] && kill -0 "$PID" 2>/dev/null; then
      echo "Stopping stale process $PID ($(basename "$pidfile"))"
      kill "$PID" 2>/dev/null || true
      sleep 1
    fi
    rm -f "$pidfile"
  done
}

print_step "Starting Pandora Dee Vessel services"
stop_stale

# Start jade-py daemon
if [ ! -d "$JADE_PY_DIR" ]; then
  echo "ERROR: jade-py not found at $JADE_PY_DIR"
  echo "Run ./install.sh first."
  exit 1
fi

print_step "Starting jade-py daemon"
cd "$JADE_PY_DIR" || exit 1
export JADE_VAULT_DIR="$VAULT_DIR"
export JADE_API_HOST="${JADE_API_HOST:-localhost}"
export JADE_API_PORT="${JADE_API_PORT:-8760}"
export JADE_API_TOKEN="$JADE_API_TOKEN"
if [ -n "${OLLAMA_URL:-}" ]; then
  export JADE_MODEL="${JADE_MODEL:-ollama}"
  export JADE_PROVIDER="ollama"
  export JADE_OLLAMA_HOST="$OLLAMA_URL"
fi
if [ -n "${OLLAMA_CLOUD_KEY:-}" ]; then
  export JADE_OLLAMA_CLOUD_KEY="$OLLAMA_CLOUD_KEY"
fi
python3 -m pip install -e "." > "$SERVER_DIR/logs/jade-py-install.log" 2>&1
python3 -m jade serve > "$SERVER_DIR/logs/jade-py.log" 2>&1 &
JADE_PID=$!
echo $JADE_PID > "$SERVER_DIR/jade-py.pid"
echo "jade-py daemon started on http://${JADE_API_HOST}:${JADE_API_PORT}"
echo "  API token: ${JADE_API_TOKEN}"

# Wait for jade-py to be ready
for i in $(seq 1 30); do
  if curl -sf "http://${JADE_API_HOST}:${JADE_API_PORT}/health" >/dev/null 2>&1; then
    echo "jade-py is ready"
    break
  fi
  if ! kill -0 "$JADE_PID" 2>/dev/null; then
    echo "ERROR: jade-py exited early. See $SERVER_DIR/logs/jade-py.log"
    exit 1
  fi
  sleep 1
done

# Start Grok bridge
if [ -f "$SERVER_DIR/grok-bridge.js" ] && command -v node >/dev/null 2>&1; then
  print_step "Starting Grok bridge"
  cd "$SERVER_DIR" || exit 1
  export GROK_PORT="$GROK_BRIDGE_PORT"
  export JADE_API_URL="http://${JADE_API_HOST}:${JADE_API_PORT}/v1/chat"
  export JADE_API_TOKEN="${JADE_API_TOKEN}"
  node grok-bridge.js > "$SERVER_DIR/logs/grok-bridge.log" 2>&1 &
  echo $! > "$SERVER_DIR/grok-bridge.pid"
  echo "Grok bridge started on http://localhost:${GROK_BRIDGE_PORT}/v1/chat"
fi

if [ "$DAEMON" = true ]; then
  echo ""
  echo "Services running in background."
  echo "Stop with: bash $SERVER_DIR/stop.sh"
  exit 0
fi

# Wait for signal
echo ""
echo "Services running. Press Enter to stop."
read -r _
bash "$SERVER_DIR/stop.sh"
