" zzz-site-config.vim
"
" VIM Plugin for site-wide configuration
"
set nocompatible

" Make sure this file runs only once to avoid infinite loops when re-loadng
" plugins
if exists('g:loaded_site_config')
  finish
else
  let g:loaded_site_config = 1
endif
" load plugins with pathogen
execute pathogen#infect()
" Re-read plugins after pathogen did its magic
runtime! plugin/*.vim

if has("gui_running")
  set background=light
  set lines=45
  set columns=150
else
  set background=dark
endif

" Suffixes that get lower priority when doing tab completion for filenames.
" " These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

set linebreak           " Don't wrap words by default
set textwidth=80
set backupcopy=yes      " Keep a backup file
set hidden
set ignorecase          " Do case insensitive matching
set autowrite           " Automatically save before commands like :next and :make

" Open quickfix window after running grep with vim-fugitive
autocmd QuickFixCmdPost *grep* cwindow

" Prevent MiniBufExplorer from openning tabs in the NERDTree window
let g:miniBufExplModSelTarget = 1
" Make MBE work with <C-TAB> and <C-S_TAB>
let g:miniBufExplMapCTabSwitchBufs = 1

" Don't open NERDTree on startup
let g:nerdtree_tabs_open_on_gui_startup = 0
" Open NERDTree with F9
nnoremap <silent> <F9> :NERDTreeMirrorToggle<CR>
" Close NERDTree when file is opened
let NERDTreeQuitOnOpen = 1

" Completion settings
set completeopt=menuone,longest,preview

" Fall back to syntax-based omni-completion if there isnt a function defined for
" the specific langage
" Also make SuperTab use omni completion if a naive function is defined for the
" opened file
autocmd Filetype *
	\ if &omnifunc == "" |
	\ 	setlocal omnifunc=syntaxcomplete#Complete |
	\ else |
	\ 	let g:SuperTabDefaultCompletionType="<c-x><c-o>" |
	\ endif

" File type specific setings
au FileType ruby setlocal shiftwidth=2
au FileType ruby setlocal expandtab
au FileType ruby setlocal number

au FileType puppet setlocal shiftwidth=2
au FileType puppet setlocal expandtab
au FileType puppet setlocal number

au FileType php setlocal number
au FileType php setlocal nowrap

