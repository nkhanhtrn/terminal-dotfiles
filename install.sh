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
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
    echo "Install ZSH Configuration..."
    cp zsh/config $HOME/.zshrc
    echo "Change to ZSH Shell"
    chsh -s $(which zsh)
    echo ""
}


install_vim()
{
    echo "Install Vim"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    cp vim/config $HOME/.vimrc
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
        install_zsh && install_vim && install_git;;
    "personal")
        echo -e $header
        install_zsh && install_vim && install_git && install_fonts;;
    *)
        echo $"Usage: $0 {basic|working|personal}"
        exit 1
esac

# finishing message
read -sp "Installation finished. Press ENTER to continue..."
exit 0
