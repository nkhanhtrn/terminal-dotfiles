#!/bin/sh
echo "Start install the configuration"

############# Start installer #################

#### Initialize ####
if [ ! -d "$HOME/.config/xfce4/terminal" ]; then
    mkdir $HOME/.config/xfce4/terminal
fi

# emacs folder preparation
if [ ! -d "$HOME/.emacs.d" ]; then
    mkdir $HOME/.emacs.d
fi

#### Emacs ####
echo "======= Emacs Setup ======"
cp -r emacs/* $HOME/.emacs.d/
echo "==========================\n"

#### Nvm ####
echo "======= NVM Setup ======="
git clone https://github.com/creationix/nvm.git ~/.nvm
echo "===============================\n"

#### Terminal Configuration ####
echo "======= XFCE4 Terminal setup ======="
cp terminal/_config $HOME/.config/xfce4/terminal/terminalrc
echo "==============================\n"

#### Git ####
echo "======= Git setup ======="
cp git/_config $HOME/.gitconfig
cp git/_ignore $HOME/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
echo "=========================\n"

#### Oh-My-Zsh ####
echo "======= ZSH Setup ======="
chsh -s /bin/zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp zsh/_config $HOME/.zshrc
echo "=========================\n"

