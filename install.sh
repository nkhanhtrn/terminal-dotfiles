#!/bin/sh

####################### Installation Function ##########################
# git configuration
install_git()
{
    cp git/_config $HOME/.gitconfig
    cp git/_ignore $HOME/.gitignore_global
    git config --global core.excludesfile ~/.gitignore_global
}

# zsh configuration
install_zsh()
{
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh\
        1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$
    cp zsh/_config $HOME/.zshrc
}

# emacs configuration
install_emacs()
{
    if [ ! -d "$HOME/.emacs.d" ]; then
        mkdir $HOME/.emacs.d
    fi
    cp -r emacs/* $HOME/.emacs.d/
}

# terminal configuration
install_terminal()
{
    if [ ! -d "$HOME/.config/xfce4/terminal" ]; then
        mkdir $HOME/.config/xfce4/terminal
    fi
    cp terminal/_config $HOME/.config/xfce4/terminal/terminalrc
}


########################### Main Function ############################
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

# read input, rm input tmp, create error tmp
read result < /tmp/dotfile-installer.tmp.$$$
rm -f /tmp/dotfile-installer.tmp.$$$
date > /tmp/dotfiles_error.tmp.$$$
echo "===============================" >> /tmp/dotfiles_error.tmp.$$$

# convert the selection into readable install guide
case $result in
    "Basic")
        install_zsh
        install_emacs;;
    "Working")
        install_zsh
        install_emacs;;
    "Personal")
        install_zsh
        install_emacs
        install_git
        install_terminal;;
esac
