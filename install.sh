#!/bin/sh
echo "Start install the configuration"

############# Start installer #################

#### Initialize ####
if [ ! -d "$HOME/.vim" ]; then 
    mkdir $HOME/.vim
fi
if [ ! -d "$HOME/.vim/bundle" ]; then 
    mkdir $HOME/.vim/bundle
fi
if [ ! -d "$HOME/.vim/colors" ]; then 
    mkdir $HOME/.vim/colors
fi
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

#### Vim ####
echo "======= Vim Setup ======="
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp -r vim/vim-colors-solarized/colors/solarized.vim $HOME/.vim/colors/
cp vim/_config $HOME/.vimrc	
vim +BundleInstall +qall
echo "=========================\n"

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

