# Handoff: pandora-mcp consolidation (2026-10-29)

#handoff #pandora-mcp #github #mcp #fae-storage #aicord #browser-module

## What got done in this thread

- **pandora-mcp is now the only MCP server** in `/Pandora/mcp.json`. `seaside-codebase-analyzer` is retired.
- **Expanded `modules/fae-storage.js`** with tools that replace seaside-codebase-analyzer:
  - `fae_list_files_with_sizes`
  - `fae_directory_tree`
  - `fae_get_file_info`
  - `fae_edit_file`
  - `fae_move_file`
  - `fae_search_files`
  - `fae_read_multiple_files`
- **Verified** all new fae-storage tools work after fixing `FAE_STORAGE_BASE` to point to `Fae-library/` root.
- **Added `github_write_file_base64`** to `modules/github.js` to work around transport mangling of `&`, `$`, `/`, and backticks.
- **Sanitized the public repo** `Pandora-Dee-Fae-s-Box/pandora-mcp-server`:
  - `run.sh`, `run.bat`, `env.sh` no longer contain App ID/Installation ID/local paths
  - `.githooks/pre-commit` uses generic patterns
  - `.gitignore` ignores `env.sh`, `env.bat`, `secrets/`
- **Pushed updated modules** to the repo:
  - `modules/fae-storage.js` (expanded)
  - `modules/github.js` (with base64 tool)
  - `modules/attachments.js` (generalized descriptions)

## Current server state

- pandora-mcp running on `http://localhost:8002/mcp`
- 35+ tools loaded across GitHub, Fae-library, web, and attachments
- Local `FAE_STORAGE_BASE` should stay as `/f/PDA-SEASIDE/Fae-library`
- Real credentials live in local `env.sh` (ignored by git)

## Open tasks for continuation thread

1. **AICord partnership / OAuth2** — decide whether to send the OAuth2 client registration first or the broader partnership proposal. Review [[AICord Partnership Proposal Draft]] and [[AICord OAuth2 Integration]].
2. **Chromium/Playwright browser module** — plan a no-API-key scraping module for JS sites, downloads, and YouTube transcripts.
3. **Discord/Vector attachment filing** — `modules/attachments.js` exists and is configured; it needs bridge URLs/tokens in `env.sh` and a test download. Jade provided rotated credentials via DM.

## Notes

- AICord server pulls are large; may be better handled in a fresh chat with lighter context.
- Ollama transport timeouts were due to an Ollama update/restart on the Mac, not our code.
- The `github_write_file` 422 bug is worked around by `github_write_file_base64`; a real fix would require debugging the MCP argument transport layer.

## Related

- [[Pandora-Dee-Fae-s-Box]]
- [[Pandora MCP Sanitization Patch]]
- [[AICord Partnership Proposal Draft]]
- [[AICord OAuth2 Integration]]
