echo "Start install the configuration:"

############# Start installer #################
#### Install required applications ####
apt-get install -y vim git 
#### End ####

#### Oh-My-Zsh ####
sh oh-my-zsh/tools/install.sh			# Install oh-my-zsh
cp _zshrc $HOME/.zshrc				# Copy zsh configuration
#### End ####

#### Solarized Colors ####
sh gnome-terminal-colors/set_dark.sh		# Install Solarized colors for GNOME terminal
#### End ####

#### Vim ####
cp vim/bundle/vundle $HOME/.vim/bundle/		# Vim plugin manager Vundle
cp _vimrc $HOME/.vimrc				# Copy configuration file
vim +BundleInstall +qall			# Install vim plugins using Vundle
#### End ####

#### Git ####
cp _gitconfig $HOME/.gitconfig
#### End ####
