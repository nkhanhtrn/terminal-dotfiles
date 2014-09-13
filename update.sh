
# update ZSH configuration
cp zsh/_config $HOME/.zshrc

# update VIM configuration
cp vim/_config $HOME/.vimrc	
vim +BundleInstall +qall

# update Git configuration
cp git/_config $HOME/.gitconfig

# update Terminal configuration
cp terminal/_config $HOME/.config/xfce4/terminal/terminalrc
