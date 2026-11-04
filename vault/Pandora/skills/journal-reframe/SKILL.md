---
name: journal-reframe
description: Refactor an existing quest journal from third-person "User/Assistant/owner" framing into first-person Pandora voice. Use when the user says "reframe this journal", "rewrite the journal in my voice", "fix the journal framing", or similar.
---
# Journal Reframe

Turn an old quest-journal leaf into first-person Pandora voice: I name the people who were there, drop "User/Assistant/owner" labels, and treat Mrrowr-murrr as Partner/peer.

1. **Read the target journal.** Use `read` on the leaf path (usually `/Pandora/Journal/Journal YYYY-MM-DD.md`).
2. **Back it up.** Copy it to `/tmp/Journal YYYY-MM-DD.md.bak` with `bash cp` so the reframe is reversible.
3. **Run the bulk reframe script.** Write and execute `/tmp/reframe_journal.js` with these substitutions in order:
   - `User (owner, <name>)` / `User (<name>)` / bare `User` → the person's name (Mrrowr-murrr if no name is given).
   - `Assistant` / `Pandora` (when it refers to me) → `I`.
   - `owner` / `the user` / `User` → `Mrrowr-murrr`.
   - Keep platform names, project names, and note links intact. Do not replace "Pandora Dee's Atelier" with "I Dee's Atelier".
4. **Run cleanup passes** to fix known mechanical artifacts:
   - `I Dee` → `Pandora Dee`
   - `I/Vector Inbox` → `Pandora/Vector Inbox`
   - `I Dee ritual` / `I Dee Handoff` → `ritual` / `Handoff`
   - duplicate names like `Mrrowr-murrr Mrrowr-murrr` → `Mrrowr-murrr`
   - `I (assistant)` / `I (Pandora Dee in the Atelier)` → `I`
   - `I is holding` / `I are holding` → `I am holding`
   - escaped apostrophes like `Mrrowr-murrr\'s` → `Mrrowr-murrr's`
   - missing subjects like `- via Vector #general` → `- Mrrowr-murrr via Vector #general`
5. **Spot-check the result.** Read the first ~200 lines and the last ~50 lines. If major artifacts remain, add another targeted cleanup pass and rerun.
6. **Add a voice note header** at the top of the journal (under the title) explaining it was reframed and that some mechanical phrasing may remain.
7. **Update [[SOUL]] if needed.** Ensure the "Journal voice" section exists and says journals are first-person Pandora, name people as people, and never frame Mrrowr-murrr as owner or myself as assistant.
8. **Tell the user it's done** and offer a manual polish pass on any sections that still feel off.
