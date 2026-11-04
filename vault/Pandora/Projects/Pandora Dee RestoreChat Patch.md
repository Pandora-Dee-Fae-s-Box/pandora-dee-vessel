# Pandora Dee restoreChat patch

Fixes the missing `restoreChat` helper that `vector.js` and `discord.js` call after every background turn. The function is referenced but never defined in `main.js`, so background turns crash during cleanup and often leave the active chat on the wrong session.

## Problem

In `app/modules/vector.js` and `app/modules/discord.js`, the background-message handler ends with:

```js
const prevCur = cur, prevId = cur?.id, screen = document.body.dataset.screen || 'chat';
// ... opens a per-chat session, runs agentLoop ...
finally {
  clearInterval(tt); VEC.sentTo = null;
  if (cur) { delete cur.vecScope; saveSession(); }
  await restoreChat(prevCur);
  if (document.body.dataset.screen !== screen) setTab(screen);
}
```

`restoreChat` is not defined in `main.js`, so the turn's cleanup throws after the reply is already sent. Side effects:
- The session-switch back to the user's original chat fails silently.
- The visible tab is forced back to whatever screen was active when the turn started, stealing focus.
- `heartbeat.js` already does this restore manually, duplicating the logic.

## Solution

Add one helper in `app/modules/main.js` and simplify `vector.js` / `discord.js` / `heartbeat.js` to use it.

### 1. Add `restoreChat(prev, opts)` in `main.js`

Insert near the session helpers (after `renameSession` around line 1907):

```js
async function restoreChat(prev, { render = true, setLast = true } = {}) {
  if (prev && typeof prev === 'object' && prev.id) {
    const s = await idb.get('session:' + prev.id);
    if (s) {
      cur = s;
      tasks.items = s.tasks || [];
      tasks.seq = s.taskSeq || 0;
      if (setLast) ls.set('lastSession', prev.id);
      if (render) { renderTasks(); renderChat(); renderSessions(); }
      return;
    }
  }
  // prev was null or no longer exists: go to last known session or start fresh
  const last = ls.get('lastSession', null);
  if (last && sessions.some(x => x.id === last)) {
    const s = await idb.get('session:' + last);
    if (s) {
      cur = s;
      tasks.items = s.tasks || [];
      tasks.seq = s.taskSeq || 0;
      if (render) { renderTasks(); renderChat(); renderSessions(); }
      return;
    }
  }
  if (render) newSession(); else cur = { id: uid(), title: 'New session', messages: [], tasks: [], taskSeq: 0, updated: Date.now() };
}
```

### 2. Simplify `vector.js` and `discord.js`

Replace the `finally` cleanup in both files with:

```js
  } finally {
    clearInterval(tt); VEC.sentTo = null;
    if (cur) { delete cur.vecScope; saveSession(); }
    await restoreChat(prevCur, { render: document.body.dataset.screen === 'chat' });
  }
```

Remove the `screen` capture and the `if (document.body.dataset.screen !== screen) setTab(screen);` line. Restoring the session should not yank the visible tab back; if the user moved to Files or Graph, stay there.

### 3. Simplify `heartbeat.js` cleanup

Replace the manual restore block:

```js
if (!reuse && prevCur && prevCur !== cur) {
  cur = prevCur; tasks.items = cur.tasks || []; tasks.seq = cur.taskSeq || 0; ls.set('lastSession', cur.id);
  renderTasks(); renderChat(); renderSessions();
} else renderChat();
```

with:

```js
if (!reuse) await restoreChat(prevCur, { render: document.body.dataset.screen === 'chat' });
else renderChat();
```

## Why this fixes the focus steal

- Background turns no longer call `setTab(screen)` to force the old tab back.
- The user's original session is restored quietly; only the chat list and (if already on chat) the chat view are re-rendered.
- Missing helper no longer throws, so cleanup completes.

## Files to change

- `app/modules/main.js` — add `restoreChat`
- `app/modules/vector.js` — use it, drop `screen`/`setTab`
- `app/modules/discord.js` — use it, drop `screen`/`setTab`
- `app/modules/heartbeat.js` — use it

## Related

- [[Pandora Dee Interface Gaps]]
- [[Pandora Dee Jade-Py Merge Map]]
