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
Bundle 'altercation/vim-colors-solarized'
Bundle 'scrooloose/nerdtree'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'tpope/vim-fugitive'
Bundle 'Shutnik/jshint2.vim'
Bundle 'marijnh/tern_for_vim'

" Powerline configuration
set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
set laststatus=2

" Colorizes configuration
set background=dark
colorscheme solarized

" NERDTree configuration
autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Keyboard shortcut
map <C-e> :NERDTreeToggle<CR>
