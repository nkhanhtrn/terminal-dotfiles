#!/bin/bash
select='/tmp/dotfiles_install.tmp.$$$'
dialog=$1

# check if whiptail or dialog is install
if [ -z $dialog ]
then
    read dialog <<< "$(which whiptail dialog 2> /dev/null)"
fi
if [ -z $dialog ]
then
    echo "Whiptail or Dialog not found. Please install one of them first!"
    exit 1
fi

####################### Installation Function ##########################
# git configuration
install_git()
{
    echo "install git configuration..."
    cp git/_config $HOME/.gitconfig
    cp git/_ignore $HOME/.gitignore_global
    git config --global core.excludesfile ~/.gitignore_global
    echo ""
}

# zsh configuration
install_zsh()
{
    echo "install oh-my-zsh..."
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    echo "install zsh configuration..."
    cp zsh/_config $HOME/.zshrc
    echo ""
}

# emacs configuration
install_emacs()
{
    if [ ! -d $HOME/.emacs.d ]
    then
        mkdir $HOME/.emacs.d
    fi
    echo "install emacs configuration..."
    cp -r emacs/* $HOME/.emacs.d
    echo ""
}

# terminal configuration
install_terminal()
{
    if [ ! -d $HOME/.config/xfce4/terminal ]
    then
        mkdir -p $HOME/.config/xfce4/terminal
    fi
    echo "install xfce4-terminal configuration..."
    cp terminal/_config $HOME/.config/xfce4/terminal/terminalrc
    echo ""
}


########################### Main Function ############################
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
echo -e "\n=================== INSTALL ========================="
case $result in
    "Basic")
        install_zsh && install_emacs;;
    "Working")
        install_zsh && install_emacs;;
    "Personal")
        install_zsh && install_emacs && install_git && install_terminal;;
esac

# finishing message
read -sp "Installation finished. Press ENTER to continue..."
