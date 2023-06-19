let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')

let g:neo_tree_remove_legacy_commands = 1

call plug#begin()

exec 'silent! source ' . s:path . '/../corp/vim/plugins.vim'

Plug 'altercation/vim-colors-solarized'
Plug 'mg979/vim-visual-multi'
Plug 'rcarriga/nvim-notify'

if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif

"Plug 'ludovicchabant/vim-lawrencium'

Plug 'lifthrasiir/hangeul.vim'

if has('nvim')
  Plug 'ojroques/nvim-osc52'
else
  Plug 'ojroques/vim-oscyank'
endif

Plug 'nvim-lualine/lualine.nvim'

Plug 'liuchengxu/vista.vim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim'

Plug 'lambdalisue/suda.vim'
Plug 'smartpde/tree-sitter-cpp-google'
Plug 'L3MON4D3/LuaSnip', {'do': 'make install_jsregexp'}

if has('nvim')
  Plug 'nvim-lua/plenary.nvim'           " lua helpers
  Plug 'nvim-telescope/telescope.nvim'   " actual plugin

  Plug 'ipod825/libp.nvim'

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
endif

call plug#end()

silent! colorscheme solarized

map <Leader>e <cmd>Neotree left filesystem toggle<cr>

set mouse=a
set nu
set nocompatible

set colorcolumn=80

let hangeul_enabled = 1
let hangeul_default_mode = '3f'
imap <silent> <Leader><CR> <Plug>HanConvert
imap <silent> <Leader><Space> <Plug>HanMode

lua <<EOF
  local path = vim.api.nvim_eval([[fnamemodify(resolve(expand('<sfile>:p')), ':h')]])
  package.path = package.path .. ';' .. path .. '/lua/?.lua'
EOF

exec 'silent! source ' . s:path . '/../corp/vim/init.vim'

autocmd FileType go setlocal sw=4 ts=4 noet

set termguicolors
set sw=2 ts=2 et

if has('nvim')
  let $GIT_EDITOR = 'nvr -cc split --remote-wait'
  let $HGEDITOR = 'nvr -cc split --remote-wait'
  autocmd FileType gitcommit,gitrebase,gitconfig,hgcommit set bufhidden=delete
endif

if has('nvim')
  lua <<EOF
    local function copy(lines, _)
    require('osc52').copy(table.concat(lines, '\n'))
  end

  local function paste()
    return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
  end

  vim.g.clipboard = {
    name = 'osc52',
    copy = {['+'] = copy, ['*'] = copy},
    paste = {['+'] = paste, ['*'] = paste},
  }
EOF
else
  autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankReg +' | endif
  let g:oscyank_term = 'default'
endif

lua <<EOF
  require('libp').setup()
  require('init-lsp').setup()
  require('init-diag')

  require'lualine'.setup(require'lualine-config')

  require('tree-sitter-cpp-google').setup()
  require'nvim-treesitter.configs'.setup {
    -- Modules and its options go here
    ensure_installed = "all",
    sync_install = true,  -- Uncomment when installing on small machine
    highlight = { enable = true },
    incremental_selection = { enable = true },
    textobjects = { enable = true },
    indent = { enable = true },
  }
  if vim.treesitter.highlighter.hl_map ~= nil then
    vim.treesitter.highlighter.hl_map.error = nil
  end
  vim.opt.termguicolors = true
EOF

let g:python3_host_prog = '/usr/bin/python3'
