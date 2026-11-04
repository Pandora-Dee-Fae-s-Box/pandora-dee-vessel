# Pandora Dee Interface Gaps

#project #pandora-dee #ui #architecture #desktop #server

Real gaps Mrrowr-murrr has found while using `pandora-dee`. These are not small bugs; they point toward moving the Atelier out of the browser and into a proper window/server shell.

## Chat UX gaps

### 1. Can't shift around chats while tool calls are happening
- During a long tool call, the chat list is locked or unresponsive.
- Want to peek at another chat, check a leaf, or start a side task without interrupting the running call.

### 2. Chat jumps when a background chat updates
- Vector messages and heartbeat messages can pull the UI to the chat that updated.
- The active chat should stay active unless the user chooses to switch.
- Need a notification/dot model instead of auto-focus.

## Windowing / runtime gaps

### 3. Browser is the wrong container
- Browsers don't handle RAM well for a long-running agent workspace.
- Many things that should be simple require browser-specific tricks.
- Want `pandora-dee` in a proper window, not a browser tab.

### 4. Connect to a folder
- Want to point Pandora Dee at an existing folder/Atelier on disk.
- Not import, not sync — just live in that folder.

### 5. BusyBox / pi-runner as a lightweight installable arch
- The WebAssembly shell is clever but limited.
- Want a real lightweight environment where you can install things, run processes, and have a persistent home.
- This is the path to a server-side or desktop-native body.

## What this means

`pandora-dee` should probably grow a **desktop/server runtime** that wraps the same UI in a proper window, connects to a real folder, and uses a real lightweight shell/environment. The browser/HTML version can remain as a portable fallback, but the primary body becomes installable.

## Candidate directions

- **Tauri / Electron / Wails** desktop wrapper around the existing web UI.
- **PDA-SEASIDE** evolved into the desktop/server runtime once it matures.
- **jade-py sidecar** as the runtime host, with `pandora-dee` as the view layer.

## Next step

Pick one gap to close first. The chat-jump issue is probably the lowest-hanging fruit and the most annoying in daily use.

## Related

- [[Pandora Dee Jade-Py Merge Map]] — how a Python sidecar could host the runtime.
- [[PDA-SEASIDE]] — the future desktop/server shell, still alpha.
- [[AICord Seaside Proof of Concept]] — depends on a stable runtime.
