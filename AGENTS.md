# terminal-dotfiles — Agent Guide

<!-- Add project-specific commands and constraints here as the project grows. -->

## PM Protocol

This repo is worked by two opencode sessions sharing state through `FEATURES.md`:

| Role | Session | Job |
|---|---|---|
| **Planner** | studio (`planner` agent, see .opencode/agents/planner.md) | discuss, plan, curate the feature list |
| **Builder** | terminal (build agent, `/next` + `/report` commands) | implement features from the plan |

### Files

- `FEATURES.md` — the kanban board both sessions share:
  columns `## Backlog` / `## In Progress` / `## Blocked` hold cards `- <tag> · <text>`
  (tag ∈ `feature` · `bug` · `refactor` · `chore`; listed order *is* the priority),
  `## Shipped` holds dated history (`- YYYY-MM-DD · <tag> — one-line summary`, newest first),
  `## Log` is the append-only session audit trail.
  The chat app's `@pm` bridge writes are limited to the three working columns
  (add / move / edit cards) — Shipped and Log are builder-only; the local
  pi-serve enforces this on the wire.

### Rules

1. Planner is the only author of new cards (into `## Backlog` by default). Builder moves cards between columns and ships them; it never rewrites shipped history or log lines.
2. Builder works strictly off the board — first resume the top `## In Progress` card, else take the top `## Backlog` card and move it to `## In Progress`. No invented scope.
3. Finishing a card: move it to the top of `## Shipped` as `YYYY-MM-DD · <tag> — one-line summary` and append one `## Log` line (`YYYY-MM-DD · done · <tag> — one-line summary`). A card may span several sittings; between them it stays in `## In Progress` with an indented progress note.
4. Blocked: move the card to `## Blocked` with an indented note explaining why; planner triages on its next studio turn.
5. Neither role commits, stages, or pushes. The human reviews and commits checkpoints.
6. Both roles re-read `FEATURES.md` before acting — the other session may have written since your last look.
