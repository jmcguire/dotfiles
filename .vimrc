set ignorecase
set smartcase
set novisualbell
set noautoindent
set nosmartindent
set paste " for better pasting, and no auto-commenting

set wrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab " has to be after set paste

" these are useful, but annoyingly implemented/colored
set nohlsearch
set noshowmatch
let loaded_matchparen = 1 

set bg=dark
syntax on
colorscheme torte

set wildmenu

set encoding=utf-8  " The encoding displayed.
set fileencoding=utf-8  " The encoding written to file.

au BufNewFile,BufRead *.t setfiletype perl " perl test files

" for jumping around via paragaphs, treat a line of whitespace like a blank line
" (update needed: don't wrap past the end of file)
":nmap { ?^\s*$<CR>
":nmap } /^\s*$<CR>

" taken from Ovid
noremap ,c :!time perlc --critic %<cr>
set errorformat+=%m\ at\ %f\ line\ %l\.
set errorformat+=%m\ at\ %f\ line\ %l

" remember marks for 50 files, copy up to 1000 lines, ignore 10kb copies
set viminfo='50,<1000,s10

augroup markdown
    au!
    au BufNewFile,BufRead *.md,*.markdown setlocal filetype=markdown
augroup END



