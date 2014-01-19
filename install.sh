#!/bin/zsh
echo "Start install the configuration:"

############# Start installer #################
#
#### Oh-My-Zsh ####
cp -r oh-my-zsh $HOME/.oh-my-zsh
cp _zshrc $HOME/.zshrc
chsh -s /bin/zsh
#### End ####

#### Solarized Colors ####
sh gnome-terminal-colors/set_dark.sh
#### End ####

#### Vim ####
mkdir $HOME/.vim
mkdir $HOME/.vim/bundle
cp -r vim/bundle/vundle $HOME/.vim/bundle/
cp _vimrc $HOME/.vimrc	
vim +BundleInstall +qall
#### End ####

#### Powerline ####
pip install --user powerline
mkdir $HOME/.fonts
cp vim/powerline-fonts/*/*.ttf $HOME/.fonts/
fc-cache -vf $HOME/.fonts/
#### End ####

#### Git ####
cp _gitconfig $HOME/.gitconfig
#### End ####
