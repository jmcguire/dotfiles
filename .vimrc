set wrap
set tabstop=2
set shiftwidth=2
set expandtab

set ignorecase
set smartcase
set novisualbell
set noautoindent
set nosmartindent

" these are useful, but annoyingly implemented/colored
set nohlsearch
set noshowmatch

set bg=dark
syntax on
colorscheme torte

set wildmenu

au BufNewFile,BufRead *.t setfiletype perl

" taken from Ovid
noremap ,c :!time perlc --critic %<cr>
set errorformat+=%m\ at\ %f\ line\ %l\.
set errorformat+=%m\ at\ %f\ line\ %l

" remember marks for 50 files, copy up to 1000 lines, ignore 10kb copies
set viminfo='50,<1000,s10

