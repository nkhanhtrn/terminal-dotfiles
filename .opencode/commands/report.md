---
description: Append a session progress report to FEATURES.md without starting new work
---
Current board: @FEATURES.md

Write a progress report as the builder session (AGENTS.md → PM Protocol):

1. Summarize what was actually done this session: files touched, commands and tests run with their outcome, and anything left half-finished (there must be a card in `## In Progress` for it on the board — add one if not).
2. Append 1–3 lines to the `## Log` (`YYYY-MM-DD · session · <tag> — one-line summary`, tag ∈ feature/bug/refactor/chore) and refresh the Last updated header. Never rewrite or remove existing log lines or shipped entries.
3. Do not start new cards. Do not commit.
