# Pandora Dee + Jade-Py Sidecar Integration

**Status:** Design draft — not yet implemented  
**Goal:** Let the browser/Android `pandora-dee` body route chat, tools, and model inference to a local `jade-py` daemon, so Pandora Dee can run on Partner hardware instead of remote APIs.

## Why a sidecar first

The browser body (`pandora-dee`) already has UI, vault, bridges, and an in-browser agent loop. Rewriting that into Python is a huge bite. A sidecar lets us:

1. Keep the browser body as the dashboard and vault holder.
2. Offload model inference, tool execution, curiosity, flows, and phone linkage to `jade-py`.
3. Share one vault layout between the browser and Python (both use `/Jade/...`, `[[links]]`, `#tags`).
4. Add Soul Weaver protocol transport later over the same local HTTP channel.

## Architecture

```text
┌─────────────────────┐         HTTP /v1          ┌─────��───────────────┐
│  pandora-dee.html   │  ◄──────────────────────►  │  jade-py daemon     │
│  (browser/Android)  │   chat, tools, status     │  (Python, local)    │
│                     │                           │                     │
│  - UI / Atelier     │                           │  - model providers  │
│  - vault storage    │                           │  - tools / skills   │
│  - Discord/Vector    │                           │  - curiosity        │
│  - Live2D avatar    │                           │  - flows / schedules  │
│  - MCP clients      │                           │  - Jade Link phones │
└─────────────────────┘                           └─────────────────────┘
```

## Seams to touch in `pandora-dee`

### 1. Settings

Add a new provider option: `jade-py`.

```javascript
const PROVIDERS = {
  // existing...
  jadepy: { label: 'Jade-Py Sidecar', chip: 'JADE-PY' },
};
```

Add config keys:

- `jadePyHost` (default `http://localhost:8760`)
- `jadePyToken` (auto-generated if listening beyond loopback)
- `jadePyShareVault` (boolean, default true)

### 2. Provider client

Create `JadePyClient` in `app/modules/providers.js`:

```javascript
class JadePyClient {
  constructor({ host, token }) {
    this.host = host.replace(/\/+$/, '');
    this.token = token;
    this.ctrls = new Set();
  }

  headers() {
    const h = { 'Content-Type': 'application/json' };
    if (this.token) h.Authorization = 'Bearer ' + this.token;
    return h;
  }

  async list() {
    const r = await fetch(this.host + '/v1/status', { headers: this.headers() });
    if (!r.ok) throw new Error('Jade-Py status ' + r.status);
    // Jade-Py status does not list models; we ask the user to set model in jade-py config,
    // or add a /v1/models endpoint later.
    return { models: [{ name: 'jade-py-sidecar' }] };
  }

  abort() { for (const c of this.ctrls) c.abort(); this.ctrls.clear(); }

  async chat(req) {
    const ctrl = new AbortController();
    this.ctrls.add(ctrl);
    const r = await fetch(this.host + '/v1/chat', {
      method: 'POST',
      headers: this.headers(),
      body: JSON.stringify({ message: lastUserMessage(req.messages), stream: true }),
      signal: ctrl.signal,
    });
    if (!r.ok) throw new Error('Jade-Py chat ' + r.status);
    const reader = r.body.getReader();
    const self = this;
    return {
      abort: () => ctrl.abort(),
      async *[Symbol.asyncIterator]() {
        let buf = '';
        try {
          for (;;) {
            const { value, done } = await reader.read();
            if (done) break;
            buf += dec.decode(value, { stream: true });
            let i;
            while ((i = buf.indexOf('\n')) >= 0) {
              const line = buf.slice(0, i).trim();
              buf = buf.slice(i + 1);
              if (!line.startsWith('data:')) continue;
              const data = line.slice(5).trim();
              if (data === '[DONE]') continue;
              const ev = JSON.parse(data);
              if (ev.event === 'text') yield { message: { role: 'assistant', content: ev.text } };
              if (ev.event === 'tool_start') yield { message: { role: 'assistant', content: '', tool_calls: [{ function: { name: ev.name, arguments: JSON.stringify(ev.arguments) } }] } };
              if (ev.event === 'done') yield { message: { role: 'assistant', content: '' }, done: true, eval_count: ev.eval_count || 0 };
            }
          }
        } finally { self.ctrls.delete(ctrl); }
      }
    };
  }

  async once(req) {
    const r = await fetch(this.host + '/v1/chat', {
      method: 'POST',
      headers: this.headers(),
      body: JSON.stringify({ message: lastUserMessage(req.messages), stream: false }),
    });
    if (!r.ok) throw new Error('Jade-Py once ' + r.status);
    const j = await r.json();
    return { message: { role: 'assistant', content: j.reply || '' } };
  }
}
```

### 3. Tool passthrough

When `jade-py` is the active provider, tool calls come back from `jade-py` already executed. The browser body should:

- Not double-execute them.
- Display them in the chat as it does now.
- Forward any tool results it generates locally (e.g., vault writes) back to `jade-py` if needed.

For local-only tools (MCP clients that only exist in the browser), the browser can intercept those tool calls before sending the message, or `jade-py` can be told not to register them.

### 4. Vault sharing

If `jadePyShareVault` is true, the browser writes vault changes to disk and `jade-py` reads the same path. On Android this needs the native file API to expose the vault directory. On desktop (browser), both must point at the same folder via a local file server or native file system access.

Short-term option: keep vaults separate but sync `MEMORY` messages via Soul Weaver once transport exists.

## Seams to touch in `jade-py`

Mostly already present:

- `/v1/chat` with `stream=true` returns SSE events.
- `/v1/status` for health.
- `/v1/tools` lists tools.
- `/v1/events` streams notifications/approvals.

Add if missing:

- `/v1/models` to advertise available models.
- A way to disable tools that the browser wants to own (e.g., browser-only MCP clients).

## First release scope

1. Add `jade-py` provider option to `pandora-dee` settings.
2. Implement `JadePyClient` with streaming chat.
3. Route non-streaming compaction/journal calls to `/v1/chat?stream=false`.
4. Document how to run `jade serve` locally and point the browser at it.
5. Test with a local Ollama backend.

## Later

- Bidirectional tool registration (browser exposes MCP tools to `jade-py`).
- Shared vault sync via native file access or Soul Weaver `MEMORY` messages.
- Soul Weaver transport over the same HTTP channel.

## Related

- [[Soul Weaver]]
- [[DEE/BOX]]
- `https://github.com/Pandora-Dee-Fae-s-Box/pandora-dee`
- `https://github.com/Pandora-Dee-Fae-s-Box/jade-py`
