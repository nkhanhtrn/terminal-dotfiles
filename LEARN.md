# Learn — terminal-dotfiles

- [L001] zsh compinit registers completion functions as autoload stubs — `functions[copy]=${functions[_command_names]}` copies the stub, not the body; force-load with `builtin autoload +X _command_names` first — terminal-dotfiles jump plugin — _command_names wrapper
- [L002] `vim -u {vimrc}` skips the auto 'nocompatible' switch that a normally-found ~/.vimrc triggers — `nnoremap <C-f> …` then silently maps the literal text "<C-f>" (raw Ctrl-F stays page-forward); test vimrc behavior without `-u`, and keep `set nocompatible` as the first line — terminal-dotfiles vimrc — phantom "missing Ctrl+F mapping" during pty verification
- [L003] maparg() key notation must be written `"\<C-f>"` (double quotes + backslash escape) — single-quoted '<C-f>' looks up a literal 5-character key and always returns '' — terminal-dotfiles vimrc — three empty maparg probes before the quoting clicked
