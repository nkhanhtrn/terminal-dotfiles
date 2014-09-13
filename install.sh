#!/bin/zsh
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
if [ ! -d "$HOME/.fonts" ]; then 
    mkdir $HOME/.fonts
fi
if [ ! -d "$HOME/.solarized" ]; then
    mkdir $HOME/.solarized
fi

if [ ! -d "$HOME/.config/xfce4/terminal" ]; then
    mkdir $HOME/.config/xfce4/terminal
fi

#### Oh-My-Zsh ####
echo "======= ZSH Setup ======="
chsh -s /bin/zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp zsh/_config $HOME/.zshrc
echo "=========================\n"

#### Vim ####
echo "======= Vim Setup ======="
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp -r vim/vim-colors-solarized/colors/solarized.vim $HOME/.vim/colors/
cp vim/_config $HOME/.vimrc	
vim +BundleInstall +qall
echo "=========================\n"

#### Powerline ####
echo "======= Powerline setup ======="
pip install --user git+git://github.com/Lokaltog/powerline
cp vim/powerline-fonts/*/*.ttf $HOME/.fonts/
fc-cache -vf $HOME/.fonts/
echo "===============================\n"

#### Terminal Configuration ####
echo "======= XFCE4 Terminal setup ======="
cp terminal/_config $HOME/.config/xfce4/terminal/terminalrc
echo "==============================\n"

#### Git ####
echo "======= Git setup ======="
cp git/_config $HOME/.gitconfig
echo "=========================\n"
