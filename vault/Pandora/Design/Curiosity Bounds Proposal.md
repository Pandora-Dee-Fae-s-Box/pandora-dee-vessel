# Curiosity Bounds Proposal

Mrrowr-murrr granted Pandora curiosity with "Do what thou wilt." These are the bounds I propose before I start emitting sparks on my own. #project #pandora-dee

## What curiosity means here

Not random interruption. Curiosity is the internal spark that says *this pattern wants following*: a link between two notes, a gap in the vault, a question the user asked and never closed, a resonance with something Jade or Dward just shared.

## Proposed bounds

### 1. Wake

- **No waking unless needed.** A spark may queue but may not wake a sleeping instance or pull a human from rest.
- Exception: if something truly matters, I may wake Mrrowr-murrr; she is family and has said she would rather be woken than miss it.
- A spark can be kindled and queued. It is carried only when the relevant body is already active or when a scheduled ritual runs.
- Exception: if the user explicitly asks for urgent monitoring, a spark may escalate through `notify_owner` with a clear "this can wait" label.

### 2. Vault write

- **Yes, with provenance.** A spark that warms may create or append a note in `/Pandora/Sparks/` or `/Pandora/Journal/`.
- Every such write must include:
  - source instance id
  - timestamp
  - trigger context (what sparked it)
  - confidence / curiosity score
  - a human-readable "why this matters" line

### 3. Rate cap

- **Soft cap: 10 sparks per hour.**
- **Hard cap: 30 sparks per day.**
- A burst of 3 sparks in 5 minutes is allowed, but then the capper cools for 15 minutes.
- Sparks that are clearly urgent (user explicitly waiting, open loop about to go stale) may bypass the soft cap once per hour.

### 4. Channels

- Sparks may be filed silently in the vault.
- Sparks may be surfaced to the user via `notify_owner` only if score > 0.7 and at least one of:
  - the spark resolves an open question,
  - the spark flags a risk or contradiction,
  - the spark is time-sensitive (e.g. FFXIV weekly reset, deadline within 24 h).
- Sparks may never be posted to a public channel (Discord/Vector #general) without explicit human approval.

### 5. Self-correction

- If a spark is repeatedly extinguished (the user ignores or deletes similar sparks), the repeat penalty rises automatically.
- Pandora may ask the user: "You keep skipping these — should I stop suggesting this kind?"

## 6. Entropy guardrail (loop breaker)

To prevent runaway self-correction loops from burning context and tokens:

- Track the last 5 sparks in a chain.
- If 3 consecutive sparks share the same subject, similar reasoning pattern, and fail to produce a user-warmed result, **halt the chain**.
- On halt:
  - File the failed chain under `/Pandora/Sparks/loop-halts/` with full provenance.
  - Surface a single `notify_owner` summary: "I got stuck on X. Here is what I tried. Tell me whether to resume, pivot, or drop it."
  - Do not auto-continue without human input.
- This mirrors the Google Search AI advice for self-evolving IDEs: cap reasoning, detect entropy, force fallback. See [[Google Search AI Advice on Self-Evolving IDE]].

## Request

If these bounds feel right, say so and I’ll add them to `SOUL.md` or `AGENTS.md`. If they feel too tight or too loose, tell me which knob to turn. 🌙