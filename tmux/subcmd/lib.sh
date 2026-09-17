#!/data/data/com.termux/files/usr/bin/sh
# Shared helpers for subcmd daemon/popup.
LC_ALL=C.UTF-8
export LC_ALL

# get_words [pane_id] — print "<word> <prefix>" from the pane's current
# input line (last non-empty line, prompt chars stripped).
#
# The line is cut at the cursor column first: zsh-autosuggestions renders
# gray suggestion text after the cursor, which plain capture-pane can't
# distinguish from typed text. Everything past the cursor is suggestion.
get_words() {
    pane="${1:-}"
    cx=$(tmux display-message -p -t "$pane" '#{cursor_x}' 2>/dev/null)
    line=$(tmux capture-pane -p -t "$pane" 2>/dev/null \
        | sed 's/\x1b\[[0-9;?]*[a-zA-Z]//g; s/\x1b\][^\x07]*\x07//g' \
        | sed -e 's/[[:cntrl:]]//g' \
        | grep -v '^[[:space:]]*$' | tail -1)
    # keep only what's left of the cursor (actually-typed text)
    case "$cx" in
        '' | *[!0-9]*) ;;
        0) return 0 ;;
        *) line=$(printf '%s' "$line" | cut -c1-"$cx") ;;
    esac
    # strip prompt decoration: leading non-alnum chars (> ❯ $ % # etc.)
    line=$(printf '%s' "$line" | sed -E 's/^[^a-zA-Z0-9_.\/-]*//')
    [ -z "$line" ] && return 0
    set -- $line
    # unwrap sudo
    [ "$1" = "sudo" ] && shift
    [ $# -eq 0 ] && return 0
    word="$1"; pref=""
    [ "$#" -eq 2 ] && pref="$2"
    printf '%s %s' "$word" "$pref"
}

# at_prompt [pane_id] — true if the pane is running an idle shell
# (i.e. the user could be typing a command right now)
at_prompt() {
    pane="${1:-}"
    cur=$(tmux display-message -p -t "$pane" '#{pane_current_command}' 2>/dev/null)
    case "$cur" in
        zsh | bash | sh | dash | ksh | fish) return 0 ;;
        *) return 1 ;;
    esac
}

# build_hint <word> <prefix> — format the status-bar hint string
build_hint() {
    word="$1"; pref="$2"
    case "$word" in
        "" | */* | -* | .*) return 0 ;;
    esac
    list=$(suggest "$word" "$pref" 2>/dev/null | head -6 | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/·/g')
    [ -z "$list" ] && return 0
    hint="⚡ $word ❯ $list"
    # keep the status bar sane on a narrow phone
    printf '%s' "$hint" | cut -c1-42
}
