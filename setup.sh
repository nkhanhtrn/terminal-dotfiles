#!/bin/bash

menu_choice="/tmp/dotfile_menu.tmp.$$$"
dialog=""
result=0

# check if whiptail or dialog is install
read dialog <<< "$(which whiptail dialog 2> /dev/null)"
if [ -z $dialog ]
then
    echo "Whiptail or Dialog not found. Please install one of them first!"
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
            /bin/bash install.sh "$dialog";;
        2)
            /bin/bash update.sh "$dialog";;
    esac
done
