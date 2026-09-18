---
description: Claim and complete the next card from the kanban board (FEATURES.md)
---
Current board: @FEATURES.md

Work the board as the builder session (AGENTS.md → PM Protocol):

1. Claim: if an argument was given ($ARGUMENTS), find that card in `## Backlog` / `## In Progress` / `## Blocked`; otherwise resume the top card in `## In Progress` if any, else take the top card in `## Backlog` and move it to `## In Progress`. If the working columns are empty, say so and stop.
2. Implement it. Follow this repo's AGENTS.md; do only what the card describes — no invented scope.
3. Verify: run the checks this repo's AGENTS.md documents (build / test / lint). If none are documented, run the project's standard build and test commands if they exist. Fix any failures.
4. Close out:
   - Done: move the card to the top of `## Shipped` as `YYYY-MM-DD · <tag> — one-line summary`, append one `## Log` line (`YYYY-MM-DD · done · <tag> — one-line summary`), and refresh the Last updated header.
   - Still in progress: leave the card in `## In Progress` and add an indented progress note (what's done, what's next sitting).
   - Genuinely stuck: move the card to `## Blocked` with an indented note on the blocker instead.
5. Do not commit or stage anything. Stop after one card — the human decides whether to run /next again.
