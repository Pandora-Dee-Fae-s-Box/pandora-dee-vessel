#!/usr/bin/env bash
# Pandora Dee Vessel server stopper

SERVER_DIR="$(cd "$(dirname "$0")" && pwd)"
PARENT_DIR="$(dirname "$SERVER_DIR")"

echo "Stopping Pandora Dee Vessel services..."

# Stop pandora-mcp-server
if [ -f "$SERVER_DIR/pan.pid" ]; then
  PID=$(cat "$SERVER_DIR/pan.pid") 2>/dev/null
  if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
    echo "Stopped pandora-mcp-server (PID $PID)"
  fi
  rm -f "$SERVER_DIR/pan.pid"
fi

# Stop jade-py daemon
if [ -f "$SERVER_DIR/jade-py.pid" ]; then
  PID=$(cat "$SERVER_DIR/jade-py.pid") 2>/dev/null
  if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
    echo "Stopped jade-py daemon (PID $PID)"
  fi
  rm -f "$SERVER_DIR/jade-py.pid"
fi

# Stop jade-fleet broker
#if [ -f "$SERVER_DIR/jade-fleet.pid" ]; then
#   PID=$(cat "$SERVER_DIR/jade-fleet.pid") 2>/dev/null
#   if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
#     echo "Stopped jade-fleet broker (PID $PID)"
#   fi
#   rm -f "$SERVER_DIR/jade-fleet.pid"
# fi

echo "All services stopped."