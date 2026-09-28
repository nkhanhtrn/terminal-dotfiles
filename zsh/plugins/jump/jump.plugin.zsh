# jump: cd to project folders by bare name.
#
#   ar<TAB>            → at the command position, root folders complete
#                        with their full paths in the list; Tab cycles
#   ar-reader<Enter>   → cds (exact name first, else unique prefix;
#                        ambiguous → candidates are listed, no cd)
#   j ar<Tab> / j ar…  → explicit form of the same; bare `j` lists all
#
# Roots default to ~/code ~/game-code ~/3d-brint; override before this
# plugin loads:  JUMP_ROOTS=($HOME/code $HOME/elsewhere)
(( $+JUMP_ROOTS )) || JUMP_ROOTS=($HOME/code $HOME/game-code $HOME/3d-brint)

_jump_list() {
    # all immediate subdirectories of the roots, as full paths
    local root
    for root in $JUMP_ROOTS; do
        [[ -d $root ]] || continue
        print -rC1 -- $root/*(-/N)
    done
}

# full paths whose basename equals $1 (exact preferred) or starts with it
_jump_matches() {
    local q="$1" d
    local -a exact prefix all
    all=($(_jump_list))
    for d in $all; do
        if [[ ${d:t} == "$q" ]]; then
            exact+=($d)
        elif [[ ${d:t} == "$q"* ]]; then
            prefix+=($d)
        fi
    done
    if (( $#exact )); then
        print -rC1 -- $exact
    else
        print -rC1 -- $prefix
    fi
}

j() {
    if [[ $# -eq 0 ]]; then
        _jump_list
        return 0
    fi

    local -a hits
    hits=($(_jump_matches "$1"))

    case $#hits in
        0)
            print -u2 "j: no folder matching '$1' under ${(j:, :)JUMP_ROOTS}"
            return 1
            ;;
        1)
            cd -- ${hits[1]}
            ;;
        *)
            # ambiguous: same name under several roots — numbered picker
            local i sel
            for i in {1..$#hits}; do
                printf '  %d) %s\n' $i ${hits[i]}
            done
            printf 'jump to: '
            if read sel && [[ $sel == <1-> && $sel -le $#hits ]]; then
                cd -- ${hits[$sel]}
            else
                return 1
            fi
            ;;
    esac
}

# Tab completion for the explicit form: candidate words are the folder
# names; the display list shows the full path of each
_j() {
    local -a dirs
    dirs=($(_jump_list))
    _wanted project-folders expl 'project folder' \
        compadd -d dirs - ${(@)dirs:t}
}
(( $+functions[compdef] )) && compdef _j j

# --- bare names at the command position --------------------------------
# Tab: root folders join the command-name candidates (listed with their
# full paths). oh-my-zsh runs compinit before loading plugins, so the
# wrapper can be installed right away; if compinit has not run yet, defer
# to the first prompt — compinit defines _command_names and would replace
# a wrapper installed too early.
_jump_wrap_command_names() {
    # compinit leaves _command_names as an autoload stub — force the real
    # body to load before copying it, or the saved "function" points nowhere
    builtin autoload +X _command_names 2>/dev/null
    functions[_jump__orig_command_names]=${functions[_command_names]}
    _command_names() {
        _jump__orig_command_names "$@"
        local __ret=$?
        local -a __dirs
        __dirs=($(_jump_list))
        (( $#__dirs )) || return __ret
        compadd -d __dirs -J jump-folders -X 'project folder' \
            -- ${(@)__dirs:t}
        return __ret
    }
}
# project folders first in the candidate list (unlisted groups keep their
# default order after it)
zstyle ':completion:*:-command-:*' group-order jump-folders

if (( $+functions[_command_names] )); then
    _jump_wrap_command_names
else
    autoload -Uz add-zsh-hook
    _jump_late_wrap() {
        add-zsh-hook -d precmd _jump_late_wrap
        (( $+functions[_command_names] )) && _jump_wrap_command_names
    }
    add-zsh-hook precmd _jump_late_wrap
fi

# Enter: a bare word that matches no command/alias/function/builtin/path
# but does match a folder under the roots becomes `cd -- <path>` before the
# line is accepted (ambiguous → `j <word>` for the numbered picker).
# Done in an accept-line widget because command_not_found_handler runs in
# a sandboxed context where cd does not stick.
_jump_accept_line() {
    if [[ $CONTEXT == start ]]; then
        local -a _jw=(${(z)BUFFER})
        if (( $#_jw == 1 )) && [[ $_jw[1] == [a-zA-Z0-9_.,-]* && $_jw[1] != -* ]] \
        && ! (( $+commands[$_jw[1]] || $+aliases[$_jw[1]] || $+functions[$_jw[1]] \
                || $+builtins[$_jw[1]] || $+widgets[$_jw[1]] )) \
        && ! [[ -e $_jw[1] ]] \
        && ! whence -w -- $_jw[1] >/dev/null 2>&1; then
            local -a _jh=($(_jump_matches "$_jw[1]"))
            if (( $#_jh == 1 )); then
                BUFFER="cd -- ${_jh[1]}"
            elif (( $#_jh > 1 )); then
                BUFFER="j ${_jw[1]}"
            fi
        fi
    fi
    zle .accept-line
}
zle -N accept-line _jump_accept_line

# command_not_found_handler cannot cd (sandboxed), but listing candidate
# folders for a near-miss is still useful
if (( $+functions[command_not_found_handler] )); then
    functions[_jump__orig_cnf]=${functions[command_not_found_handler]}
fi
command_not_found_handler() {
    local -a hits
    hits=($(_jump_matches "$1"))
    (( $#hits > 1 )) && print -u2 "folder candidates: ${(j:, :)hits}"
    if (( $+functions[_jump__orig_cnf] )); then
        _jump__orig_cnf "$@"
    else
        print -u2 "zsh: command not found: $1"
        return 127
    fi
}
