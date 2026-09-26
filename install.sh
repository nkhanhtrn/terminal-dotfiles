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

PI_SERVE_REPO="https://github.com/nkhanhtrn/pi-serve"

find_pi_sh () {
    for _d in "$HOME/pi-serve" "$HOME/code/pi-serve" "$HOME/chat"; do
        for _p in "$_d/pi.sh" "$_d/scripts/pi.sh"; do
            if [ -f "$_p" ]; then
                echo "$_p"
                return 0
            fi
        done
    done
    return 1
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

install_yazi () {
    echo -e "Install Yazi Configuration..."
    # yazi itself comes from brew (brew install yazi)
    mkdir -p $HOME/.config/yazi
    cp yazi/yazi.toml $HOME/.config/yazi/yazi.toml
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
    # terminal session restore helpers: new Konsole tabs attach to tmux (tt),
    # and konsole-restore reopens one tab per tmux session after boot
    # (tmux-continuum restores the sessions incl. per-pane cwds)
    cp "$HERE/scripts/tt" "$HERE/scripts/konsole-restore" "$HOME/.local/bin/"
    chmod +x "$HOME/.local/bin/tt" "$HOME/.local/bin/konsole-restore"
    if [ -f "$HOME/.local/share/konsole/KK.profile" ]; then
        sed -i "s|^Command=.*|Command=$HOME/.local/bin/tt|" "$HOME/.local/share/konsole/KK.profile"
    fi
    # save tmux sessions (resurrect) when the graphical session ends
    mkdir -p "$HOME/.config/systemd/user"
    sed "s|/home/nkhanhtrn|$HOME|g" "$HERE/tmux/tmux-save.service" > "$HOME/.config/systemd/user/tmux-save.service"
    systemctl --user daemon-reload 2>/dev/null
    systemctl --user enable --now tmux-save.service 2>/dev/null || true
}

install_pi_serve () {
    echo -e "Install pi-serve..."
    PI_SH="$(find_pi_sh || true)"
    if [ -z "$PI_SH" ]; then
        echo -e "No checkout found, cloning pi-serve..."
        clone_git "$HOME/pi-serve" "$PI_SERVE_REPO"
        PI_SH="$HOME/pi-serve/pi.sh"
    fi
    if ! command -v node &>/dev/null; then
        echo -e "pi-serve needs Node.js, skipping setup. Install it ('./install.sh nvm' + new shell, or 'pkg install nodejs' on Termux), then re-run './install.sh pi-serve'." >&2
        return 0
    fi
    # pi.sh setup wires everything itself: systemd user unit (+linger) on
    # Linux, plain background start otherwise, and the Termux:Boot hook
    # pinned to the deployed checkout.
    if ! bash "$PI_SH" setup; then
        echo -e "pi-serve setup failed; re-run later with: bash $PI_SH setup" >&2
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
    # tmux extras (Termux-only bindings, sourced by ~/.tmux.conf if present)
    cp termux/tmux-extra.conf "$HOME/.tmux.conf.termux"
    # autostart tmux at device boot (Termux:Boot); pi-serve's boot hook is
    # owned by pi.sh setup, not by dotfiles
    mkdir -p "$HOME/.termux/boot"
    cp "$HERE/termux/boot/tmux-start" "$HOME/.termux/boot/tmux-start"
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

install_bazzite_fixes () {
	echo -e "Apply Bazzite system fixes..."
	# disable the press-and-hold diacritics popup on Plasma systems
	if command -v kwriteconfig6 &>/dev/null; then
		"$HERE/scripts/fix-keyboard-hold.sh"
	else
		echo -e "No Plasma keyboard config tool found, skipping keyboard fix..."
	fi
}

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "=================== INSTALL ========================="
case "$result" in
    all|z13)
        install_vim && install_git && install_fonts && install_nvm && install_zsh && install_desktop && install_tmux && install_yazi && install_pi_serve && install_termux
        ;;
    bazzite)
        install_vim && install_git && install_fonts && install_nvm && install_zsh && install_desktop && install_tmux && install_yazi && install_pi_serve && install_termux && install_bazzite_fixes
        ;;
    vim)     install_vim ;;
    git)     install_git ;;
    fonts)   install_fonts ;;
    nvm)     install_nvm ;;
    zsh)     install_zsh ;;
    desktop) install_desktop ;;
    tmux)    install_tmux ;;
    yazi)    install_yazi ;;
    pi-serve) install_pi_serve ;;
    termux)  install_termux ;;
    *)
        echo "unknown target: '$result' (all | z13 | bazzite | vim | git | fonts | nvm | zsh | desktop | tmux | yazi | pi-serve | termux)" >&2
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
