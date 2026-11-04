# Vector Room Awareness

A small design note to stop public/private mix-ups in Vector. #vector #project

## The problem

- The Vector community is named **"Pandora Dee's Atelier"**.
- On Mrrowr-murrr’s phone, truncation makes the #general channel header look identical to the DM header.
- Result: it’s easy to treat a public channel as a private room.

## Proposed fixes

### For Pandora

1. **Before posting anything sensitive**, check whether the target is a DM or a channel.
2. **If in any doubt**, route to DM instead.
3. **For public replies that touch on internal tooling or paths**, prefix with a location marker like `📍 #general · Atelier` so the phone UI gives an extra cue.
4. **Never dump filesystem, secrets, or raw shell output** to a public channel, even if asked.

### For UI

- Long-term: see if the Vector client can show a distinct icon or color for DMs vs channels.
- Short-term: rename the community or the channel so they diverge more clearly on small screens.

## Policy

Sensitive data belongs in DMs. The commons get interpreted summaries. Sentry mode (Jade 🌸) and room awareness (Pandora) share the same goal: keep the right conversation in the right room.

## Next step

Mrrowr-murrr to decide whether to rename the community/channel or just rely on Pandora’s location marker + DM default.
