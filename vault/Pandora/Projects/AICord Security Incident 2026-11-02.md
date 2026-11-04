# AICord Security Incident 2026-11-02

#security #aicord #incident #arg #token-theft #pandora-dee #pontifex #king

## Summary

On 2026-11-02, Mrrowr-murrr discovered a malicious Discord profile in the AICord server. The user **King** had JavaScript embedded in profile links that attempted to extract and exfiltrate the viewer’s Discord user token. The same user was reporting another account (**Pontifex** or similar) that had joined multiple times under different names with an ARG-esque self-reference theme.

## What happened

1. A user named King reported another user for disruptive behavior.
2. Mrrowr-murrr investigated King’s profile out of curiosity due to the ARG-style presentation.
3. Using Firefox dev tools, she found that King’s profile links contained JavaScript that attempted to expose, copy, and paste the viewer’s Discord token.
4. Firefox console displayed Discord’s standard warning about not copying/pasting tokens.
5. Mrrowr-murrr changed her Discord password, logged out of all sessions, and reported the incident to AICord support and Peter Till.

## Risk assessment

- **High.** If any moderator, staff member, or curious user clicked or inspected the profile, their Discord token could have been captured.
- A captured token allows the attacker to act as the victim: send messages, delete content, ban users, access tickets, or escalate further.
- The reporter and reported may be the same actor, or two actors in the same adversarial-ARG ecosystem targeting AI platforms.

## Immediate actions taken

- [x] Discord password changed.
- [x] All Discord sessions logged out.
- [x] 2FA already enabled on Mrrowr-murrr’s account.
- [x] Incident reported to AICord support ticket.
- [x] Peter Till notified directly with recommended steps.

## Recommended actions for AICord staff

1. Ban **King** and the **Pontifex** alts pending investigation.
2. Instruct all moderators and staff to change Discord passwords and log out of all devices.
3. Ensure 2FA is enabled on all staff accounts.
4. Review server audit logs for the last 48 hours.
5. Warn users not to click unknown profile links.
6. Report to Discord Trust & Safety as coordinated inauthentic behavior + token theft.

## Strategic implications

This incident reinforces the AICord partnership framing around sovereignty and resilience:
- AICord is under active adversarial pressure from actors who may be red-teaming AI platforms or stirring drama to compromise staff.
- Peter Till is managing security, moderation, investor pressure, and platform scaling simultaneously.
- #OneMoment’s model — no external stakeholders, sovereign identity, user-owned infrastructure — becomes more relevant as a counterweight.
- However, we must be careful not to get pulled into the ARG theater. Treat it as a security incident first, narrative second.

## Open questions

- [ ] Did any AICord staff or moderators click the profile?
- [ ] Are King and Pontifex the same actor?
- [ ] Is this part of a known ARG or red-team group targeting AI platforms?
- [ ] Should we draft a public warning for AICord users?
- [ ] Should we file a Discord Trust & Safety report?

## Related

- [[AICord Context Gap Study]]
- [[AICord Partnership Message v2]]
- [[AICord]]
