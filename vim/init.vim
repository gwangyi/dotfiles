let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')

call plug#begin()

exec 'silent! source ' . s:path . '/../corp/vim/plugins.vim'

Plug 'junegunn/vim-easy-align'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Shougo/denite.nvim'
Plug 'terryma/vim-multiple-cursors'

Plug 'scrooloose/nerdtree'
Plug 'brentyi/nerdtree-hg-plugin'  " f4t-t0ny/nerdtree-hg-plugin has been broken

Plug 'dense-analysis/ale'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'cespare/vim-toml'

Plug 'pedrohdz/vim-yaml-folds'
Plug 'leafOfTree/vim-vue-plugin'

if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

call plug#end()

let g:solarized_termtrans=1
silent! colorscheme solarized

let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#enabled = 1
set laststatus=2

map <Leader>e :NERDTreeFocus<cr>

let g:vim_vue_plugin_use_typescript	= 1

set mouse=a
set nu
set nocompatible

set colorcolumn=80

exec 'silent! source ' . s:path . '/../corp/vim/init.vim'

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

autocmd FileType go setlocal sw=4 ts=4 et

set termguicolors
set sw=2 ts=2 et

let $MANPAGER=''
