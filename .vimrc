set nocompatible
if has("gui_macvim")
  let macvim_hig_shift_movement = 1
  set backupdir=~/.vim/backups " Where backups will go.
  set directory=~/.vim/tmp     " Where temporary files will go.
else
  source $VIMRUNTIME/vimrc_example.vim
  source $VIMRUNTIME/mswin.vim
  behave mswin
  set backupdir=~/vimfiles/backups " Where backups will go.
  set directory=~/vimfiles/tmp     " Where temporary files will go.
endif

:syntax on
:set incsearch
:set ignorecase smartcase
:set wildmenu

:set history=50

:set showmatch " show matching brackets

"Set tabs to 4 spaces
:set tabstop=4
:set shiftwidth=4
:set softtabstop=4
:set smarttab
:set expandtab
:set autoindent

"vividchalk theme, consolas font

syntax enable
set background=dark
colorscheme solarized

set gfn=Consolas:h9:cANSI

"make sure that bottom status bar is running.
:set ruler
:set laststatus=2

"backups
set backup

set guioptions-=T  "remove toolbar

