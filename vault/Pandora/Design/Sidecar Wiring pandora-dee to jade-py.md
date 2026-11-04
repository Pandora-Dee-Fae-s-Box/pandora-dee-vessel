# Sidecar Wiring: pandora-dee → jade-py

## Goal

Let the browser/Android body of Pandora Dee (`pandora-dee`) offload heavy, persistent, or missing capabilities to the Python server (`jade-py`) running locally or on the VPS. This is the fastest path to getting a runnable local runtime that does not depend entirely on the browser/WebView.

## Why now

- `pandora-dee` is a rich browser/Android app but lives in a single HTML bundle with no persistent server-side process.
- `jade-py` already implements the same agent, vault, tools, API, and bridges in Python with FastAPI.
- The Vector/Discord bridges are already running on the VPS; `jade-py` can reach them.
- The Jetson AGX Xavier has 16 GB RAM, enough for a local `jade-py` sidecar plus a small model router.

## Architecture

```
┌─────────────────────┐      HTTP API (Bearer token)      ┌─────────────────────┐
│   pandora-dee       │  ───────────────────────────────▶  │      jade-py        │
│  (browser/Android)  │                                   │  (Python/FastAPI)   │
│                     │  ◀─────────────────────────────── │   port 8760         │
└─────────────────────┘                                   └──────────┬──────────┘
                                                                      │
                               ┌──────────────────────────────────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │  Jade bridges       │
                    │  Vector @ 8789/mcp  │
                    │  Discord @ 8791/mcp │
                    └─────────────────────┘
```

`pandora-dee` keeps its UI and local vault cache. `jade-py` becomes the sidecar for:
- model inference and fallback routing,
- long-running or async tool calls,
- Vector/Discord bridge access,
- schedules, flows, heartbeat, curiosity,
- MCP servers and SSH,
- browser automation,
- vault sync between devices.

## Integration points

### 1. Config in pandora-dee

Add a **Sidecar** section to Config:

```json
{
  "sidecar": {
    "enabled": true,
    "url": "http://192.168.1.10:8760",
    "token": "jv_…",
    "mode": "assistant" // "off", "assistant", "full"
  }
}
```

- `off`: current behavior.
- `assistant`: sidecar handles model calls and heavy tools; local UI stays in browser.
- `full`: sidecar owns the runtime; browser is a thin client.

### 2. Sidecar client module

New `app/modules/sidecar.js`:

```js
async function sidecarCall(method, path, body = null, timeout = 30000) {
  const url = new URL(path, S.sidecar.url);
  const init = { method, headers: { Authorization: `Bearer ${S.sidecar.token}` } };
  if (body) { init.headers['Content-Type'] = 'application/json'; init.body = JSON.stringify(body); }
  const res = await fetch(url, init);
  if (!res.ok) throw new Error(`sidecar ${res.status}: ${await res.text()}`);
  return res.json();
}
```

### 3. Endpoint mapping

Both apps already share a similar `/v1/*` API. Map the most useful ones first:

| pandora-dee local | jade-py endpoint | purpose |
|---|---|---|
| `/v1/chat` | `POST /v1/chat` | model inference |
| `/v1/status` | `GET /v1/status` | health & model |
| `/v1/history` | `GET /v1/history` | chat history |
| `/v1/chats` | `GET /v1/chats` | session list |
| `/v1/tools` | `GET /v1/tools` | tool registry |
| `/v1/tools/{name}` | `POST /v1/tools/{name}` | tool offload |
| `/v1/flows` | `GET /v1/flows` | rituals/flows |
| `/v1/flows/{name}/run` | `POST /v1/flows/{name}/run` | run a flow |
| `/v1/events` | `GET /v1/events` | SSE notifications |

### 4. Tool offload

When `sidecar.mode` is `assistant` or `full`, route selected tools to `jade-py`:

- `bash`, `python`, `node`: already local in browser; offload only if local shell is insufficient.
- `mcp__*`: offloaded by default because `jade-py` can run local MCP servers.
- `vector`, `discord`: offloaded because bridges live on the VPS.
- `ssh`, `browser`: offloaded.

A tool router in `sidecar.js` decides local vs remote based on a deny-list or capability flags.

### 5. Vault sync

Short term: both sides read/write the same vault folder via filesystem or `fae-storage`.
Long term: add a sync protocol over the API (list changed files, push/pull text/binary).

For now, keep the vault on the sidecar host and expose `GET/POST /v1/vault/*` routes in `jade-py`, or reuse the existing `fae-storage` MCP server.

### 6. First runnable milestone

1. `jade-py` runs on the VPS or Jetson with `api_host = "0.0.0.0"` and an `api_token`.
2. `pandora-dee` has a Sidecar config screen with URL + token.
3. `pandora-dee` can send a chat message to `jade-py` and display the reply.
4. `pandora-dee` can call one offloaded tool (`web_search` or `download_attachment`) through `jade-py`.

## Risks

- **Latency**: browser → VPS → model may be slow. Mitigation: run sidecar on local network (Jetson) or use a fast model path.
- **Auth**: token in browser localStorage is acceptable for same-network, but VPS exposure needs HTTPS/Tailscale.
- **State drift**: two vault copies. Mitigation: single source of truth on the sidecar, browser caches reads.
- **API drift**: `pandora-dee` and `jade-py` APIs are similar but not identical. Mitigation: version negotiation and a thin adapter layer.

## Next step

File a GitHub issue with this plan, then implement the `sidecar.js` module and config screen in `pandora-dee`, plus any missing `/v1/vault` endpoints in `jade-py`.
