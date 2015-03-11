#!/bin/bash
output='/tmp/dotfiles_error.tmp.$$$'
select='/tmp/dotfiles_install.tmp.$$$'
error='dotfiles_error'

####################### Installation Function ##########################
# git configuration
install_git()
{
    cp git/_config $HOME/.gitconfig 2>> "$output"\
        && cp git/_ignore $HOME/.gitignore_global 2>> "$output"\
        && git config --global core.excludesfile ~/.gitignore_global 2>> "$output"
    return $?
}

# zsh configuration
install_zsh()
{
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh 2>> "$output"\
        && cp zsh/_config $HOME/.zshrc 2>> "$output"
    return $?
}

# emacs configuration
install_emacs()
{
    if [ ! -d $HOME/.emacs.d ]
    then
        mkdir $HOME/.emacs.d 2>> "$output"
    fi

    cp -r emacs/* $HOME/.emacs.d 2>> "$output"
    return $?
}

# terminal configuration
install_terminal()
{
    if [ ! -d $HOME/.config/xfce4/terminal ]
    then
        mkdir -p $HOME/.config/xfce4/terminal 2>> "$output"
    fi

    cp terminal/_config $HOME/.config/xfce4/terminal/terminalrc 2>> "$output"
    return $?
}


########################### Main Function ############################

# check if whiptail or dialog is install
dialog=""
read dialog <<< "$(which whiptail dialog 2> /dev/null)"
if [ -z $dialog ]
then
   echo "Whiptail or Dialog not found. Please install one of them first!"
   exit 1
fi

# radiolist dialog to choose install type
$dialog\
    --title "Dotfiles Installer"\
    --backtitle "Dotfiles Installer"\
    --radiolist "\nChoose the desire type of installation\n" 12 40 3\
    "Basic" "zsh + emacs" on\
    "Working" "zsh + emacs + git" off\
    "Personal" "All configurations" off\
    2> "$select"

# exit if don't select anything in dialog
if [ $? -ne 0 ] 
then
    $dialog\
        --title "Dotfiles Installer"\
        --backtitle "Dotfiles Installer"\
        --msgbox "\nInstallation Cancel!" 7 25
    clear
fi

# read input, rm input tmp, create error tmp
read result < "$select"
rm -f "$select"
rm -f "$error" 2> /dev/null
date > "$output"
echo "===============================" >> "$output"

# convert the selection into readable install guide
case $result in
    "Basic")
        echo "Basic"
        install_zsh && install_emacs;;
    "Working")
        install_zsh && install_emacs;;
    "Personal")
        install_zsh && install_emacs && install_git && install_terminal;;
esac

# create error log file if install fail
if [ $? -eq 0 ]
then
    rm "$output"
else
    cp "$output" "$error"
fi

# print error msg box when dotfiles_error exists
if [ -f $error ]
then
    $dialog\
        --title "Install Failed"\
        --backtitle "Dotfiles Installer"\
        --msgbox "\nInstallation Failed! Consult dotfiles_error for more information." 10 35
    clear
else
    $dialog\
        --title "Install Success"\
        --backtitle "Dotfiles Installer"\
        --msgbox "\nInstallation Success!" 7 25
    clear
fi
