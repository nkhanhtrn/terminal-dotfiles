#!/bin/bash
result=$1

####################### Installation Function ##########################
# git configuration
install_git()
{
    echo "Install Git Configuration..."
    cp git/_config $HOME/.gitconfig
    cp git/_ignore $HOME/.gitignore_global
    git config --global core.excludesfile $HOME/.gitignore_global
    echo ""
}

# zsh configuration
install_zsh()
{
    echo "Install oh-my-zsh..."
    git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
    echo "Install ZSH Configuration..."
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
    git clone git://github.com/nkhanhtrn/emacs.d $HOME/.emacs.d
    echo ""
}

# terminal configuration
install_terminal()
{
    if [ ! -d $HOME/.config/xfce4/terminal ]
    then
        mkdir -p $HOME/.config/xfce4/terminal
    fi
    echo "Install Terminal Configuration..."
    cp terminal/_config $HOME/.config/xfce4/terminal/terminalrc
    echo ""
}

# NVM install
install_nvm()
{
    echo "install Node Version Manager..."
    curl https://raw.githubusercontent.com/creationix/nvm/v0.24.0/install.sh | bash
    source "$HOME/.nvm/nvm.sh"
    nvm install stable
    echo ""
}

########################### Main Function ############################
header="\n=================== INSTALL ========================="
case $result in
    "basic")
        echo -e $header
        install_zsh && install_emacs;;
    "working")
        echo -e $header
        install_zsh && install_emacs;;
    "personal")
        echo -e $header
        install_zsh && install_emacs\
            && install_git\
            && install_terminal && install_nvm;;
    *)
        echo $"Usage: $0 {basic|working|personal}"
        exit 1
esac

# finishing message
read -sp "Installation finished. Press ENTER to continue..."
exit 0
