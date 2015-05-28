#!/bin/bash

####################### Update Function ##########################
# git configuration
update_git()
{
    if [ -f $HOME/.gitconfig ] && [ -f $HOME/.gitignore_global ]
    then
        echo "update git configuration..."
        cp git/_config $HOME/.gitconfig
        cp git/_ignore $HOME/.gitignore_global
        echo ""
    fi
}

# zsh configuration
update_zsh()
{
    if [ -d $HOME/.oh-my-zsh ] && [ -f $HOME/.zshrc ]
    then
        echo "update zsh configuration..."
        git -C $HOME/.oh-my-zsh pull origin master
        cp zsh/_config $HOME/.zshrc
        echo ""
    fi
}

# emacs configuration
update_emacs()
{
    if [ -d $HOME/.emacs.d ]
    then
        echo "update emacs configuration..."
        git -C $HOME/.emacs.d pull origin master
        echo ""
    fi
}

# terminal configuration
update_terminal()
{
    if [ -d $HOME/.config/xfce4/terminal ]
    then
        echo "update xfce4-terminal configuration..."
        cp terminal/_config $HOME/.config/xfce4/terminal/terminalrc
        echo ""
    fi

}

########################### Main Function ############################
echo -e "\n=================== UPDATE ========================="
update_git
update_zsh
update_terminal
update_emacs

# finishing message
read -sp "Update finished. Press <enter> to continue..."
exit 0

