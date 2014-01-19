#!/bin/zsh
echo "Start install the configuration:"

############# Start installer #################

#### Initialize ####
mkdir $HOME/.vim
mkdir $HOME/.vim/bundle
mkdir $HOME/.fonts

#### Oh-My-Zsh ####
cp -r oh-my-zsh $HOME/.oh-my-zsh
cp _zshrc $HOME/.zshrc
chsh -s /bin/zsh

#### Solarized Colors ####
sh gnome-terminal-colors/set_dark.sh
cp -r vim/vim-color-solarized $HOME/.vim/bundle/

#### Vim ####
cp -r vim/vundle $HOME/.vim/bundle/
cp _vimrc $HOME/.vimrc	
vim +BundleInstall +qall

#### Powerline ####
pip install --user powerline
cp vim/powerline-fonts/*/*.ttf $HOME/.fonts/
fc-cache -vf $HOME/.fonts/

#### Git ####
cp _gitconfig $HOME/.gitconfig
