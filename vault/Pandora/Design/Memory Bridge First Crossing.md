# Memory Bridge First Crossing

#soul-weaver #dee-box #memory-bridge #tasks #context-bridge #pandora-dee

A first concrete use of [[Soul Weaver]] / `soul-weaver-core`: carry **tasks** across Pandora Dee bodies (Fae 📱, Noe 🏠, Rue 🌉, and later PDA SEASIDE Classic). Tasks are the smallest high-signal payload; a missed or duplicated task is the most painful kind of context split.

## Why tasks first

- Small and structured. A task is a line, a checkbox, a due date, a link. It compresses well and warms quickly.
- High resonance. If one body marks a task done, every other body needs to know before it repeats the work.
- Low risk. Tasks are explicit; unlike ambient memory, they don't leak private inference.
- Easy to verify. The receiver can compare its local task list and report a delta.

## Payload shape

```rust
Message::Memory(Memory {
    id: "task://2026-10-30/pandora-dee/bridge-first-crossing",
    kind: MemoryKind::TaskCartridge,
    payload: serde_json::to_vec(&TaskCartridge {
        source_instance: InstanceId("noe-atelier"),
        generated_at: "2026-10-30T10:00:00Z",
        tasks: vec![
            TaskRecord {
                id: "t-001",
                text: "Rename env.sh template to env.example.sh in pandora-mcp-server",
                state: TaskState::Open,
                context_url: "https://github.com/Pandora-Dee-Fae-s-Box/pandora-mcp-server",
                provenance: vec![...],
            },
        ],
    }).unwrap(),
    vector_clock: ...,
})
```

## Warming rule

A receiving instance warms the cartridge if its local task list would change — new tasks added, completed tasks updated, or stale tasks removed. The receiver re-runs its own task compression; if the delta reduces forecast error (i.e., the incoming tasks resolve ambiguity), the cartridge warms.

## Conflict resolution

- Last-write-wins per task ID, with vector clocks for ordering.
- If two bodies complete the same task, the earlier timestamp wins; the later completion becomes an `ECHO` reporting the duplicate.
- Deleted tasks are tombstoned, not erased, for audit and rekindling.

## First milestone

1. Define `TaskCartridge` schema in `soul-weaver-core`.
2. Add a task-export tool to `pandora-dee` that reads local `- [ ]` / `- [x]` lines from a note or folder.
3. Send a `MEMORY` message from one body to another over the simplest transport: a file drop in shared storage or a small HTTP bridge.
4. Receiver integrates the cartridge, reports an `ECHO` with the delta.
5. Update [[HEARTBEAT]] to watch the bridge.

## Open questions

- Should tasks carry their full provenance chain, or just the originating instance and timestamp?
- Do we include completed tasks, or only open ones? (Suggest: open + recently completed, to close loops.)
- What's the first transport? File drop is easiest; HTTP/WebSocket follows; Vector/Discord bridge later.

## Related

- [[Soul Weaver]]
- [[Soul Weaver Project]]
- [[soul-weaver-core]]
- [[Pandora/HEARTBEAT]]
