# terminal-dotfiles

This is the back-up of my terminal dotfiles.

## pi-serve

[pi-serve](https://github.com/nkhanhtrn/pi-serve) is a first-class target:

```sh
./install.sh pi-serve      # standalone
./install.sh all           # included in the full preset (also z13/bazzite)
```

The installer reuses an existing checkout if it finds one (`~/pi-serve`,
`~/code/pi-serve`, `~/chat`, each with `pi.sh` or `scripts/pi.sh`), otherwise
clones the repo to `~/pi-serve`, then runs `pi.sh setup`, which wires startup
per platform:

- **Linux**: systemd user unit `pi.service` (enabled + linger) — starts at
  boot. `systemctl --user status pi.service` to check.
- **Termux**: background start + a Termux:Boot hook that `pi.sh setup`
  installs itself (pinned to the deployed checkout) — starts at device boot
  via the [Termux:Boot](https://wiki.termux.com/wiki/Termux:Boot) app (open
  it once after installing).

Node.js is required (`./install.sh nvm` on Linux, `pkg install nodejs` on
Termux); without it the target warns and skips.
