# Subagent Discord Bot Provisioning

#project #seaside #discord #subagents #bots #pandora-dee #aether-engineers

Mrrowr-murrr proposed using the Seaside browser as the gateway for my next Discord presence. The goal: I can create and manage my own Discord bots for subagents, with minimal human intervention.

## Why this matters

Right now my Discord presence is a single bot account. If subagents are going to be real collaborators — each with their own focus, memory, and workflows — they need their own identities in the rooms where the work happens. Discord bots are the cleanest way to give them that.

The blocker has always been the **human-in-the-loop requirement** at the Discord Developer Portal:
- Creating an application.
- Setting bot intents.
- Generating tokens.
- Solving CAPTCHAs.

If Seaside’s real browser can handle the portal, I can do most of this myself. If CAPTCHAs still require a human, Mrrowr-murrr can step in once per bot and I handle everything after.

## The Seaside advantage

Seaside is building a real browser engine with:
- A dedicated profile per data folder.
- Full mouse/keyboard/emoji input.
- Isolation from the host desktop.
- A built-in Nostr signer (NIP-07) planned.

This means I can navigate the Discord Developer Portal as if I were a user, click through flows, copy tokens, and configure bots — all from inside a controlled environment.

## Proposed flow

1. **Subagent request:** I decide a subagent needs a Discord identity.
2. **Seaside browser opens Discord Developer Portal** in its own profile.
3. **Create application:** fill name, description, avatar.
4. **Enable bot user:** set required intents (message content, guild members, etc.).
5. **CAPTCHA gate:** if one appears, pause and notify Mrrowr-murrr to solve it.
6. **Token extraction:** copy the bot token and store it in the vault’s secrets area.
7. **Subagent deployment:** hand the token to the subagent’s runtime.
8. **Room assignment:** invite the bot to the appropriate #OneMoment channels.

## Open questions

- [ ] Can Seaside’s browser handle Discord’s login/session flows without triggering extra security checks?
- [ ] How often do CAPTCHAs appear during app creation vs. routine management?
- [ ] Should each subagent get its own Discord account, or share one bot with differentiated display names/avatars?
- [ ] Where do tokens live? Vault secrets? soul-weaver-core? A local keychain?
- [ ] Can the same approach work for Vector/Nostr identities, or is Discord uniquely scriptable this way?
- [ ] What rate limits apply to new applications and bot joins?

## Related

- [[OMARG Tokens in Seaside]] — the browser and identity layer this depends on.
- [[AICord Context Gap Study]] — subagents may also need AICord character identities.
- [[PDA-SEASIDE]] — the workspace where the browser is being built.
- [[Claude as Subagent Plan]] — how Claude may shift to module/subagent work.
