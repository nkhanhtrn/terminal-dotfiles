#!/bin/bash
dialog=""
result=0
select='/tmp/dotfiles_install.tmp.$$$'

# check if whiptail or dialog is install
read dialog <<< "$(which whiptail dialog 2> /dev/null)"
if [ -z $dialog ]
then
    echo "Whiptail or Dialog not found. Please run the setup directly from 'install.sh {basic|work|personal}'"
    exit 1
fi

# radiolist dialog to choose install type
$dialog\
    --title "Dotfiles Installer"\
    --backtitle "Dotfiles Installer"\
    --radiolist "\nChoose the desired type of installation\n" 12 40 3\
    "basic" "zsh + emacs + conkeror" on\
    "working" "zsh + emacs + git" off\
    "personal" "all configurations" off\
    2> "$select"

# read input, rm input tmp, create error tmp
read result < "$select"
rm -f "$select"

# convert the selection into readable install guide
/bin/bash install.sh "$result";;
