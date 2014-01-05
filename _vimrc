" Add-on management using Vunble
set rtp+=$HOME/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'scrooloose/nerdtree'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'tpope/vim-fugitive'
Bundle 'altercation/vim-colors-solarized'

" Powerline Configuration
set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
set laststatus=2

" Colorizes Configuration
syntax enable
set background=dark
colorscheme solarized

" General Vim Configuration
set t_Co=256
set number

" Keyboard shortcut
map <C-e>: NerdTreeToggle<CR>
