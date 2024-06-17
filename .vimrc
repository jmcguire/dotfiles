set ignorecase
set smartcase
set novisualbell
set noautoindent
set nosmartindent
set paste " for better pasting, and no auto-commenting
"set mouse=a " use mouse scrolling

set wrap
set tabstop=4 " what hard tabs are shown as
set shiftwidth=4 " how many columns indent-operations will indent by
set softtabstop=4 " only matters if noexpandtab, just make it same as tabstop
set expandtab " has to be after set paste

"au BUfNewFile,BufRead *py
"    \ set tabstop=8
"    \ set shiftwidth=4
"    \ set softtabstop=4
"    \ set expandtab
"    \ set foldmethod=indent " enabled code folding, with za
"    \ set foldlevel=99

" these are useful, but annoyingly implemented/colored
set nohlsearch
set noshowmatch
let loaded_matchparen = 1 

set bg=dark
syntax on

set wildmenu

set encoding=utf-8  " The encoding displayed.
set fileencoding=utf-8  " The encoding written to file.
set ffs=unix " unix file endings

au BufNewFile,BufRead *.t setfiletype perl " perl test files
au BufNewFile,BufRead *.esp setfiletype perl " html files, filled with perl

" for jumping around via paragaphs, treat a line of whitespace like a blank line
" (update needed: don't wrap past the end of file)
":nmap { ?^\s*$<CR>
":nmap } /^\s*$<CR>

" taken from Ovid
noremap ,c :!time perlc --critic %<cr>
set errorformat+=%m\ at\ %f\ line\ %l\.
set errorformat+=%m\ at\ %f\ line\ %l

" remember marks for 50 files, copy up to 1000 lines, ignore 10kb copies
set viminfo='50,<1000 ",s10

augroup markdown
    au!
    au BufNewFile,BufRead *.md,*.markdown setlocal filetype=markdown
augroup END

" markdown options, from https://github.com/plasticboy/vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_emphasis_multiline = 0
let g:vim_markdown_conceal = 0

" vim-plug, my plugin manager, https://github.com/junegunn/vim-plug
" call plug#begin('~/.vim/plugged')
" Plug 'ssh://git@bitbucket.athenahealth.com:7999/dt/athena-vim.git', { 'branch': 'release' }
" call plug#end()

syntax match nonascii "[^\x00-\x7F]"
highlight nonascii guibg=Red ctermbg=2

syntax enable
colorscheme dracula

