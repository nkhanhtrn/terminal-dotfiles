#!/bin/sh
REDIRECT="1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$"

####################### Installation Function ##########################
# git configuration
install_git()
{
    return_val=1

    if cp git/_config $HOME/.gitconfig\
          1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$\
            && cp git/_ignore $HOME/.gitignore_global\
                  1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$\
            && git config --global core.excludesfile ~/.gitignore_global\
                   1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$
    then
        return_val=0
    fi

    return $return_val
}

# zsh configuration
install_zsh()
{
    return_val=1

    if git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh\
           1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$\
            && cp zsh/_config $HOME/.zshrc\
                  1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$
    then
        return_val=0
    fi

    return $return_val
}

# emacs configuration
install_emacs()
{
    return_val=1

    if [ ! -d $HOME/.emacs.d ]
    then
        if mkdir $HOME/.emacs.d\
              1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$
        then
            return_val=0
        fi
    fi

    if cp -r emacs/* $HOME/.emacs.d\
          1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$
    then
        return_val=0
    fi

    return $return_val
}

# terminal configuration
install_terminal()
{
    return_val=1

    if [ ! -d $HOME/.config/xfce4/terminal ]
    then
        if mkdir -p $HOME/.config/xfce4/terminal\
                 1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$
        then
            return_val=0
        fi
    fi

    if cp terminal/_config $HOME/.config/xfce4/terminal/terminalrc\
          1> /dev/null 2>> /tmp/dotfiles_error.tmp.$$$
    then
        return_val=0
    else
        return_val=1
    fi

    return $return_val
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
        if install_zsh && install_emacs
        then
            rm /tmp/dotfiles_error.tmp.$$$
        else
            cp /tmp/dotfiles_error.tmp.$$$ dotfiles_error
        fi;;
    "Working")
        if install_zsh && install_emacs
        then
            rm /tmp/dotfiles_error.tmp.$$$
        else
            cp /tmp/dotfiles_error.tmp.$$$ dotfiles_error
        fi;;
    "Personal")
        if install_zsh && install_emacs && install_git && install_terminal
        then
            rm /tmp/dotfiles_error.tmp.$$$
        else
            cp /tmp/dotfiles_error.tmp.$$$ dotfiles_error
        fi;;
esac
