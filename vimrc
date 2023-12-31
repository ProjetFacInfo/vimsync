set nocompatible                " Disable vi compatiblity

"===================
"=== XDG SUPPORT ===
"===================
if empty($MYVIMRC) | let $MYVIMRC = expand('<sfile>:p') | endif

set runtimepath^=$XDG_CONFIG_HOME/vim
set runtimepath+=$XDG_DATA_HOME/vim
set runtimepath+=$XDG_CONFIG_HOME/vim/after

set packpath^=$XDG_DATA_HOME/vim,$XDG_CONFIG_HOME/vim
set packpath+=$XDG_CONFIG_HOME/vim/after,$XDG_DATA_HOME/vim/after

let g:netrw_home = $XDG_DATA_HOME."/vim"
call mkdir($XDG_DATA_HOME."/vim/spell", 'p', 0700)
set viewdir=$XDG_DATA_HOME/vim/view | call mkdir(&viewdir, 'p', 0700)

set backupdir=$XDG_CACHE_HOME/vim/backup | call mkdir(&backupdir, 'p', 0700)
set directory=$XDG_CACHE_HOME/vim/swap   | call mkdir(&directory, 'p', 0700)
set undodir=$XDG_CACHE_HOME/vim/undo     | call mkdir(&undodir,   'p', 0700)

if !has('nvim') | set viminfofile=$XDG_CACHE_HOME/vim/viminfo | endif

"================
"=== vim-plug ===
"================

" Automatically install vimplug if not installed
let data_dir = '$XDG_CONFIG_HOME/vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Install my plugins
call plug#begin('$XDG_DATA_HOME/vim/plugged')

" Polyglot decides to mess with tab settings for whatever reason
let g:polyglot_disabled = ['autoindent']
Plug 'sheerun/vim-polyglot'
Plug 'vim-scripts/dbext.vim'

Plug 'dracula/vim',{'as':'dracula'}
Plug 'itchyny/vim-cursorword'
Plug 'RRethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'junegunn/goyo.vim'

" Buffers, workflow
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'justinmk/vim-dirvish'
Plug 'Konfekt/FastFold'

" Text operations/manipulation
Plug 'wellle/targets.vim'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-repeat'
Plug 'tommcdo/vim-lion'
Plug 'tommcdo/vim-exchange'
Plug 'mbbill/undotree'
Plug 'zirrostig/vim-schlepp'
Plug 'tomtom/tcomment_vim'
Plug 'mattn/emmet-vim', { 'for': 'html' }
Plug 'preservim/vim-pencil'

Plug 'lifepillar/vim-mucomplete'
Plug 'Thyrum/vim-stabs'

call plug#end()

runtime! macros/matchit.vim

"================
"=== Settings ===
"================
" If you want to know what each setting does you can do :h <setting name>

let loaded_netrw = 1
let loaded_netrwPlugin = 1      "netrw -> 🗑

set encoding=utf-8

set ttyfast lazyredraw
set updatetime=750

set clipboard=unnamedplus

set hidden

set scrolloff=5 sidescrolloff=5

set shortmess=a
set title
set number relativenumber

" Search
set ignorecase smartcase
if has('extra_search')
	set hlsearch incsearch
endif

if has('cmdline_info')
	set ruler showcmd
endif

" Spelling correction
if has('syntax')
	syntax on
	set nospell
	set spelllang=fr
	set cursorline
endif

" Changes cursor shape in different modes
" set Vim-specific sequences for RGB colors and enable truecolor support
if $TERM ==# "st-256color" && has('termguicolors')
	let &t_SI = "\<Esc>[6 q"
	let &t_SR = "\<Esc>[4 q"
	let &t_EI = "\<Esc>[2 q"
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	set termguicolors
elseif $TERM !=# "st-256color" && has('termguicolors')
	set termguicolors
endif

" Tab complete for fuzzy finding
if has('wildmenu')
	set wildmenu wildignorecase wildmode=longest:list,full
	if has('wildignore')
		set wildoptions=pum
		set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.jpe,*.png,*.webp,*.svg
		set wildignore+=*.pdf,*.psd,*.epub,*.ps,*.djvu,*.mobi
		set wildignore+=*.word,*.ods,*.docx,*.odt,*.doc,*.xlsx
		set wildignore+=*.wav,*.mp3,*.flac,*.opus,*.m3u,*.ogg
		set wildignore+=*.mp4,*.mkv,*.webm,*.m4a
		set wildignore+=*.o,*.obj,*.out
		set wildignore+=*/,
		set wildignore+=node_modules/*,bower_components/*
	endif
endif

" Code safety
if has('persistent_undo')       " You can undo changes across sessions
	set undolevels=5000
	set autowriteall undofile autoread
else
	echom "Your system doesn't support persistent undo ! Be careful !"
endif
set updatecount=10

" Project navigation, open vim in the root dir of your project and then
" Use find <filename> to open new buffer with the filename.
" This is neat but I prefer to use e */**<file> since it has better fuzzy
" finding (look at my binding)
" the benefit of find is that it is not relative to your current directory
if has('path_extra')
	set path=$PWD/**
endif

" Folds
if has('folding')
	if (&ft == '')
		set foldmethod=manual
	else
		set foldmethod=syntax
	endif

	set foldnestmax=1
	set foldlevelstart=20
	set foldminlines=0

	" Toggle overview mode (close or open all folds)
	" Mapped to <leader>o (look at mappings)
	function ToggleOverview()
		if &foldlevel > 0
			let b:tmp = &foldlevel
			let &l:foldlevel = 0
		else
			let &l:foldlevel = b:tmp
		endif
	endfunction
endif

" Indentation
filetype plugin indent on
if has('smartindent')
	set autoindent smartindent
else
	set autoindent
endif

" I use the smarttabs plugin so TABS are used to indent at the start of
" lines and spaces are used to align stuff like comments you get the
" best of both worlds ; user customizable indentation and consistent alignment
set tabstop=8
set shiftwidth=0
set noexpandtab

" This function converts the file that I'm editing to my prefferd tabs and
" spaces 'format'.
" To use this function place your cursor on a line with 1 level of indentation!
" because the function needs to know how many spaces = 1 level of indentation
" to be able to convert them back to tabs
function FixTabsAndSpaces()
	" We convert all the tabs to spaces
	set expandtab
	retab

	" We figure out the size of 1 level of indentation
	let faketabsize = indent(line("."))
	let l:tmp = &l:tabstop
	let &l:tabstop = faketabsize

	" Convert the spaces back into tabs only at the start of lines
	set noexpandtab
	RetabIndent

	let &l:tabstop = tmp
endfunction

"-----------------------
"=== Plugin settings ===
"-----------------------

let g:lion_squeeze_spaces = 1

" Autocompletion with mucomplete
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#completion_delay = 300
set completeopt=menuone,noinsert
set infercase

" Lightline plugin get cool triangular font instead of square
" And show open buffers on top, you can swap between buffers with <leader>n
" <leader>p and other keys. look at the mappings!
set laststatus=2
let g:lightline = {
 	\ 'colorscheme':  'dracula',
 	\ 'separator':    { 'left': '', 'right': '' },
 	\ 'subseparator': { 'left': '', 'right': '' },
      	\ 'active': {
      	\   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ]
      	\ },
      	\ 'tabline': {
      	\   'left': [ ['buffers'] ],
      	\   'right': [ ['close'] ]
      	\ },
      	\ 'component_expand': {
      	\   'buffers': 'lightline#bufferline#buffers'
      	\ },
      	\ 'component_type': {
      	\   'buffers': 'tabsel'
      	\ }
      	\ }

set showtabline=2
let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#filename_modifier = ':.'
let g:lightline#bufferline#number_separator = ' '
let g:lightline#bufferline#composed_number_map = {
\ 1:  '#1',  2:  '#2',  3:  '#3',  4:  '#4',  5:  '#5',
\ 6:  '#6',  7:  '#7',  8:  '#8',  9:  '#9',  10: '#10',
\ 11: '#11', 12: '#12', 13: '#13', 14: '#14', 15: '#15',
\ 16: '#16', 17: '#17', 18: '#18', 19: '#19', 20: '#20'}

" dracula theme
let g:dracula_italic = 1
let g:dracula_italic_comments = 1
let g:dracula_underline = 1
let g:dracula_cursor_line_number_background = 1

" Make highligted searches red and highlight column 81 in gray
augroup dracula-theme-overrides
	autocmd!
	autocmd ColorScheme dracula highlight Search term=reverse guifg=fg guibg=#BF616A
	autocmd ColorScheme dracula highlight IncSearch term=reverse gui=underline guifg=fg guibg=#BF616A
	autocmd ColorScheme dracula highlight ColorColumn guibg=#4C566A
augroup END
call matchadd('ColorColumn', '\%81v',100)

colorscheme dracula

" Dirvish file viewer
let g:dirvish_mode = 1
let g:dirvish_relative_paths = 0
call dirvish#add_icon_fn({p -> p[-1:]=='/'?'📂':'📄'})

" Color highligting
let g:Hexokinase_highlighters = [ 'foregroundfull' ]

"=======================
"=== Global Bindings ===
"=======================

let mapleader=" "

" Swap visual and visual-block
nnoremap v <C-V>
nnoremap <C-v> v

" Better bindings for navigating splits
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <leader>q :close<CR>

" Easier saving
map <leader>w :w<CR>

map <leader>f :filetype detect<CR>

" --
" Open files in buffers or splits with fuzzy finding
" --
map <leader>v :vs **/*
map <leader>h :sp **/*
map <leader>e :e **/*

" --
"  Convert camel_case to snake_case
"  --
function CamelCaseToSnakeCase()
	exe "normal :s#\\(\\<\\u\\l\\+\\|\\l\\+\\)\\(\\u\\)#\\l\\1_\\l\\2#g\<CR>"
endfunc
map <leader>sc :call CamelCaseToSnakeCase()<CR>

" --
" Buffer controls with the lightline bufferline plugin
" --
map <leader>cc :bd<CR>

nmap <LEFT> :bprevious<CR>
nmap <RIGHT> :bnext<CR>
nmap <leader>p :bprevious<CR>
nmap <leader>n :bnext<CR>

nmap <Leader>& <Plug>lightline#bufferline#go(1)
nmap <Leader>[ <Plug>lightline#bufferline#go(2)
nmap <Leader>{ <Plug>lightline#bufferline#go(3)
nmap <Leader>} <Plug>lightline#bufferline#go(4)
nmap <Leader>( <Plug>lightline#bufferline#go(5)
nmap <Leader>= <Plug>lightline#bufferline#go(6)
nmap <Leader>* <Plug>lightline#bufferline#go(7)
nmap <Leader>) <Plug>lightline#bufferline#go(8)
nmap <Leader>+ <Plug>lightline#bufferline#go(9)
nmap <Leader>] <Plug>lightline#bufferline#go(10)

nmap <Leader>c& <Plug>lightline#bufferline#delete(1)
nmap <Leader>c[ <Plug>lightline#bufferline#delete(2)
nmap <Leader>c{ <Plug>lightline#bufferline#delete(3)
nmap <Leader>c} <Plug>lightline#bufferline#delete(4)
nmap <Leader>c( <Plug>lightline#bufferline#delete(5)
nmap <Leader>c= <Plug>lightline#bufferline#delete(6)
nmap <Leader>c* <Plug>lightline#bufferline#delete(7)
nmap <Leader>c) <Plug>lightline#bufferline#delete(8)
nmap <Leader>c+ <Plug>lightline#bufferline#delete(9)
nmap <Leader>c] <Plug>lightline#bufferline#delete(10)

" schlepp
vmap <unique> <up>    <Plug>SchleppUp
vmap <unique> <down>  <Plug>SchleppDown
vmap <unique> <left>  <Plug>SchleppLeft
vmap <unique> <right> <Plug>SchleppRight

" SQL Stuff

" Automatically create drop statement at the head of the file for current line
func DropTemplate()
	if getline(".") =~? "TABLE" || getline(".") =~? "VIEW"
		exe "normal 0wy2eggODROP \<Esc>pbiIF EXISTS \<Esc>A;\<Esc><C-o>"
	elseif getline(".") =~? "SEQUENCE"
		exe "normal 0wy2egg}ODROP \<Esc>pbiIF EXISTS \<Esc>A;\<Esc><C-o>"
	endif
endfunc
map <leader>fd :call DropTemplate()<CR>


" Macro to generate sql code from a table template like
" MyTable (Attribute1, Attribute2, Attr3)
func TableTemplate()
	" These strings are basically macros
	let l:TableStruct   = "ICREATE TABLE \<Esc>wvEguf(a\<CR>\<Esc>i\<CR>;\<Esc>h%j"
	let l:ContentStruct = "OPRIMARY KEY (),\<CR>FOREIGN KEY (attribute) REFERENCES table_name(attribute),\<Esc>j0"
	let l:ContentAlign = "0f,i TYPE\<Esc>la\<CR>\<Esc>"
	let l:CallDropTemplate = "?CREATE TABLE \<CR>:call DropTemplate()\<CR>\<C-o>\<C-o>"
	let l:SetPrimaryKey = "3jwye2kf(p"
	let l:EndStruct = "2jV/);\<CR>gl /);\<CR>o\<Esc>j"

	exe "normal " .. TableStruct

	exe "normal " .. ContentStruct
	while getline('.') =~? ','
		exe "normal " .. ContentAlign
	endwhile
	exe "normal a TYPE\<Esc>"

	exe "normal " CallDropTemplate .. SetPrimaryKey .. EndStruct
endfunc
map <leader>ft :call TableTemplate()<CR>

" Take table data and format it for an sql insert
" This quotes integers and dates too because vimscript sucks
func InsertTemplate()
	let l:Clean = "O\<Esc>j}o\<Esc>{j"
	let l:InsertStruct = "OINSERT INTO table_name(attr1,attr2,...)\<CR>VALUES \<Esc>j"
	let l:LineStruct = "A)\<Esc>I(\<Esc>w"
	let l:ContentStruct = "vt S'f r,w"
	let l:EndStruct = "k$r;{3jI\<BS>\<Esc>V}gl(}"

	exe "normal " .. Clean .. InsertStruct

	while getline(".") !~ '^$'
		exe "normal " .. LineStruct
		while getline(".") =~? " "
			exe "normal " .. ContentStruct
		endwhile
		exe "normal vEhS'A,\<Esc>j"
	endwhile
	exe "normal " .. EndStruct
endfunc
map <leader>fi :call InsertTemplate()<CR>

" Fix formatting of data that had spaces in it
func FixInsertValue()
	let l:Fix = "f'vf'c \<Esc>F'j"
	exe "normal " .. Fix
endfunc
map <leader>ff :call FixInsertValue()<CR>

" --
" TOGGLES
" --

" undotree
map <leader>u :UndotreeToggle<CR>

" Disable highlight search
map <silent> <leader><leader> :noh<CR>

" Look at folding settings
map <silent> <leader>o :call ToggleOverview()<CR>

" Toggle ro to avoid editing a file
map <leader>r :call ToggleReadonly()<CR>
function ToggleReadonly()
	if &readonly == 1
		let &readonly=0
	else
		let &readonly=1
	endif
endfunction

" Toggle spellcheck
map <leader>s :setlocal spell!<CR>

" (centered text plugin)
map <leader>g :Goyo<CR>

map <leader>m :!g++ -Wpedantic -O3 %:p -o %:p:r.out && %:p:r.out<CR>

"====================================================
"=== Some autoexec commands and filetype bindings ===
"====================================================

if has('autocmd')
	autocmd FileType tex,latex,markdown setlocal spell! | setlocal fp="fmt -w80"

	autocmd FileType html,css setlocal tabstop=4

	autocmd FileType python,sh set foldmethod=indent


	autocmd BufNewFile,BufRead * if empty(&filetype) | setlocal fp="fmt -w80" | endif

	autocmd BufWritePre *.sql silent %s/\<\w\+\>/\=synIDattr(synID(line('.'),col('.'),1), 'name')=~?'sql\%(keyword\|operator\|statement\|type\|function\)'?toupper(submatch(0)):submatch(0)/g |''

	autocmd BufWritePre * %s/\s\+$//e " Remove trailing spaces

else
	echom "This build does not support autocmds"

	augroup pencil
	  autocmd!
	  autocmd FileType markdown,mkd call pencil#init()
	  autocmd FileType text         call pencil#init() | execute silent :Goyo<CR>
	augroup END
endif
