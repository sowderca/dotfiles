" Minimal desired settings
set list
set number
set hidden
set cursorline

set background=dark
set shortmess+=c
set shiftwidth=4
set signcolumn=yes
set titlestring=VIM
set wildoptions-=pum
set fileformats=unix,mac,dos

const s:gui     = has('gui_running') || strlen(&term) == 0 || &term ==? 'builtin_gui'
const s:neovim  = has('nvim')
const s:windows = has('win16') || has('win32') || has('win64')

const gruvbox_material_foreground = 'mix'
const gruvbox_material_background = 'medium'
const gruvbox_material_enable_bold = 1
const gruvbox_material_better_performance = 1
const gruvbox_material_disable_italic_comment = 0
const gruvbox_material_diagnostic_text_highlight = 1
const gruvbox_material_diagnostic_line_highlight = 1

silent! colorscheme gruvbox-material

" On Windows, also use ~/.vim instead of vimfiles... Although these days I usually just use WSL
if s:windows
  if !s:neovim
    if has('multi_byte') || (has('gui_running') && &encoding ==# 'latin1')
      set encoding=utf-8
    endif
  endif
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

if has('mouse') || s:neovim
  set mouse=a
endif

if has('clipboard') || s:neovim
  set clipboard+=unnamedplus
endif

if v:version >= 704
  set expandtab
endif

if v:version >= 800 || s:neovim
  " set listchars=tab:→\ ,trail:·,extends:…,precedes:…
  set listchars=tab:→\ ,trail:·,nbsp:•,extends:…,precedes:…
endif

if exists('+termguicolors')
  set termguicolors
endif

if has('windows')
  set splitbelow
endif

if has('vertsplit')
  set splitright
endif

if has('cmdline_hist')
  set history=500
endif

if s:gui
  set guioptions-=L
  set guioptions-=T
  set guioptions-=m
  set guioptions-=r
endif

if !s:neovim
  set smarttab
  set autoread
  set autoindent
  set langnoremap

  set belloff=all
  set display=lastline
  set nrformats=bin,hex
  set backspace=indent,eol,start
  set laststatus=2
  set sidescroll=1
  set tabpagemax=50
  set formatoptions=tcqj

  set ttyfast
  set viminfo^=!
  set ttymouse=xterm2

  if has('syntax') && !exists('g:syntax_on')
    syntax enable
  endif

  if has('extra_search') && has('reltime')
    set hlsearch incsearch
  endif

  if has('cmdline_info')
    set showcmd ruler
  endif

  if has('autocmd')
    filetype plugin indent on
  endif

  if has('wildmenu')  | set wildmenu                | endif
  if has('mksession') | set sessionoptions-=options | endif
  if exists('+fsync') | set nofsync                 | endif

  if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &runtimepath) ==# ''
    runtime! macros/matchit.vim
  endif

endif

if has('autocmd')
  autocmd FileType json syntax match Comment +\/\/.\+$+

  function! CheckGitCommit()
    :3
    setlocal expandtab shiftwidth=2 tabstop=2 textwidth=80 colorcolumn=+1
    if has('spell')
      setlocal spell
    endif
    :highlight SpellBad ctermfg=red ctermbg=white
  endfunction

  augroup FileSettings
    autocmd!
    autocmd FileType gitcommit call CheckGitCommit()
  augroup END

endif

highlight Comments cterm=italic gui=italic

scriptencoding utf-8
