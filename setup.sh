#!/bin/bash

menu_choice="/tmp/dotfile_menu.tmp.$$$"
dialog=""
result=0
select='/tmp/dotfiles_install.tmp.$$$'

# check if whiptail or dialog is install
read dialog <<< "$(which whiptail dialog 2> /dev/null)"
if [ -z $dialog ]
then
    echo "Whiptail or Dialog not found. Please run the setup directly from install.sh or update.sh"
    exit 1
fi

# menu dialog
while [ $result -ne 3 ]
do
    $dialog --title "Doftiles Setup"\
            --backtitle "Terminal Dotfiles"\
            --menu "Choose one: " 10 40 3\
            1 "Install"\
            2 "Update"\
            3 "Exit"\
            2> "$menu_choice"

    # read input, rm input tmp, create error tmp
    read result < "$menu_choice"
    rm -f "$menu_choice"

    # convert the selection into readable install guide
    case $result in
        1)
            # radiolist dialog to choose install type
            $dialog\
                --title "Dotfiles Installer"\
                --backtitle "Dotfiles Installer"\
                --radiolist "\nChoose the desire type of installation\n" 12 40 3\
                "Basic" "zsh + emacs" on\
                "Working" "zsh + emacs + git" off\
                "Personal" "All configurations" off\
                2> "$select"

            # read input, rm input tmp, create error tmp
            read result < "$select"
            rm -f "$select"

            # convert the selection into readable install guide
            /bin/bash install.sh "$result";;
        2)
            /bin/bash update.sh "$result";;
    esac
done
