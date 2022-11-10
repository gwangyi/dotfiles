let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
lua <<EOF
  local path = vim.api.nvim_eval("fnamemodify(resolve(expand('<sfile>:p')), ':h')")
  package.path = package.path .. ';' .. path .. '/lua/?.lua'
EOF

call plug#begin()

exec 'silent! source ' . s:path . '/../corp/vim/plugins.vim'

Plug 'altercation/vim-colors-solarized'
Plug 'terryma/vim-multiple-cursors'

Plug 'scrooloose/nerdtree'
Plug 'brentyi/nerdtree-hg-plugin'  " f4t-t0ny/nerdtree-hg-plugin has been broken

if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif

Plug 'ludovicchabant/vim-lawrencium'

Plug 'lifthrasiir/hangeul.vim'

Plug 'ojroques/vim-oscyank'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" LSP
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'neovim/nvim-lspconfig'
Plug 'onsails/lspkind.nvim'

" Diagnostics
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'

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

set colorcolumn=80

let hangeul_enabled = 1
let hangeul_default_mode = '3f'
imap <silent> <Leader><CR> <Plug>HanConvert
imap <silent> <Leader><Space> <Plug>HanMode

exec 'silent! source ' . s:path . '/../corp/vim/init.vim'

autocmd FileType go setlocal sw=4 ts=4 et

set termguicolors
set sw=2 ts=2 et

if has('nvim')
  let $GIT_EDITOR = 'nvr -cc split --remote-wait'
  let $HGEDITOR = 'nvr -cc split --remote-wait'
  autocmd FileType gitcommit,gitrebase,gitconfig,hgcommit set bufhidden=delete
endif
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankReg +' | endif
let g:oscyank_term = 'default'

lua <<EOF
  require('lsp').setup()
  require('diagnotics')
EOF
