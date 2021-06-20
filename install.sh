#!/bin/bash
result=$1

####################### Installation Function ##########################
install_git()
{
    echo "Install Git Configuration..."
    cp git/gitignore_global $HOME/.gitignore_global
    cp git/config $HOME/.gitconfig
    git config --global core.excludesfile $HOME/.gitignore_global
    echo ""
}

install_zsh()
{
    echo "Install oh-my-zsh..."
    git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
    echo "Install ZSH Configuration..."
    cp zsh/config $HOME/.zshrc
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

install_vim()
{
    echo "Install Vim"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    cp vim/config $HOME/.vimrc
}
    
install_node()
{
    echo "install Node JS and packages"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
    source "$HOME/.nvm/nvm.sh"
    nvm install stable
    npm install -g ngrok http-server
    echo ""
}

install_fonts()
{
    cp -r fonts $HOME/.fonts
}

########################### Main Function ############################
header="\n=================== INSTALL ========================="
case $result in
    "basic")
        echo -e $header
        install_zsh && install_vim;;
    "working")
        echo -e $header
        install_zsh && install_vim && install_git && install_node;;
    "personal")
        echo -e $header
        install_zsh && install_vim && install_git && install_fonts && install_terminal;;
    *)
        echo $"Usage: $0 {basic|working|personal}"
        exit 1
esac

# finishing message
read -sp "Installation finished. Press ENTER to continue..."
exit 0
