echo "Start install the configuration:"

### Start installer #################
# Oh-My-Zsh
sh oh-my-zsh/tools/install.sh

# Terminal Solarized
sh gnome-terminal-colors/dark.sh

# Vim Solarized
cp solarized/vim-colors-solarized/colors/ solarized.vim 

# Copy configuration file
cp _zshrc $HOME/.zshrc
cp _vimrc $HOME/.vimrc
