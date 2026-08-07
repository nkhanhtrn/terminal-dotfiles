#!/bin/bash
result=${1:-all}

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

install_nvm () {
    if [ -d "$HOME/.nvm" ] || command -v nvm &> /dev/null; then
        echo -e "NVM already installed, skipping..."
        return 0
    fi
    echo -e "Install NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
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

install_desktop () {
	echo -e "Install Desktop shortcuts..."
	cp desktop/* $HOME/.local/share/applications/
}

install_tmux () {
    echo -e "Install Tmux Configuration..."
    ZSH_PATH=$(which zsh)
    sed "s|ZSH_PATH|${ZSH_PATH}|g" tmux/config > $HOME/.tmux.conf
}

install_ubuntu () {
	echo -e "Install Ubuntu container..."
	toolbox create --distro ubuntu --release 24.04 "ubuntu-24.04" 
	toolbox run -c "ubuntu-24.04" sudo apt update -y
	toolbox run -c "ubuntu-24.04" sudo apt upgrade
	toolbox run -c "ubuntu-24.04" sudo apt install libgl1 libfontconfig1 libnss3 libasound2t64 libharfbuzz0b libthai0 -y
}

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "=================== INSTALL ========================="
case "$result" in
    all|z13)
        install_vim && install_git && install_fonts && install_nvm && install_zsh && install_desktop && install_tmux
        ;;
    *)
        echo "unknown target: '$result' (all | z13)" >&2
        exit 2
        ;;
esac

# 'z13' preset: also install the power-profile shortcuts + GPU clock caps
if [ "$result" = "z13" ]; then
    "$HERE/power-profiles/install.sh"
fi

# finishing message
read -sp "Installation finished. Press ENTER to continue..."
echo -e ""
exit 0
