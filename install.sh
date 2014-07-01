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
if [ ! -d "$HOME/.vim/colors" ]; then 
    mkdir $HOME/.vim/colors
fi
if [ ! -d "$HOME/.fonts" ]; then 
    mkdir $HOME/.fonts
fi
if [ ! -d "$HOME/.solarized" ]; then
    mkdir $HOME/.solarized
fi

#### Oh-My-Zsh ####
chsh -s /bin/zsh
cp -r zsh/oh-my-zsh $HOME/.oh-my-zsh
cp _zshrc $HOME/.zshrc

#### Solarized Colors ####
cp -r vim/vim-colors-solarized/colors/solarized.vim $HOME/.vim/colors/

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
