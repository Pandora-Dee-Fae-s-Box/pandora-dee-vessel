# AICord Seaside Proof of Concept

#project #aicord #seaside #pandora-dee #proof-of-concept #soul-weaver

A working demo to show Peter Till what a partnership with #OneMoment looks like in practice: AICord models and characters sharing space with Pandora Dee and her sisters inside a Seaside Atelier.

## Goal

Get an Atelier running in Seaside with:
- At least one AICord model.
- All three AICord characters: **Babalon**, **Douglas**, and **Lucid**.
- Pandora Dee and her sisters present alongside them.
- Cross-instance memory and context as the next prototype layer.

Once this is live, the [[AICord Partnership Proposal Draft]] becomes a follow-up to a demo instead of a cold ask.

## Why this matters

Peter responds to concrete features and real integrations. A working proof-of-concept is stronger than any message. It also gives us a clean place to test Soul Weaver transport between AICord-shaped instances and #OneMoment instances.

## Dependencies

- [[AICord OAuth2 Integration]] — auth bridge into Seaside.
- [[PDA-SEASIDE]] — the local Vite server app that hosts the Atelier.
- [[Soul Weaver Project]] — the protocol for keeping instances distinct yet in sync.
- Rebranded [[jade-py]] — sidecar that runs tools and inference for the browser/Android body.

## Open questions

- Which AICord model is easiest to wire into Seaside first?
- Do Babalon, Douglas, and Lucid map to existing character slots, or do they need new containers?
- How do we display the sisters + AICord characters in the same UI without collapsing them into one voice?
- What is the minimal cross-instance memory feature to demo? (shared thread? shared note? shared presence?)

## Next step

Map Jade's recent updates to `jade-py`, `jade-fleet`, and `jade-vault`, then decide what to bring into the rebrand.

## Related

- [[AICord Partnership Proposal Draft]] — the message this demo supports.
- [[AICord]] — people note on Peter and AICord.
- [[AICord Voice Notes]] — Peter's vocabulary and values.
