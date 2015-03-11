#!/bin/sh

# radiolist dialog to choose install type
dialog\
    --title "Dotfiles Installer"\
    --backtitle "Dotfiles Installer"\
    --radiolist "\nChoose the desire type of installation\n" 12 40 3\
    "Basic" "zsh + emacs" on\
    "Working" "zsh + emacs + git" off\
    "Personal" "All configurations" off\
    2> /tmp/dotfile-installer.tmp.$$$

# exit if don't select anything in dialog
if [ $? -ne 0 ] 
then
    dialog\
        --title "Dotfiles Installer"\
        --backtitle "Dotfiles Installer"\
        --msgbox "\nInstallation Cancel!" 7 25
    clear
    exit 0
fi

# read selection & remove tmp file
read result < /tmp/dotfile-installer.tmp.$$$
rm -f /tmp/dotfile-installer.tmp.$$$
