call plug#begin()

Plug 'junegunn/vim-easy-align'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Shougo/denite.nvim'
Plug 'terryma/vim-multiple-cursors'

Plug 'scrooloose/nerdtree'
Plug 'f4t-t0ny/nerdtree-hg-plugin'

Plug 'dense-analysis/ale'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'cespare/vim-toml'

Plug 'pedrohdz/vim-yaml-folds'

if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif

call plug#end()

let g:solarized_termtrans=1
silent! colorscheme solarized

let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#enabled = 1
set laststatus=2

map <Leader>e :NERDTreeFocus<cr>

set mouse=a
set nu
set nocompatible

let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
exec 'silent! source ' . s:path . '/../corp/vim/init.vim'
