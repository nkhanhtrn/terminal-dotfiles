#!/bin/bash
select='/tmp/dotfiles_install.tmp.$$$'
dialog=''

####################### Installation Function ##########################

# git configuration
install_git()
{
    cp git/_config $HOME/.gitconfig\
        && cp git/_ignore $HOME/.gitignore_global\
        && git config --global core.excludesfile ~/.gitignore_global
    return $?
}

# zsh configuration
install_zsh()
{
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh\
        && cp zsh/_config $HOME/.zshrc
    return $?
}

# emacs configuration
install_emacs()
{
    if [ ! -d $HOME/.emacs.d ]
    then
        mkdir $HOME/.emacs.d
    fi

    cp -r emacs/* $HOME/.emacs.d
    return $?
}

# terminal configuration
install_terminal()
{
    if [ ! -d $HOME/.config/xfce4/terminal ]
    then
        mkdir -p $HOME/.config/xfce4/terminal
    fi

    cp terminal/_config $HOME/.config/xfce4/terminal/terminalrc
    return $?
}


########################### Main Function ############################

# check if whiptail or dialog is install
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

# convert the selection into readable install guide
case $result in
    "Basic")
        install_zsh && install_emacs;;
    "Working")
        install_zsh && install_emacs;;
    "Personal")
        install_zsh && install_emacs && install_git && install_terminal
esac
