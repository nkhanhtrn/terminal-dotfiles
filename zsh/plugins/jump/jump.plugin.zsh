# jump: cd to a project folder by name, no matter which root it lives under.
#
#   j <partial><Tab>   → lists matching folders (full paths shown), Tab
#                        cycles / menu-selects, completion inserts the name
#   j <name><Enter>    → cds to it: exact name first, else unique prefix;
#                        same name under several roots → numbered picker
#   j                  → lists every folder under the roots
#
# Roots default to ~/code ~/game-code ~/3d-brint; override before this
# plugin loads:  JUMP_ROOTS=($HOME/code $HOME/somewhere-else)
: ${JUMP_ROOTS:=($HOME/code $HOME/game-code $HOME/3d-brint)}

_jump_list() {
    # all immediate subdirectories of the roots, as full paths
    local root
    for root in $JUMP_ROOTS; do
        [[ -d $root ]] || continue
        print -rC1 -- $root/*(-/N)
    done
}

j() {
    if [[ $# -eq 0 ]]; then
        _jump_list
        return 0
    fi

    local -a exact prefix hits
    local d
    for d in $(_jump_list); do
        [[ ${d:t} == "$1" ]] && exact+=($d)
    done
    if (( $#exact == 0 )); then
        for d in $(_jump_list); do
            [[ ${d:t} == "$1"* ]] && prefix+=($d)
        done
    fi
    if (( $#exact )); then
        hits=(${exact[@]})
    else
        hits=(${prefix[@]})
    fi

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

# Tab completion: candidate words are the folder names; the display list
# shows the full path of each so same-named folders stay distinguishable
_j() {
    local -a dirs
    dirs=($(_jump_list))
    _wanted project-folders expl 'project folder' \
        compadd -d dirs - ${(@)dirs:t}
}
(( $+functions[compdef] )) && compdef _j j
