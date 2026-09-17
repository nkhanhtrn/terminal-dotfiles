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
    clone_git "$HOME/.tmux/plugins/tpm" "https://github.com/tmux-plugins/tpm.git"

    # resolve zsh path robustly (command -v fails in restricted PATHs)
    ZSH_PATH=""
    for _c in "$(command -v zsh 2>/dev/null)" \
              /home/linuxbrew/.linuxbrew/bin/zsh \
              /usr/bin/zsh /bin/zsh; do
        if [ -x "$_c" ]; then ZSH_PATH="$_c"; break; fi
    done
    ZSH_PATH="${ZSH_PATH:-$SHELL}"
    sed "s|ZSH_PATH|${ZSH_PATH}|g" tmux/config > $HOME/.tmux.conf
    # install plugins: tpm's installer needs a tmux server with config sourced
    if [ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
        tmux start-server 2>/dev/null || true
        # create a throwaway session if none exists, so source-file has a server
        if ! tmux ls &>/dev/null; then
            tmux new-session -d -s _tpm_install
            _OCD_CLEANUP=1
        fi
        tmux source-file "$HOME/.tmux.conf" 2>/dev/null || true
        "$HOME/.tmux/plugins/tpm/bin/install_plugins"
        [ -n "$_OCD_CLEANUP" ] && tmux kill-session -t _tpm_install 2>/dev/null || true
    fi
}

install_termux () {
    # Termux-only: the main app provides ~/.termux
    if [ ! -d "$HOME/.termux" ]; then
        echo -e "Not Termux, skipping..."
        return 0
    fi
    echo -e "Install Termux Configuration..."
    mkdir -p "$HOME/.termux"
    cp termux/termux.properties "$HOME/.termux/termux.properties"
    # autostart tmux at device boot (Termux:Boot)
    mkdir -p "$HOME/.termux/boot"
    cp termux/boot/tmux-start "$HOME/.termux/boot/tmux-start"
    chmod 700 "$HOME/.termux/boot/tmux-start"
    command -v termux-reload-settings &>/dev/null && termux-reload-settings
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
        install_vim && install_git && install_fonts && install_nvm && install_zsh && install_desktop && install_tmux && install_termux
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
