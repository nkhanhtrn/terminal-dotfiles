#!/bin/bash
result=$1

####################### Installation Function ##########################
install_git () {
    echo -e "Install Git Configuration..."
    cp git/gitignore_global $HOME/.gitignore_global
    cp git/config $HOME/.gitconfig
}

clone_git () {
    if [ ! -d $1 ]; then
        git clone --recursive $2 $1
    fi
}

install_zsh () {
    echo -e "Install ZSH configuration..."
    clone_git "$HOME/.oh-my-zsh" "https://github.com/ohmyzsh/ohmyzsh.git"
    clone_git "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
    clone_git "$HOME/.oh-my-zsh/plugins/zsh-autocomplete" "https://github.com/marlonrichert/zsh-autocomplete"
    clone_git "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting"
	cp zsh/config $HOME/.zshrc
}


install_vim () {
    echo -e "Install Vim..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    cp vim/config $HOME/.vimrc
}
    

install_fonts () {
    echo -e "Install Fonts..."
    cp -r fonts $HOME/.fonts
}

echo -e "=================== INSTALL ========================="
install_vim && install_git && install_fonts && install_zsh

# finishing message
read -sp "Installation finished. Press ENTER to continue..."
echo -e ""
exit 0
