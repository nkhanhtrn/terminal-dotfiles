#!/bin/zsh
echo "Start install the configuration:"

############# Start installer #################
#### Install required applications ####
apt-get install -y vim git python-fontforge
#### End ####

#### Oh-My-Zsh ####
sh oh-my-zsh/tools/install.sh
cp _zshrc $HOME/.zshrc	
#### End ####

#### Solarized Colors ####
sh gnome-terminal-colors/set_dark.sh
#### End ####

#### Vim ####
cp vim/bundle/vundle $HOME/.vim/bundle/
cp _vimrc $HOME/.vimrc	
vim +BundleInstall +qall
#### End ####

#### Powerline ####
pip install --user powerline
powerline/font/fontpatcher.py fonts/PowerlineSymbols.otf
mv "PowerlineSymbols for Powerline.otf" $HOME/.fonts/PowerlinerSymbols.otf
fc-cache -vf $HOME/.fonts/
#### End ####

#### Git ####
cp _gitconfig $HOME/.gitconfig
#### End ####
