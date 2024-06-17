syntax on
set nu
set paste
set relativenumber
set ignorecase
set scrolloff=20
set clipboard+=unnamed
set tabstop=4     " tabs are at proper location
set expandtab     " don't use actual tab character (ctrl-v)
set shiftwidth=4  " indenting is 4 spaces
set autoindent    " turns it on
set smartindent   " does the right thing (mostly) in programs
set cindent       " stricter rules for C programs

let mapleader = " "
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

nmap <leader>q :q<CR>
nmap <leader>w :w<CR>
nmap <leader>nl :nohlsearch<CR>

nmap <leader>v <C-v>

inoremap jj <ESC>

vmap <leader>d :g/^\s*$/d<CR> " delete blank lines
nmap <leader>d :g/^\s*$/d<CR> " delete blank lines
