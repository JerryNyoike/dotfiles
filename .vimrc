" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Vim will load $VIMRUNTIME/defaults.vim if the user does not have a vimrc.
" This happens after /etc/vim/vimrc(.local) are loaded, so it will override
" any settings in these files.
" If you don't want that to happen, uncomment the below line to prevent
" defaults.vim from being loaded.
" let g:skip_defaults_vim = 1

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
filetype plugin indent on

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" set line numbering
set number relativenumber 

set laststatus=2

" remove status
set noshowmode

" wildmenu
set wildmenu

" nerd tree shortcut
noremap < :NERDTreeToggle<CR>

" vim-plug section

" vim-plug auto-install
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')

"Ale linter
Plug 'https://github.com/dense-analysis/ale'

" nerd tree
Plug 'scrooloose/nerdtree'

" elm-vim
Plug 'https://github.com/ElmCast/elm-vim'

" lightline
Plug 'itchyny/lightline.vim'

" vim-gitbranch
Plug 'https://github.com/itchyny/vim-gitbranch'

" rainbow parentheses
Plug 'https://github.com/kien/rainbow_parentheses.vim'

" Rust Vim
Plug 'https://github.com/rust-lang/rust.vim'

call plug#end()

" lightline
let g:lightline = {
			\ 'colorscheme': 'wombat',
			\ 'active': {
			\    'left': [ [ 'mode', 'paste' ],
			\              [ 'gitbranch', 'readonly', 'filename',
			\                'modified'] ]
			\},
			\ 'component_function': {
			\    'gitbranch': 'gitbranch#name'
			\},
			\}

" RainbowParens
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
" au Syntax * RainbowParenthesesLoadSquare
" au Syntax * RainbowParenthesesLoadBraces
"

syntax enable
filetype plugin indent on

" Automatic format for rust files
let g:rustfmt_autosave = 1
