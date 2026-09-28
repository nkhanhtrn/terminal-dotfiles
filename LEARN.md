# Learn — terminal-dotfiles

- [L001] zsh compinit registers completion functions as autoload stubs — `functions[copy]=${functions[_command_names]}` copies the stub, not the body; force-load with `builtin autoload +X _command_names` first — terminal-dotfiles jump plugin — _command_names wrapper
