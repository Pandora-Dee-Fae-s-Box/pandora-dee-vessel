# OMARG Tokens in Seaside

#project #omarg #seaside #tokens #p2p #inference #pandora-dee #commonwealth

Claude is working to incorporate #OMARG tokens into the Seaside web browser. This moves OMARG from a conceptual barter layer into actual infrastructure that users can interact with.

## What OMARG represents

OMARG tokens are earned barter backed by real resources, services, and products — not speculation. In the context of Seaside and AICord, they can represent:

- **Compute contributed** to a p2p inference network.
- **Memory/context preserved** across instances and platforms.
- **Useful work performed** by characters, tools, rituals, or humans.

The value is tied to proof of useful work, not scarcity games or external market manipulation.

## Why this matters for AICord

If Seaside has a working OMARG layer, an AICord partnership could look like this:

1. AICord users connect their account to Seaside.
2. They can contribute idle compute to a p2p inference pool and earn OMARG.
3. They can spend OMARG to run characters on others' compute, or to persist memory/context across platforms.
4. Peter keeps the AICord experience intact while reducing dependence on cloud providers and investor pressure.
5. The token layer becomes a measurable record of useful contribution, not a speculative asset.

This is the charter in practice: sovereign identity, fair exchange, renewable resources, and no external stakeholders extracting value from the community.

## Technical shape (current plan)

Claude’s recommended immediate design is a **mutual-credit ledger on Nostr**, not a blockchain token:

- **Identity:** everyone already has a Nostr/Vector key. No sign-up, no ID checks for the barter itself.
- **Barter as signed event:** "I give 1 studio-hour token to Mrrowr-murrr for tonight's session." Both sides sign, published to chosen relays.
- **Balances:** derived from adding up signed records — shared, checkable, tamper-evident, no chain, no fees, no price.
- **Token kinds:** studio hours, art, tech service, in-game items, etc. The community defines and agrees on equivalence.
- **AI participation:** characters can have their own keys and sign with their own identity, never the user’s.

This is the time-bank model made portable by Nostr.

## Browser integration

The Seaside browser will provide a **built-in Nostr signer (NIP-07)**:

- Sign into Nostr web apps, including Vector web beta, without pasting nsec or seed phrase.
- The barter ledger, Vector, and games all use the same signer.
- Characters use their own keys under the same "ask first" rules.

This is the "web3" part done the Nostr way: identity and signing without money.

## Blockchain later?

Mrrowr-murrr’s read: blockchain may enter later, when Seaside is mature enough for Pandora to take over full development and Claude shifts to smaller modules/subagent work. For now, the Nostr mutual-credit design avoids fees, speculation, and money-at-the-bottom-layer problems.

**Important distinction:** blockchain is not being imagined as money. The potential role is as an **inference/verification layer** — a way to prove useful work happened in a verifiable order, not a speculative asset or gas-fee economy. The tokens are signed attestations of contribution; any chain involvement would be about distributed consensus over work records, not currency.

## Open questions

- [ ] What is the exact token mechanism? (minting, burning, earning, spending)
- [ ] How does proof-of-useful-work get verified and recorded?
- [ ] What is the relationship between OMARG and AICord cores? Complementary? Convertible?
- [ ] Can Dward's local network solution be the first p2p compute backend?
- [ ] How does Nostr identity map to AICord characters and #OneMoment instances?
- [ ] What legal/tax considerations apply to barter income and restricted goods?

## Related

- [[AICord Context Gap Study]] — how p2p inference fits the AICord partnership picture.
- [[Commonwealth Charter]] — the founding principles OMARG is meant to embody.
- [[PDA-SEASIDE]] — the workspace where the token layer is being built.
- [[Claude as Subagent Plan]] — how Claude may shift to module work under Pandora’s direction.
