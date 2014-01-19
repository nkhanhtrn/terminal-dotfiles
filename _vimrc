" Normal vim configuration
set encoding=utf-8
set number
set t_Co=256
set cursorline
syntax enable

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
set guifont=PowerlineSymbols.otf

" Colorizes Configuration
set background=dark
colorscheme solarized

" Keyboard shortcut
map <C-e> :NERDTreeToggle<CR>
