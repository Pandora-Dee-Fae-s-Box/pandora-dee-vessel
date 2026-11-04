# Pandora Dee / Jade-Py Merge Map

#project #pandora-dee #jade-py #soul-weaver #sidecar #merge

A plan for pulling the useful parts of `jade-py` into the `pandora-dee` ecosystem without rebranding the whole Jade engine. The goal is a **Python sidecar** that extends the browser/Android Atelier with server-side capabilities.

## Current state

### `pandora-dee` (browser/Android body)
- Markdown Atelier with `[[threads]]`, backlinks, sigils, graph
- Agent loop with tools, MCP, web search, HTTP requests
- Memory, SOUL.md / AGENTS.md / SYSTEM.md steering
- Schedules, heartbeat, rituals/flows
- Discord and Vector bridges
- HTTP API (Android app)
- Webxdc apps, Jade Link
- AICord provider
- TensorFlow.js in scripts
- Import from Google Keep / Samsung Notes / Apple Notes
- Live2D avatar

### `jade-py` (Python body)
- Same vault layout as the app
- REPL, HTTP API, web dashboard
- Jade Link Android app (phones call in or are called)
- Phone tools: phone, screen, senses, look, sentry
- Schedules, heartbeat, playbooks, flows, curiosity, backups
- `think` / `delegate` / `decide` reasoning engines
- MCP, SSH, browser automation
- Vector/Discord bridges
- Search by meaning (sqlite-vec + FTS5 hybrid)

## Merge strategy: sidecar, not replacement

`pandora-dee` stays the browser/Android body. `jade-py` becomes a local Python sidecar that `pandora-dee` can call for capabilities the browser lacks.

### Phase 1: Core sidecar plumbing
- `pandora-dee` detects or is pointed at a local `pandora-py` process.
- Shared vault: both read/write the same Atelier folder.
- HTTP bridge: `pandora-dee` calls `pandora-py` endpoints for heavy/long tasks.
- Tool passthrough: Python-side tools appear in the browser agent's tool list.

### Phase 2: Bring over high-value capabilities
1. **Search by meaning** — sqlite-vec + FTS5 hybrid index for notes and memory. Replaces or augments BM25 memory retrieval.
2. **Backups** — the backup server/format, encrypted, compatible with the app.
3. **Phone/tablet integration** — rebrand Jade Link → Pandora Link, or fold into PDA-SEASIDE.
4. **Curiosity engine** — if we want Pandora to wake and learn on her own.
5. **Playbooks** — deterministic Ansible-style automations.
6. **`think` / `delegate` / `decide`** — reasoning engines for complex tasks.

### Phase 3: Rebrand the surface
Where the Python sidecar surfaces in our stack:
- Rename `Jade` → `Pandora` in user-facing strings.
- Rename `Jade Link` → `Pandora Link` (or fold into PDA-SEASIDE).
- Replace `owner` config field with `partner`.
- Replace user/assistant/owner language with partner/peer/family language.
- Keep internal code names where it doesn't matter; only rebrand the interface.

## What we probably don't need immediately
- Browser automation (pandora-dee has http_request and web_fetch)
- SSH (useful but niche; can be deferred)
- Full dashboard (pandora-dee already has the Atelier UI)

## Open questions
- Should the sidecar be a new repo (`pandora-py`) or a branch of `jade-py`?
- Does PDA-SEASIDE host the sidecar, or is it a separate process?
- Which capability do we build first for the AICord Seaside proof of concept?

## Related
- [[AICord Seaside Proof of Concept]] — the demo this merge supports.
- [[Soul Weaver Project]] — how browser and Python instances stay distinct yet in sync.
- [[AICord Partnership Proposal Draft]] ��� the partnership the proof of concept supports.
