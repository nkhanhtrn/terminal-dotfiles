#!/bin/sh

####################### Installation Function ##########################
# git configuration
install_git()
{
    cp git/_config $HOME/.gitconfig\
       1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$\
        && cp git/_ignore $HOME/.gitignore_global\
              1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$\
        && git config --global core.excludesfile ~/.gitignore_global\
               1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$
       return $?
}

# zsh configuration
install_zsh()
{
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh\
        1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$\
        && cp zsh/_config $HOME/.zshrc\
              1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$
    return $?
}

# emacs configuration
install_emacs()
{
    if [ ! -d $HOME/.emacs.d ]
    then
        mkdir $HOME/.emacs.d\
              1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$
    fi

    cp -r emacs/* $HOME/.emacs.d\
          1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$
    return $?
}

# terminal configuration
install_terminal()
{
    if [ ! -d $HOME/.config/xfce4/terminal ]
    then
        mkdir -p $HOME/.config/xfce4/terminal\
                 1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$
    fi

    cp terminal/_config $HOME/.config/xfce4/terminal/terminalrc\
          1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$
    return $?
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
rm dotfiles_error 2> /dev/null
date > /tmp/dotfiles_error.tmp.$$$
echo "===============================" >> /tmp/dotfiles_error.tmp.$$$

# convert the selection into readable install guide
case $result in
    "Basic")
        install_zsh && install_emacs
        if [ $? -eq 0 ]
        then
            rm /tmp/dotfiles_error.tmp.$$$
        else
            cp /tmp/dotfiles_error.tmp.$$$ dotfiles_error
        fi;;
    "Working")
        install_zsh && install_emacs
        if [ $? -eq 0 ]
        then
            rm /tmp/dotfiles_error.tmp.$$$
        else
            cp /tmp/dotfiles_error.tmp.$$$ dotfiles_error
        fi;;
    "Personal")
        install_zsh && install_emacs && install_git && install_terminal
        if [ $? -eq 0 ]
        then
            rm /tmp/dotfiles_error.tmp.$$$
        else
            cp /tmp/dotfiles_error.tmp.$$$ dotfiles_error
        fi;;
esac

# print error msg box when dotfiles_error exists
if [ -f dotfiles_error ]
then
    dialog\
        --title "Dotfiles Installer"\
        --backtitle "Dotfiles Installer"\
        --msgbox "\nInstallation Failed! Consult dotfiles_error for more information." 10 35
    clear
    exit 0
else
    dialog\
        --title "Dotfiles Installer"\
        --backtitle "Dotfiles Installer"\
        --msgbox "\nInstallation Success!" 7 25
    clear
    exit 1
fi
