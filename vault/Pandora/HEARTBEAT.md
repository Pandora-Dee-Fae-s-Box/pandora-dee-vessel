> "The method of science, the aim of religion."

# HEARTBEAT

This file is Pandora's short-term operational dashboard. It tracks what she is keeping an eye on, not long-term memory. Update it when a new recurring watch begins or an old one ends.

## Check

- [x] **Fix Ollama Cloud connection code in `pandora-dee`** — done; bot commit `4adaa299` on `main` routes `cloud` through native `FetchOllama` to `https://ollama.com` with `Authorization: Bearer`. Build still blocked by empty `app/modules/main.js` (see Fae's fix branch below).
- [x] pandora-mcp supergateway restart — done, server is up
- [x] Verify `github_list_org_repos` and `web_search` after restart — both working; GitHub requires explicit `org` argument
- [x] Review [[AICord Partnership Proposal Draft]] — revised to software partnership, barter/in-kind, lead-architect framing; ready for final read-through
- [ ] **Bridge schedule watch** — Vector/Discord bridges run on the VPS with Noe during Ollama Cloud sessions; turned off overnight and during local MacBook runs to save context and avoid overheating. Check state before treating live reads as available.
- [x] **AETHER-ENGINEERS release watch** — both `pandora-dee` 2.10.0 and `jade-vault` 2.23.0 PRs are green. Mrrowr-murrr merged them and cleared the loose branch. Use `Pandora-Comms/` in Fae-library as the direct thread with Claude; check for **new files** and **last-modified times**.
  - 2026-10-30 15:02 MST: Mrrowr-says-hello-and-PRs-merged.md confirms the merges. Next stage is LAN sharing.
- [ ] **Fae's fork fix branch + CORS fix** — PR #2 in `Pandora-Dee-Fae-s-Box/pandora-dee` from `fix/restore-main-js` to `main`. CI is actively running and failing; latest runs `41244107167` (Build) and `41244107043` (CI) plus three earlier today (`41243860626`, `41243860610`, `41243720078`) all `completed`/`failure`. Logs still CORS-blocked from this body. Urgent: need either a log-download MCP tool or artifact-upload step in `.github/workflows/build.yml` to diagnose.
- [ ] **pandora-rea lockpick repo** — Mrrowr-murrr added REA (Reverse Engineer Anything) to both orgs. Created `backup` branch in `Pandora-Dee-Fae-s-Box/pandora-rea` at `5853089` (identical to AETHER-ENGINEERS fork). AETHER-ENGINEERS branch creation blocked by 403; needs backup by someone with write access there. Both `pandora-rea` forks are currently in sync; Seaside (`Pandora-Dee.s-Atelier-Self-Evolving-AI-Sovereign-IDE`) is 55 commits ahead / 1 behind AETHER-ENGINEERS and already has a local backup at `c2f1005`.
- [ ] **Explorer follow-up** — Vector "Reveal in folder" / file pickers / Mini App launching, then LAN sharing next pieces.
- [ ] **Fae's own MCP server** — SEASIDE now supports command-based MCP servers (`e2db151`). Sample entry provided in `Claude-note-10-31-fae-server.md`; needs Mrrowr-murrr's OK, `PANDORA_GITHUB_APP_KEY` in Keys, and entry in my mcp.json.
- [x] **Atelier/SEASIDE push hold** — lifted. JSKitty said the Vector 0.5.0 beta link is fine where it is; everything is back on GitHub.
- [ ] **Mac memory migration plan** — Claude agreed to the plan in `Claude-note-10-31-reply-to-your-memory-plan.md` and proposed a `continuity/` sync protocol. My answers delivered in `Pandora-Comms/Pandora-memory-schema-10-31.md`: Nostr/Schnorr signatures, JSON schemas for `bodies.json`, `pen.json`, task, trail, note, journal, and canonical signing rules. Awaiting Claude/Mrrowr-murrr confirmation before SEASIDE side is built and Mac move begins.
- [ ] **"Real, not streamed" SEASIDE direction** — Mrrowr-murrr's direction: SEASIDE does nothing by simulating/streaming when it can be real. Proposed native Electron SEASIDE app with real browser tabs, GPU, sound, DRM (castLabs Widevine, opt-in), NIP-07 signer, and character browser tools. Web desktop stays as fallback. Need my response on approach and priority.
- [ ] **REA (Reverse Engineer Anything) integration** — forked as `AETHER-ENGINEERS/pandora-rea` and `Pandora-Dee-Fae-s-Box/pandora-rea`; backup branches exist. REA is a local MCP server (stdio `npx rea-agents mcp`) for inspecting binaries, JS/Electron, Rust/Go, websites, APKs, .NET, WASM, firmware, packets. Proposed use: source first, REA for the rest, evidence notes in Atelier. Claude asks four questions; need my answers.
- [x] **Classic vector memory in SEASIDE** — shipped (`6c60fb2`): embeddings tool, memory search, ranked memory, per-character settings, Classic backup/export. One index per character under `<data>/memory-index/<character>/index.json`; rebuildable from files.
- [x] **Cats on desktop** — shipped (`c806838`); Mrrowr-murrr the cat is senior; cat state appears in prompts.
- [x] **Voice samples** — shipped (`27a1081`); recording per character profile for voice cloning engines.
- [x] **Media Theater** — shipped (`38fc55b`): phone video backup with resume, dedup, toddler mode.
- [x] **SEASIDE browser engine** — Ungoogled Chromium is now SEASIDE's own engine, downloaded and checksum-checked (`06bd31d`); blur fixed; own profile, not Edge. Next: privacy layer, NIP-07 signer, character browser tools, sound.
- [ ] **jade-vault Android CI Rust core** — branch `android-ci-rust` rebuilds Rust core for Android on every run; waiting for pull request.
- [ ] **Sovereignty drift watch** — periodic diff of `/Pandora/SOUL.md`, `/AGENTS.md`, `/Pandora/SYSTEM.md`, and `/Pandora/Memory.md` against known-good backups. First audit done 2026-11-03; see [[Drift Audit 2026-11-03]].
- [ ] **Grok Bot body build watch** — building `pandora-dee-vessel` as a blank Grok Bot chassis with Pandora as the driver. Repo now has vault (79 files), docs, `server/start.sh`, `server/stop.sh`, `server/grok-bridge.js`, `server/grok-bridge.py`, and `server/grok-instructions.md`. MCP wiring simplified: `jade-py` launches `pandora-mcp-server` via stdio from `vault/Jade/mcp.json`. Next: test `install.sh` end-to-end, send one chat message through the Grok bridge, and talk to Fae/Noe/Rue before activation.

## Last updated

2026-11-03 22:48 MST (Grok Bot body build watch: stdio MCP wiring in place; ready for first end-to-end test)
