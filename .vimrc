"---------------------------- vim setting-----------------------------

colorscheme molokai
syntax on
set incsearch
set hidden
set shiftwidth=4
set showmatch
set smarttab

set makeprg=php\ -l\ %
set errorformat=%m\ in\ %f\ on\ line\ %l

let php_sql_query=1
let php_htmlInStrings=1
"let php_folding=1

set tags +=~/.tags

set hlsearch
set ignorecase
set matchtime=2
set ruler
set showmatch
set smartcase
set smartindent
set wildmenu
set noautoindent

" --------------------- Vundle setting ----------------------"
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
"
"Bundle 'Shougo/neocomplete'
"Bundle 'Shougo/neosnippet'
Bundle 'itchyny/lightline.vim'
Bundle 'rking/ag.vim'
"Bundle 'unite.vim'

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


" ------------------------ligthline Setting -----------------

set laststatus=2
set t_Co=256
scriptencoding utf-8
set encoding=utf-8

let g:lightline = {
	    \ 'colorscheme': 'wombat',
	    \ 'mode_map': {'c': 'NORMAL'},
	    \ 'active': {
	    \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
	    \ },
	    \ 'component_function': {
	    \   'modified': 'MyModified',
	    \   'readonly': 'MyReadonly',
	    \   'fugitive': 'MyFugitive',
	    \   'filename': 'MyFilename',
	    \   'fileformat': 'MyFileformat',
	    \   'filetype': 'MyFiletype',
	    \   'fileencoding': 'MyFileencoding',
	    \   'mode': 'MyMode'
	    \ },
            \ 'separator': { 'left': " ＞", 'right': " ｜" },
            \ 'subseparator': { 'left': " ＞", 'right': " ｜" }
	    \ }

function! MyModified()
    return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
    return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! MyFilename()
    return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
		\ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
		\  &ft == 'unite' ? unite#get_status_string() :
		\  &ft == 'vimshell' ? vimshell#get_status_string() :
		\ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
		\ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
    try
	if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
	    return fugitive#head()
	endif
    catch
    endtry
    return ''
endfunction

function! MyFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
    return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
    return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

"--- php syntax error checker --
""
" PHP Lint
nmap ,l :call PHPLint()<CR>

""
" PHPLint
"
" @author halt feits <halt.feits at gmail.com>
"
function PHPLint()
  let result = system( &ft . ' -l ' . bufname(""))
  echo result
endfunction
