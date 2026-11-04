#!/usr/bin/env bash
# Pandora Dee Vessel server stopper

SERVER_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Stopping Pandora Dee Vessel services..."

for pidfile in "$SERVER_DIR"/*.pid; do
  [ -f "$pidfile" ] || continue
  PID=$(cat "$pidfile" 2>/dev/null)
  if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
    kill "$PID" 2>/dev/null
    echo "Stopped process $PID ($(basename "$pidfile"))"
  fi
  rm -f "$pidfile"
done

echo "All services stopped."
