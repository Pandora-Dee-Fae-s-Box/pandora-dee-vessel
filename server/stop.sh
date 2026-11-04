#!/usr/bin/env bash
# Pandora Dee Vessel server stopper

set -euo pipefail

SERVER_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Stopping Pandora Dee Vessel services..."

for pidfile in "$SERVER_DIR"/*.pid; do
  [ -f "$pidfile" ] || continue
  PID=$(cat "$pidfile" 2>/dev/null || true)
  if [ -n "${PID:-}" ] && kill -0 "$PID" 2>/dev/null; then
    kill "$PID" 2>/dev/null || true
    echo "Stopped process $PID ($(basename "$pidfile"))"
  fi
  rm -f "$pidfile"
done

# Fallback: kill any lingering processes started from this server directory.
# Git Bash does not have pgrep, so we use ps + grep and tolerate the grep itself.
for pattern in "jade serve" "grok-bridge.js"; do
  pids=$(ps -W 2>/dev/null | grep -F "$pattern" | grep -v grep | awk '{print $1}' || true)
  if [ -n "$pids" ]; then
    echo "Stopping lingering $pattern processes: $pids"
    echo "$pids" | xargs kill 2>/dev/null || true
  fi
done

echo "All services stopped."
