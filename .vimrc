colorscheme molokai

set incsearch
set hidden
set shiftwidth=4
set showmatch
set smarttab

set makeprg=php\ -l\ %
set errorformat=%m\ in\ %f\ on\ line\ %l

let php_sql_query=1
let php_htmlInStrings=1
let php_folding=1

set tags +=~/.tags

set hlsearch
set ignorecase
set matchtime=2
set ruler
set showmatch
set smartcase
set smartindent
set wildmenu


" Vim admin  Vundle"
set nocompatible               " be iMproved
filetype off                   " required!
set rtp+=~/.vim/vundle.git/
call vundle#rc()
" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'


" My Bundles here:
"
" original repos on github
"Bundle 'tpope/vim-fugitive'
"Bundle 'Lokaltog/vim-easymotion'
"Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
"Bundle 'tpope/vim-rails.git'
"
" vim-scripts repos
"Bundle 'L9'
"Bundle 'FuzzyFinder'
" non github repos
"Bundle 'git://git.wincent.com/command-t.git'
" ...
filetype plugin indent on     " required!
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..

