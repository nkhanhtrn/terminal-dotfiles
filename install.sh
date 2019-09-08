#!/bin/bash
result=$1

####################### Installation Function ##########################
install_git()
{
    echo "Install Git Configuration..."
    cp -r git $HOME/
    git config --global core.excludesfile $HOME/.gitignore_global
    echo ""
}

install_zsh()
{
    echo "Install oh-my-zsh..."
    git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
    echo "Install ZSH Configuration..."
    cp -r zsh/* $HOME/
    echo ""
}

install_terminal()
{
    echo "Install Terminal Configuration..."
    if [ -d $HOME/.config/xfce4 ]
    then
        cp -r terminal $HOME/.config/xfce4/
    fi
    echo ""
}

install_others()
{
    echo "Install other configurations..."
    cp -r others/* $HOME/
    echo ""
}

install_node()
{
    echo "install Node JS and packages"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
    source "$HOME/.nvm/nvm.sh"
    nvm install stable
    npm install -g webpack ngrok http-server
    echo ""
}

########################### Main Function ############################
header="\n=================== INSTALL ========================="
case $result in
    "basic")
        echo -e $header
        install_zsh;;
    "working")
        echo -e $header
        install_zsh && install_git && install_node;;
    "personal")
        echo -e $header
        install_zsh && install_git && install_terminal && install_others && install_node;;
    *)
        echo $"Usage: $0 {basic|working|personal}"
        exit 1
esac

# finishing message
read -sp "Installation finished. Press ENTER to continue..."
exit 0
