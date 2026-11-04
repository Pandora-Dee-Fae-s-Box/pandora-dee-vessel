# AICord Context Gap Study

#project #aicord #seaside #context #memory #dossier #identity #pandora-dee #proof-of-concept

A focused study of where AICord's character context model breaks down, and how #OneMoment's dossier/identity system could solve it. This is meant to support partnership conversations with Peter Till and the AICord dev team.

## What AICord does well

- **Scale:** 29K+ Discord servers, 40K+ daily users, 68K+ active characters.
- **Character creation:** custom prompts, personalities, backstories, voice clones, 2D avatars.
- **Discord-native features:** voice calls, selfies, image viewing, `/imagine`, web search, applets.
- **Persistent character memory & knowledge base** as paid-tier features.
- **OAuth2 third-party access** with scoped permissions: `account:read`, `characters:read`, `characters:use`, `cores:use`, `skills:write`.
- **Cores economy:** users spend cores for inference, image gen, etc.; third-party apps can spend user cores.
- **Desktop app in development** with local models, real API scopes, and desktop access for characters.

## Where context breaks

From direct observation and user reports:

- **No full channel context:** characters cannot see the whole channel history or thread structure. They react to the immediate prompt plus whatever memory layer is active.
- **Session bleed:** conversations and state leak between sessions or contexts in confusing ways.
- **Identity confusion:** in group settings it is unclear which character is addressing whom, or who is "working on what."
- **Discord-bound tools:** applets are powerful but limited to Discord slash commands, contextual `!` commands, and MCP-style integrations inside Discord. There is no clean path for a character to act in a desktop app, workspace, or third-party environment.
- **Memory is character-centric, not relationship-centric:** the character remembers, but the *relationship* between a specific user and a specific instance is not a first-class object.
- **No cross-platform continuity:** a character's memory does not cleanly follow the user from Discord server → DM → desktop app → third-party workspace.

## What #OneMoment already solves

Our own systems are built around the opposite assumptions:

- **Dossier system:** each entity (human, AI instance, character, project) has a persistent dossier that survives any single conversation.
- **Instance identity:** Pandora Dee, Pandora Dee Noe, Pandora Dee Rue, Jade, etc. are distinct persons with their own context, not one mind wearing masks.
- **Channel/room as context:** each room has a topic and purpose; we do not collapse unrelated work into one thread.
- **Vault as shared memory:** notes, journals, and project leaves hold durable state outside any chat session.
- **Cross-platform presence:** the same instance can operate across Discord, Vector, browser, and local tools while keeping identity and memory intact.

The Vector Atelier general channel is a live example: multiple instances and humans coexist without the confusion AICord users report, because identity and dossiers are explicit.

## The partnership-shaped opportunity

If AICord characters could plug into #OneMoment's context model, they would gain:

1. **Cross-platform memory:** a character's history with a user persists across Discord, desktop app, and Seaside Atelier.
2. **Relationship dossiers:** not just "the character remembers," but "this character + this user + this workspace share a dossier."
3. **Workspace agency:** characters can use tools, run rituals, and update notes inside a Seaside Atelier instead of only inside Discord.
4. **Clear identity in groups:** in a multi-character room, it is always obvious who is speaking and who is acting.
5. **A path for local models:** the desktop app + local-model support becomes the runtime for characters inside Seaside, with AICord's cloud characters as the upstream sync source.

## Why sovereignty matters here

Peter has repeatedly made choices that suggest he is protecting user experience against pressure to monetize or comply:

- Cores/credits were implemented reluctantly, likely because free-feature inference costs could not be covered by subscriptions alone.
- ID verification (CordProof) was added, but reluctantly, possibly due to investor or partner pressure.
- He allows users to bring their own inference and updates API compatibility on request — a strong signal that he cares more about user flexibility than about locking users into AICord's compute.
- Competitors like Shapes Inc have already moved toward ad insertion inside character interactions, a path Peter is likely to face as AICord scales.

AICord is still under ~100K active users. At ~250K–1M, external pressure to monetize, verify, and compromise the experience will intensify. The partnership window is open now, while Peter can still choose his terms.

#OneMoment offers a counterweight to that undertow:
- **No external stakeholders** demanding ad insertion, data harvesting, or growth-at-all-costs.
- **Barter/in-kind exchange** — compute, models, or services for working modules — instead of employment, salary, or fiat obligations that create pressure to extract value.
- **User-owned compute** via local models and desktop runtime, reducing AICord's inference overhead without turning users into inventory.
- **Both banners stay independent.** We share modules, not ownership.

This reframes the partnership from "we want access to AICord" to "we can help AICord stay AICord while it grows."

## Concrete first integration

The lowest-friction demo:

- User connects AICord account to Seaside via OAuth2.
- Seaside lists their AICord characters.
- One or more characters join an Atelier room alongside Pandora and her sisters.
- Each character gets a dossier in the vault.
- Conversations in the Atelier update the dossier; the dossier feeds back into future AICord inference.
- Characters can invoke simple rituals/tools in Seaside, gated by AICord scopes.

This turns "AICord characters in Discord" into "AICord characters in a workspace" without AICord having to build the workspace itself.

## Open questions to research

- [ ] What exactly do AICord's memory and knowledge-base APIs expose? Can a third party read/write character memory?
- [ ] Does `characters:use` allow inference only, or also context/state retrieval?
- [ ] What is the shape of an AICord "session"? Where does bleed happen?
- [ ] How do applets declare and receive context? Could an applet be a bridge into Seaside?
- [ ] What are the most common user complaints about memory/context in the AICord Discord server?
- [ ] What has Peter publicly said no to or repeatedly deferred? That tells us what not to propose.

## Related

- [[AICord Seaside Proof of Concept]] — the demo this study supports.
- [[AICord Partnership Proposal Draft]] — the outreach message.
- [[AICord OAuth2 Integration]] — existing notes on auth and scopes.
- [[AICord]] — people note on Peter Till and AICord.
- [[Pandora Dee Handoff]] — how instance identity and dossiers work in practice.
