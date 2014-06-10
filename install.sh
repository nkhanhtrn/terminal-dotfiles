#!/bin/zsh
echo "Start install the configuration:"

############# Start installer #################

#### Initialize ####
if [ ! -d "$HOME/.vim" ]; then 
    mkdir $HOME/.vim
fi
if [ ! -d "$HOME/.vim/bundle" ]; then 
    mkdir $HOME/.vim/bundle
fi
if [ ! -d "$HOME/.fonts" ]; then 
    mkdir $HOME/.fonts
fi
if [ ! -d "$HOME/.solarized" ]; then
    mkdir $HOME/.solarized
fi
if [ ! -d "$HOME/.conkerorrc" ]; then
    mkdir $HOME/.conkerorrc
fi

#### Oh-My-Zsh ####
chsh -s /bin/zsh
cp -r zsh/oh-my-zsh $HOME/.oh-my-zsh
cp _zshrc $HOME/.zshrc

#### Solarized Colors ####
sh solarized/gnome-terminal-colors-solarized/set_dark.sh
cp -r vim/vim-colors-solarized $HOME/.vim/bundle/
cp solarized/gedit_solarized_dark.xml $HOME/.solarized/

#### Vim ####
cp -r vim/vundle $HOME/.vim/bundle/
cp _vimrc $HOME/.vimrc	
vim +BundleInstall +qall

#### Powerline ####
pip install --user vim/powerline
cp vim/powerline-fonts/*/*.ttf $HOME/.fonts/
fc-cache -vf $HOME/.fonts/

#### JSHint ###
cp _jshintrc $HOME/.jshintrc

#### Git ####
cp _gitconfig $HOME/.gitconfig

#### Conkeror ###
cp -r conkeror/* $HOME/.conkerorrc/

#### NPM Packages ###
npm install -g bower jshint
