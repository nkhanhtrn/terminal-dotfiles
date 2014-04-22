
# update ZSH configuration
cp _zshrc $HOME/.zshrc

# update VIM configuration
cp _vimrc $HOME/.vimrc	
vim +BundleInstall +qall

# update Git configuration
cp _gitconfig $HOME/.gitconfig
